using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Interfaces;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Application.Services
{
    public class AuthService
    {
        private readonly IUserRepository _userRepository;
        private readonly IRoleRepository _roleRepository;
        private readonly PasswordHasher<User> _passwordHasher;
        private readonly ITokenService _tokenService;
        private readonly ILogger<AuthService> _logger;


        public AuthService(IUserRepository userRepository, IRoleRepository roleRepository, ITokenService tokenService, ILogger<AuthService> logger)
        {
            _userRepository = userRepository;
            _roleRepository = roleRepository;
            _passwordHasher = new PasswordHasher<User>();
            _tokenService = tokenService;
            _logger = logger;
        }

        public async Task<UserDTO> SetupAdminAsync(RegisterDTO dto)
        {
            // work only when no admin exists na kare
            var adminRole = await _roleRepository.GetByNameAsync("Admin");
            if (adminRole == null)
            {
                throw new InvalidOperationException("Roles not seeded yet.");
            }

            bool adminExists = await _userRepository.AdminExistsAsync(adminRole.Id);

            if (adminExists)
            {
                throw new InvalidOperationException(
                    "Admin already exists. This endpoint is disabled.");
            }

            var user = new User
            {
                Username = dto.Username,
                Email = dto.Email,
                CreatedAt = DateTime.UtcNow,
                RoleId = adminRole.Id
            };

            user.PasswordHash = _passwordHasher.HashPassword(user, dto.Password);
            await _userRepository.AddAsync(user);
            await _userRepository.SaveChangesAsync();

            _logger.LogInformation("Admin account created: {Email}", user.Email);

            return new UserDTO
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                Role = "Admin"
            };
        }

        public async Task<UserDTO> RegisterAsync(RegisterDTO dto)
        {
            ArgumentNullException.ThrowIfNull(dto);

            bool emailExists = await _userRepository.EmailExistsAsync(dto.Email);
            if (emailExists)
            {
                _logger.LogWarning("Registration attempted with existing email: {Email}", dto.Email);
                throw new InvalidOperationException("Email is already registered.");
            }

            var userRole = await _roleRepository.GetByNameAsync("User");
            if (userRole == null)
            {
                throw new InvalidOperationException("Default User role not found. Contact system administrator.");
            }

            var user = new User
            {
                Username = dto.Username,
                Email = dto.Email,
                CreatedAt = DateTime.UtcNow,
                RoleId = userRole.Id
            };

            user.PasswordHash = _passwordHasher.HashPassword(user, dto.Password);

            await _userRepository.AddAsync(user);
            await _userRepository.SaveChangesAsync();

            _logger.LogInformation("New user registered: {Email}, UserId: {UserId}", user.Email, user.Id);

            return new UserDTO
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                Role = userRole.Name
            };
        }

        public async Task<(string Token, string Role)> LoginAsync(LoginDTO dto)
        {
            ArgumentNullException.ThrowIfNull(dto);

            var user = await _userRepository.GetByEmailAsync(dto.Email);
            if (user == null)
            {
                _logger.LogWarning("Login attempt with unknown email: {Email}", dto.Email);
                throw new UnauthorizedAccessException("Invalid email or password.");
            }

            var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, dto.Password);
            if (result == PasswordVerificationResult.Failed)
            {
                _logger.LogWarning("Failed login attempt for email: {Email}", dto.Email);
                throw new UnauthorizedAccessException("Invalid email or password.");
            }

            _logger.LogInformation("User logged in: {Email}, UserId: {UserId}", user.Email, user.Id);

            var token = _tokenService.GenerateToken(user);
            return (token, user.Role.Name);
        }

      
    }
}
