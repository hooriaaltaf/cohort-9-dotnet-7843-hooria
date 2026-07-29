using System;
using System.Collections.Generic;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class UserDTO
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;

    }
}
//Why no PasswordHash in UserDto?
//This is the DTO returned to the frontend after login/register
//Never expose the password hash, ever, even hashed.
