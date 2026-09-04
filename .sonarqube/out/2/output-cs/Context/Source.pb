¼*
gD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application.Tests\AuthServiceTests.cs»)using Moq;
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
}ParseOptions.0.jsonÿ7
gD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application.Tests\TaskServiceTests.csþ6using System;
using System.Collections.Generic;
using System.Text;
using Moq;
using Xunit;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Exceptions;
using TaskManagement.Application.Interfaces;
using TaskManagement.Application.Services;
using TaskManagement.Domain.Entities;
using TaskManagement.Domain.Enums;
using Microsoft.Extensions.Logging;

namespace TaskManagement.Application.Tests
{
    public class TaskServiceTests
    {
        private readonly Mock<ITaskRepository> _taskRepoMock;
        private readonly Mock<IUserRepository> _userRepoMock;
        private readonly Mock<ILogger<TaskService>> _loggerMock;
        private readonly TaskService _taskService;

        public TaskServiceTests()
        {
            _taskRepoMock = new Mock<ITaskRepository>();
            _userRepoMock = new Mock<IUserRepository>();
            _loggerMock = new Mock<ILogger<TaskService>>();

            _taskService = new TaskService(
                _taskRepoMock.Object,
                _userRepoMock.Object,
                _loggerMock.Object);
        }

        private static TaskItem BuildTask(int id, int createdBy, int assignedTo)
        {
            return new TaskItem
            {
                Id = id,
                Title = "Sample Task",
                Description = "Sample",
                Status = WorkStatus.Pending,
                Priority = TaskPriority.Medium,
                CategoryId = 1,
                Category = new TaskCategory { Id = 1, Name = "Work" },
                DueDate = DateTime.UtcNow.AddDays(1),
                CreatedByUserId = createdBy,
                CreatedByUser = new User { Id = createdBy, Username = "creator" },
                AssignedToUserId = assignedTo,
                AssignedToUser = new User { Id = assignedTo, Username = "assignee" },
                IsDeleted = false,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };
        }

        [Fact]
        public async Task DeleteTaskAsync_ShouldSucceed_WhenUserDeletesOwnSelfCreatedTask()
        {
            // Arrange: task created by user 1, assigned to user 1 (self-created)
            var task = BuildTask(id: 1, createdBy: 1, assignedTo: 1);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act
            await _taskService.DeleteTaskAsync(taskId: 1, currentUserId: 1, currentUserRole: "User");

            // Assert
            Assert.True(task.IsDeleted);
            _taskRepoMock.Verify(r => r.SaveChangesAsync(), Times.Once);
        }

        [Fact]
        public async Task DeleteTaskAsync_ShouldThrow_WhenUserTriesToDeleteAdminAssignedTask()
        {
            // Arrange: task created by admin (user 2), assigned to user 1 â€” not self-created
            var task = BuildTask(id: 1, createdBy: 2, assignedTo: 1);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act + Assert
            await Assert.ThrowsAsync<ForbiddenAccessException>(
                () => _taskService.DeleteTaskAsync(taskId: 1, currentUserId: 1, currentUserRole: "User"));
        }

        [Fact]
        public async Task DeleteTaskAsync_ShouldSucceed_WhenAdminDeletesAnyTask()
        {
            // Arrange: task created and assigned to a regular user, admin deletes it
            var task = BuildTask(id: 1, createdBy: 1, assignedTo: 1);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act
            await _taskService.DeleteTaskAsync(taskId: 1, currentUserId: 99, currentUserRole: "Admin");

            // Assert
            Assert.True(task.IsDeleted);
        }

        [Fact]
        public async Task CreateTaskAsync_ShouldForceSelfAssignment_WhenRegularUserProvidesDifferentAssignee()
        {
            // Arrange: regular user tries to assign task to someone else via the DTO
            var dto = new CreateTaskDTO
            {
                Title = "New Task",
                Description = "Test",
                Priority = 1,
                CategoryId = 1,
                DueDate = DateTime.UtcNow.AddDays(1),
                AssignedToUserId = 999 // attempting to assign to someone else
            };

            TaskItem? capturedTask = null;
            _taskRepoMock.Setup(r => r.AddAsync(It.IsAny<TaskItem>()))
                          .Callback<TaskItem>(t => capturedTask = t)
                          .Returns(Task.CompletedTask);
            _taskRepoMock.Setup(r => r.GetByIdAsync(It.IsAny<int>()))
                          .ReturnsAsync(() => capturedTask);

            // Act
            await _taskService.CreateTaskAsync(dto, currentUserId: 5, currentUserRole: "User");

            // Assert â€” regardless of dto.AssignedToUserId, task must be assigned to the current user
            Assert.NotNull(capturedTask);
            Assert.Equal(5, capturedTask!.AssignedToUserId);
            Assert.Equal(5, capturedTask.CreatedByUserId);
        }

