using Moq;
using Xunit;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Interfaces;
using TaskManagement.Application.Services;
using TaskManagement.Domain.Entities;
using Microsoft.Extensions.Logging;

namespace TaskManagement.Application.Tests
{
    public class AuthServiceTests
    {
        private readonly Mock<IUserRepository> _userRepoMock;
        private readonly Mock<IRoleRepository> _roleRepoMock;
        private readonly Mock<ITokenService> _tokenServiceMock;
        private readonly Mock<ILogger<AuthService>> _loggerMock;
        private readonly AuthService _authService;

        public AuthServiceTests()
        {
            _userRepoMock = new Mock<IUserRepository>();
            _roleRepoMock = new Mock<IRoleRepository>();
            _tokenServiceMock = new Mock<ITokenService>();
            _loggerMock = new Mock<ILogger<AuthService>>();

            _authService = new AuthService(
                _userRepoMock.Object,
                _roleRepoMock.Object,
                _tokenServiceMock.Object,
                _loggerMock.Object);
        }

        [Fact]
        public async Task RegisterAsync_ShouldThrow_WhenEmailAlreadyExists()
        {
            // Arrange
            _userRepoMock.Setup(r => r.EmailExistsAsync("existing@test.com"))
                          .ReturnsAsync(true);

            var dto = new RegisterDTO
            {
                Username = "testuser",
                Email = "existing@test.com",
                Password = "Test123!"
            };

            // Act + Assert
            await Assert.ThrowsAsync<InvalidOperationException>(
                () => _authService.RegisterAsync(dto));
        }

        [Fact]
        public async Task RegisterAsync_ShouldSucceed_WhenEmailIsNew()
        {
            // Arrange
            _userRepoMock.Setup(r => r.EmailExistsAsync("new@test.com"))
                          .ReturnsAsync(false);

            _roleRepoMock.Setup(r => r.GetByNameAsync("User"))
                          .ReturnsAsync(new Role { Id = 2, Name = "User" });

            var dto = new RegisterDTO
            {
                Username = "newuser",
                Email = "new@test.com",
                Password = "Test123!"
            };

            // Act
            var result = await _authService.RegisterAsync(dto);

            // Assert
            Assert.Equal("new@test.com", result.Email);
            Assert.Equal("newuser", result.Username);
            Assert.Equal("User", result.Role);
            _userRepoMock.Verify(r => r.AddAsync(It.IsAny<User>()), Times.Once);
            _userRepoMock.Verify(r => r.SaveChangesAsync(), Times.Once);
        }

        [Fact]
        public async Task LoginAsync_ShouldThrow_WhenUserNotFound()
        {
            // Arrange
            _userRepoMock.Setup(r => r.GetByEmailAsync("nouser@test.com"))
                          .ReturnsAsync((User?)null);

            var dto = new LoginDTO { Email = "nouser@test.com", Password = "anything" };

            // Act + Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(
                () => _authService.LoginAsync(dto));
        }

        [Fact]
        public async Task LoginAsync_ShouldThrow_WhenPasswordIsWrong()
        {
            // Arrange
            var hasher = new Microsoft.AspNetCore.Identity.PasswordHasher<User>();
            var user = new User
            {
                Id = 1,
                Username = "testuser",
                Email = "test@test.com",
                RoleId = 2,
                Role = new Role { Id = 2, Name = "User" }
            };
            user.PasswordHash = hasher.HashPassword(user, "CorrectPassword123");

            _userRepoMock.Setup(r => r.GetByEmailAsync("test@test.com"))
                          .ReturnsAsync(user);

            var dto = new LoginDTO { Email = "test@test.com", Password = "WrongPassword" };

            // Act + Assert
            await Assert.ThrowsAsync<UnauthorizedAccessException>(
                () => _authService.LoginAsync(dto));
        }

        [Fact]
        public async Task LoginAsync_ShouldReturnToken_WhenCredentialsAreCorrect()
        {
            // Arrange
            var hasher = new Microsoft.AspNetCore.Identity.PasswordHasher<User>();
            var user = new User
            {
                Id = 1,
                Username = "testuser",
                Email = "test@test.com",
                RoleId = 2,
                Role = new Role { Id = 2, Name = "User" }
            };
            user.PasswordHash = hasher.HashPassword(user, "CorrectPassword123");

            _userRepoMock.Setup(r => r.GetByEmailAsync("test@test.com"))
                          .ReturnsAsync(user);
            _tokenServiceMock.Setup(t => t.GenerateToken(user))
                              .Returns("fake-jwt-token");

            var dto = new LoginDTO { Email = "test@test.com", Password = "CorrectPassword123" };

            // Act
            var token = await _authService.LoginAsync(dto);

            // Assert
            Assert.Equal("fake-jwt-token", token);
        }
    }
}