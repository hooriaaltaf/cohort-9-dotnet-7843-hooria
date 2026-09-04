using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Infrastructure.Data
{
    public static class DBSeeder
    {
        public static async Task SeedAsync(AppDbContext context, IConfiguration configuration)
        {
            if (context == null) throw new ArgumentNullException(nameof(context));
            if (configuration == null) throw new ArgumentNullException(nameof(configuration));

            // Seed Roles
            if (!await context.Roles.AnyAsync())
            {
                context.Roles.AddRange(
                    new Role { Name = "Admin" },
                    new Role { Name = "User" }
                );
                await context.SaveChangesAsync();
            }

            // Seed default Task Categories
            if (!await context.TaskCategories.AnyAsync())
            {
                context.TaskCategories.AddRange(
                    new TaskCategory { Name = "Work" },
                    new TaskCategory { Name = "Personal" },
                    new TaskCategory { Name = "Urgent" },
                    new TaskCategory { Name = "General" }
                );
                await context.SaveChangesAsync();
            }
        }
    }
}