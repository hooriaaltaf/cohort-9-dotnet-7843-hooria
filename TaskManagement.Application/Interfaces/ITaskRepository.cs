using System;
using System.Collections.Generic;
using System.Text;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Application.Interfaces
{
    public interface ITaskRepository
    {
        Task<TaskItem?> GetByIdAsync(int id);
        Task<List<TaskItem>> GetAllForUserAsync(int userId, bool isAdmin);
        Task<List<TaskCategory>> GetAllCategoriesAsync();
        Task AddAsync(TaskItem task);
        Task SaveChangesAsync();
    }
}


//GetAllForUserAsync:
//Admin can see all tasks of all users
//user can see only his tasks