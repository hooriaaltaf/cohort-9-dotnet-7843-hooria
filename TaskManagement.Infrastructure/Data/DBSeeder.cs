using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Infrastructure.Data
{
    public static class DBSeeder
    {
        public static async Task SeedAsync(AppDbContext context, IConfiguration configuration)
        {
            if (context == null)
            {
                throw new ArgumentNullException(nameof(context));
            }

            if (configuration == null)
            {
                throw new ArgumentNullException(nameof(configuration));
            }

            // Seed Roles first — Tasks/Users depend on Roles existing
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

            // Seed default Admin user, only if no admin exists yet
            var adminRole = await context.Roles.FirstOrDefaultAsync(r => r.Name == "Admin");
            if (adminRole != null && !await context.Users.AnyAsync(u => u.RoleId == adminRole.Id))
            {
                var adminPassword = configuration["AdminSeed:Password"];
                var adminEmail = configuration["AdminSeed:Email"];

                if (string.IsNullOrWhiteSpace(adminPassword))
                {
                    throw new InvalidOperationException(
                        "AdminSeed:Password is not configured. Set it in appsettings.json or environment variables before starting the application.");
                }

                if (string.IsNullOrWhiteSpace(adminEmail))
                {
                    throw new InvalidOperationException(
                        "AdminSeed:Email is not configured. Set it in appsettings.json or environment variables before starting the application.");
                }

                var passwordHasher = new Microsoft.AspNetCore.Identity.PasswordHasher<User>();

                var adminUser = new User
                {
                    Username = "admin",
                    Email = adminEmail,
                    CreatedAt = DateTime.UtcNow,
                    RoleId = adminRole.Id
                };
                adminUser.PasswordHash = passwordHasher.HashPassword(adminUser, adminPassword);

                context.Users.Add(adminUser);
                await context.SaveChangesAsync();
            }
        }
    }
}