        [Fact]
        public async Task CreateTaskAsync_ShouldAllowAdminToAssignToAnotherUser()
        {
            // Arrange
            var dto = new CreateTaskDTO
            {
                Title = "Admin Assigned Task",
                Description = "Test",
                Priority = 2,
                CategoryId = 1,
                DueDate = DateTime.UtcNow.AddDays(1),
                AssignedToUserId = 42
            };

            _userRepoMock.Setup(r => r.GetByIdAsync(42))
                          .ReturnsAsync(new User { Id = 42, Username = "assignee" });

            TaskItem? capturedTask = null;
            _taskRepoMock.Setup(r => r.AddAsync(It.IsAny<TaskItem>()))
                          .Callback<TaskItem>(t => capturedTask = t)
                          .Returns(Task.CompletedTask);
            _taskRepoMock.Setup(r => r.GetByIdAsync(It.IsAny<int>()))
                          .ReturnsAsync(() => capturedTask);

            // Act
            await _taskService.CreateTaskAsync(dto, currentUserId: 1, currentUserRole: "Admin");

            // Assert
            Assert.NotNull(capturedTask);
            Assert.Equal(42, capturedTask!.AssignedToUserId);
            Assert.Equal(1, capturedTask.CreatedByUserId);
        }

        [Fact]
        public async Task GetTaskByIdAsync_ShouldThrow_WhenUserHasNoRelationToTask()
        {
            // Arrange: task belongs to user 1 and 2, current user is 3 (unrelated)
            var task = BuildTask(id: 1, createdBy: 1, assignedTo: 2);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act + Assert
            await Assert.ThrowsAsync<ForbiddenAccessException>(
                () => _taskService.GetTaskByIdAsync(taskId: 1, currentUserId: 3, currentUserRole: "User"));
        }
    }
}
ParseOptions.0.jsonì
{C:\Users\Super Computer Bannu\.nuget\packages\microsoft.net.test.sdk\17.14.1\build\net8.0\Microsoft.NET.Test.Sdk.Program.cs×// <auto-generated> This file has been auto generated. </auto-generated>
using System;
[Microsoft.VisualStudio.TestPlatform.TestSDKAutoGeneratedCode]
class AutoGeneratedProgram {static void Main(string[] args){}}ParseOptions.0.json·
˜D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application.Tests\obj\Debug\net10.0\TaskManagement.Application.Tests.GlobalUsings.g.cs„// <auto-generated/>
global using System;
global using System.Collections.Generic;
global using System.IO;
global using System.Linq;
global using System.Net.Http;
global using System.Threading;
global using System.Threading.Tasks;
global using Xunit;
ParseOptions.0.jsonø
•D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application.Tests\obj\Debug\net10.0\.NETCoreApp,Version=v10.0.AssemblyAttributes.csÈ// <autogenerated />
using System;
using System.Reflection;
[assembly: global::System.Runtime.Versioning.TargetFrameworkAttribute(".NETCoreApp,Version=v10.0", FrameworkDisplayName = ".NET 10.0")]
ParseOptions.0.json‡

–D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application.Tests\obj\Debug\net10.0\TaskManagement.Application.Tests.AssemblyInfo.csÖ//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Reflection;

[assembly: System.Reflection.AssemblyCompanyAttribute("TaskManagement.Application.Tests")]
[assembly: System.Reflection.AssemblyConfigurationAttribute("Debug")]
[assembly: System.Reflection.AssemblyFileVersionAttribute("1.0.0.0")]
[assembly: System.Reflection.AssemblyInformationalVersionAttribute("1.0.0+1fe372dbe293cb307e8228638d7dd6674e2101d8")]
[assembly: System.Reflection.AssemblyProductAttribute("TaskManagement.Application.Tests")]
[assembly: System.Reflection.AssemblyTitleAttribute("TaskManagement.Application.Tests")]
[assembly: System.Reflection.AssemblyVersionAttribute("1.0.0.0")]

// Generated by the MSBuild WriteCodeFragment class.

ParseOptions.0.json