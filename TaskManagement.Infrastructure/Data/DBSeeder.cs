using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Infrastructure.Data
{
    public static class DBSeeder
    {
            public static async Task SeedAsync(AppDbContext context, IConfiguration configuration)
            {
                // Seed Roles first — Tasks/Users depend on Roles existing
                if (!await context.Roles.AnyAsync())
                {
                    context.Roles.AddRange(
                        new Role { Name = "Admin" },
                        new Role { Name = "User" }
                    );
                    await context.SaveChangesAsync();
                }

                // Seed default Admin user, only if no admin exists yet
                var adminRole = await context.Roles.FirstOrDefaultAsync(r => r.Name == "Admin");
                if (adminRole != null && !await context.Users.AnyAsync(u => u.RoleId == adminRole.Id))
                {
                    var passwordHasher = new Microsoft.AspNetCore.Identity.PasswordHasher<User>();

                    var adminUser = new User
                    {
                        Username = "admin",
                        Email = configuration["AdminSeed:Email"] ?? "admin@taskmanagement.com",
                        CreatedAt = DateTime.UtcNow,
                        RoleId = adminRole.Id
                    };
                    adminUser.PasswordHash = passwordHasher.HashPassword(
                        adminUser, configuration["AdminSeed:Password"] ?? "Admin@123");

                    context.Users.Add(adminUser);
                    await context.SaveChangesAsync();
                }
            }
 
}

}
