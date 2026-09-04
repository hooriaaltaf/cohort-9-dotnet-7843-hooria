using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using TaskManagement.Application.Interfaces;
using TaskManagement.Domain.Entities;
using TaskManagement.Infrastructure.Data;

namespace TaskManagement.Infrastructure.Repositories
{
    public class TaskRepository : ITaskRepository
    {
        private readonly AppDbContext _context;

        public TaskRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<TaskItem?> GetByIdAsync(int id)
        {
            return await _context.Tasks
                .Include(t => t.Category)
                .Include(t => t.AssignedToUser)
                .Include(t => t.CreatedByUser)
                .FirstOrDefaultAsync(t => t.Id == id);
        }

        public async Task<List<TaskItem>> GetAllForUserAsync(int userId, bool isAdmin)
        {
            var query = _context.Tasks
                .Include(t => t.Category)
                .Include(t => t.AssignedToUser)
                .Include(t => t.CreatedByUser)
                .AsQueryable();

            if (!isAdmin)
            {
                query = query.Where(t => t.CreatedByUserId == userId || t.AssignedToUserId == userId);
            }

            return await query.OrderByDescending(t => t.CreatedAt).ToListAsync();
        }

        public async Task<List<TaskCategory>> GetAllCategoriesAsync()
        {
            return await _context.TaskCategories.ToListAsync();
        }

        public async Task AddAsync(TaskItem task)
        {
            await _context.Tasks.AddAsync(task);
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }

        public async Task<int> GetDeletedTasksCountAsync()
        {
            return await _context.Tasks.IgnoreQueryFilters().CountAsync(t => t.IsDeleted);
        }

        public async Task<int> GetTotalTasksCountAsync()
        {
            return await _context.Tasks.CountAsync(); // global filter already excludes deleted
        }
    }
}
