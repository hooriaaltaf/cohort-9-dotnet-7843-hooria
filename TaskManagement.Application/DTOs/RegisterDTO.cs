using System;
using System.Collections.Generic;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class RegisterDTO
    {
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
}
