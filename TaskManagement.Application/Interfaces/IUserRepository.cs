using System;
using System.Collections.Generic;
using System.Text;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Application.Interfaces
{
    public interface IUserRepository
    {
        Task<User?> GetByEmailAsync(string email);
        Task<User?>GetByIdAsync(int id);
        Task<bool> EmailExistsAsync(string email);

        Task AddAsync(User user);
        Task SaveChangesAsync();

    }
}
