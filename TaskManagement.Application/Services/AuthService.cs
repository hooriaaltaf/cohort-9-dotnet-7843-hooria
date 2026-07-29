using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.AspNetCore.Identity;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Interfaces;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Application.Services
{
    public class AuthService
    {
        private readonly IUserRepository _userRepository;
        private readonly PasswordHasher<User> _passwordHasher;
        private readonly ITokenService _tokenService;

        public AuthService(IUserRepository userRepository, ITokenService tokenService)
        {
            _userRepository = userRepository;
            _passwordHasher = new PasswordHasher<User>();
            _tokenService = tokenService;
        }

        public async Task<UserDTO> RegisterAsync(RegisterDTO dto)
        {
            bool emailExists = await _userRepository.EmailExistsAsync(dto.Email);
            if (emailExists)
            {
                throw new InvalidOperationException("Email is already registered.");
            }

            var user = new User
            {
                Username = dto.Username,
                Email = dto.Email,
                CreatedAt = DateTime.UtcNow,
                RoleId = 2 // Default role = "User". We'll replace this hardcoded value soon.
            };

            user.PasswordHash = _passwordHasher.HashPassword(user, dto.Password);

            await _userRepository.AddAsync(user);
            await _userRepository.SaveChangesAsync();

            return new UserDTO
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                Role = "User"
            };
        }

        public async Task<string> LoginAsync(LoginDTO dto)
        {
            var user = await _userRepository.GetByEmailAsync(dto.Email);
            if (user == null)
            {
                throw new UnauthorizedAccessException("Invalid email or password.");
            }

            var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, dto.Password);
            if (result == PasswordVerificationResult.Failed)
            {
                throw new UnauthorizedAccessException("Invalid email or password.");
            }

            return _tokenService.GenerateToken(user);
        }


    }
}
