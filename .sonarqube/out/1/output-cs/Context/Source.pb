À
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\CreateTaskDTO.csŒusing System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class CreateTaskDTO
    {
        [Required]
        [StringLength(200, MinimumLength = 3)]
        public string Title { get; set; } = string.Empty;


        [StringLength(2000)]
        public string Description { get; set; } = string.Empty;


        [Required(ErrorMessage = "Priority is required.")]
        public int? Priority { get; set; }


        [Required(ErrorMessage = "CategoryId is required.")]
        public int? CategoryId { get; set; }


        [Required(ErrorMessage = "DueDate is required.")]
        public DateTime? DueDate { get; set; }

        // Only meaningful when the creator is Admin.
        // Regular users' input here is ignored server-side ‚Äî they're always self-assigned.
        public int? AssignedToUserId { get; set; }
    }
}
ParseOptions.0.json˛
bD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\DashboardDTO.csÇusing System;
using System.Collections.Generic;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class DashboardDTO
    {
        public int PendingCount { get; set; }
        public int InProgressCount { get; set; }
        public int CompletedCount { get; set; }

        // Admin-only fields ‚Äî null for regular users
        public int? TotalUsers { get; set; }
        public int? TotalTasks { get; set; }
        public int? DeletedTasksCount { get; set; }
    }
}ParseOptions.0.jsonÌ
^D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\LoginDTO.csıusing System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class LoginDTO
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
}
ParseOptions.0.jsonÜ
aD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\RegisterDTO.csãusing System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class RegisterDTO
    {
        [Required]
        [StringLength(50, MinimumLength = 3)]
        public string Username { get; set; } = string.Empty;

        [Required]
        [EmailAddress(ErrorMessage = "Invalid email format.")]
        public string Email { get; set; } = string.Empty;

        [Required]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters.")]
        public string Password { get; set; } = string.Empty;
    }
}
ParseOptions.0.jsoná
eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\TaskCategoryDTO.csàusing System;
using System.Collections.Generic;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class TaskCategoryDTO
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }
}
ParseOptions.0.jsonó
]D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\TaskDTO.cs†using System;
using System.Collections.Generic;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class TaskDTO
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string Priority { get; set; } = string.Empty;
        public string CategoryName { get; set; } = string.Empty;
        public DateTime DueDate { get; set; }
        public string AssignedToUsername { get; set; } = string.Empty;
        public string CreatedByUsername { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

    }
}
ParseOptions.0.jsonÁ
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\UpdateTaskDTO.csÍusing System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class UpdateTaskDTO
    {
        [Required]
        [StringLength(200, MinimumLength = 3)]
        public string Title { get; set; } = string.Empty;


        [StringLength(2000)]
        public string Description { get; set; } = string.Empty;


        [Required(ErrorMessage = "Status is required.")]
        public int? Status { get; set; }


        [Required(ErrorMessage = "Priority is required.")]
        public int? Priority { get; set; }


        [Required(ErrorMessage = "CategoryId is required.")]
        public int? CategoryId { get; set; }


        [Required(ErrorMessage = "DueDate is required.")]
        public DateTime? DueDate { get; set; }
    }
}
ParseOptions.0.jsonå
]D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\UserDTO.csïusing System;
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
ParseOptions.0.jsonƒ
tD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Exceptions\ForbiddenAccessException.cs∂namespace TaskManagement.Application.Exceptions;


public class ForbiddenAccessException : Exception
{
    public ForbiddenAccessException(string message) : base(message) { }
}ParseOptions.0.jsonì
kD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\IRoleRepository.cséusing System;
using System.Collections.Generic;
using System.Text;
using TaskManagement.Domain.Entities;


namespace TaskManagement.Application.Interfaces
{
    public interface IRoleRepository
    {
        Task<Role?> GetByNameAsync(string name);
    }
}
ParseOptions.0.jsonú
kD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\ITaskRepository.csóusing System;
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
        Task<int> GetDeletedTasksCountAsync();
        Task<int> GetTotalTasksCountAsync();
        Task SaveChangesAsync();
    }
}


//GetAllForUserAsync:
//Admin can see all tasks of all users
//user can see only his tasksParseOptions.0.jsonÖ
iD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\ITokenService.csÇusing System;
using System.Collections.Generic;
using System.Text;
using TaskManagement.Domain.Entities;

namespace TaskManagement.Application.Interfaces
{
    public interface ITokenService
    {
        string GenerateToken(User user);
    }
}
ParseOptions.0.jsonÂ
kD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\IUserRepository.cs‡using System;
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
        Task<List<User>> GetAllAsync();


        Task AddAsync(User user);
        Task SaveChangesAsync();

    }
}
ParseOptions.0.jsonù
eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Services\AuthService.csûusing Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;
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
ParseOptions.0.json‚F
eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Services\TaskService.cs„Eusing System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Extensions.Logging;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Interfaces;
using TaskManagement.Domain.Entities;
using TaskManagement.Domain.Enums;
using TaskManagement.Application.Exceptions;



namespace TaskManagement.Application.Services
{
    public class TaskService
    {
        private readonly ITaskRepository _taskRepository;
        private readonly IUserRepository _userRepository;
        private readonly ILogger<TaskService> _logger;

        public TaskService(
            ITaskRepository taskRepository,
            IUserRepository userRepository,
            ILogger<TaskService> logger)
        {
            _taskRepository = taskRepository;
            _userRepository = userRepository;
            _logger = logger;
        }

        public async Task<List<TaskDTO>> GetTasksForUserAsync(int currentUserId, string currentUserRole)
        {
            bool isAdmin = currentUserRole == "Admin";
            var tasks = await _taskRepository.GetAllForUserAsync(currentUserId, isAdmin);
            return tasks.Select(MapToDto).ToList();
        }


        public async Task<TaskDTO> GetTaskByIdAsync(int taskId, int currentUserId, string currentUserRole)
        {
            var task = await _taskRepository.GetByIdAsync(taskId);
            if (task == null)
            {
                throw new KeyNotFoundException("Task not found.");
            }

            bool isAdmin = currentUserRole == "Admin";
            bool isOwnerOrAssignee = task.CreatedByUserId == currentUserId || task.AssignedToUserId == currentUserId;

            if (!isAdmin && !isOwnerOrAssignee)
            {
                throw new ForbiddenAccessException("You do not have permission to view this task.");
            }

            return MapToDto(task);
        }


        public async Task<TaskDTO> CreateTaskAsync(CreateTaskDTO dto, int currentUserId, string currentUserRole)
        {
            if (!Enum.IsDefined(typeof(TaskPriority), dto.Priority!.Value))
            {
                throw new InvalidOperationException("Invalid priority value.");
            }

            bool isAdmin = currentUserRole == "Admin";

            int assignedToUserId;
            if (isAdmin && dto.AssignedToUserId.HasValue)
            {
                var assignee = await _userRepository.GetByIdAsync(dto.AssignedToUserId.Value);
                if (assignee == null)
                {
                    throw new InvalidOperationException("The user you are trying to assign this task to does not exist.");
                }
                assignedToUserId = dto.AssignedToUserId.Value;
            }
            else
            {
                // Regular users can only create tasks for themselves.
                // Even if a non-admin sends AssignedToUserId in the request, we ignore it here.
                assignedToUserId = currentUserId;
            }

            var task = new TaskItem
            {
                Title = dto.Title,
                Description = dto.Description,
                Status = WorkStatus.Pending,
                Priority = (TaskPriority)dto.Priority.Value,
                CategoryId = dto.CategoryId!.Value,
                DueDate = dto.DueDate!.Value,
                AssignedToUserId = assignedToUserId,
                CreatedByUserId = currentUserId,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                IsDeleted = false
            };

            await _taskRepository.AddAsync(task);
            await _taskRepository.SaveChangesAsync();

            _logger.LogInformation("Task created: {TaskId} by UserId: {UserId}", task.Id, currentUserId);

           var createdTask = await _taskRepository.GetByIdAsync(task.Id);
            if (createdTask is null)
            {
                throw new InvalidOperationException("Created task could not be loaded.");
            }
            
            return MapToDto(createdTask);
        }


        public async Task<TaskDTO> UpdateTaskAsync(int taskId, UpdateTaskDTO dto, int currentUserId, string currentUserRole)
        {
            var task = await _taskRepository.GetByIdAsync(taskId);
            if (task == null)
            {
                throw new KeyNotFoundException("Task not found.");
            }

            bool isAdmin = currentUserRole == "Admin";
            bool isOwner = task.CreatedByUserId == currentUserId;

            if (!isAdmin && !isOwner)
            {
                throw new ForbiddenAccessException("You do not have permission to edit this task.");
            }

            if (!Enum.IsDefined(typeof(WorkStatus), dto.Status!.Value))
            {
                throw new InvalidOperationException("Invalid status value.");
            }

            if (!Enum.IsDefined(typeof(TaskPriority), dto.Priority!.Value))
            {
                throw new InvalidOperationException("Invalid priority value.");
            }

            task.Title = dto.Title;
            task.Description = dto.Description;
            task.Status = (WorkStatus)dto.Status.Value;
            task.Priority = (TaskPriority)dto.Priority.Value;
            task.CategoryId = dto.CategoryId!.Value;
            task.DueDate = dto.DueDate!.Value;
            task.UpdatedAt = DateTime.UtcNow;

            await _taskRepository.SaveChangesAsync();

            _logger.LogInformation("Task updated: {TaskId} by UserId: {UserId}", task.Id, currentUserId);

            return MapToDto(task);
        }



        public async Task DeleteTaskAsync(int taskId, int currentUserId, string currentUserRole)
        {
            var task = await _taskRepository.GetByIdAsync(taskId);
            if (task == null)
            {
                throw new KeyNotFoundException("Task not found.");
            }

            bool isAdmin = currentUserRole == "Admin";
            bool isSelfCreatedTask = task.CreatedByUserId == task.AssignedToUserId;  // self-created tasks can be deleted by their owner.
            bool isOwnerOfSelfCreatedTask = isSelfCreatedTask && task.CreatedByUserId == currentUserId;// Admin-assigned tasks can only be deleted by Admin.


            if (!isAdmin && !isOwnerOfSelfCreatedTask)
            {
                throw new ForbiddenAccessException("You do not have permission to delete this task.");
            }

            task.IsDeleted = true;
            task.DeletedAt = DateTime.UtcNow;
            await _taskRepository.SaveChangesAsync();

            _logger.LogInformation("Task soft-deleted: {TaskId} by UserId: {UserId}", task.Id, currentUserId);
        }


        private static TaskDTO MapToDto(TaskItem task)
        {
            return new TaskDTO
            {
                Id = task.Id,
                Title = task.Title,
                Description = task.Description,
                Status = task.Status.ToString(),
                Priority = task.Priority.ToString(),
                CategoryName = task.Category?.Name ?? string.Empty,
                DueDate = task.DueDate,
                AssignedToUsername = task.AssignedToUser?.Username ?? string.Empty,
                CreatedByUsername = task.CreatedByUser?.Username ?? string.Empty,
                CreatedAt = task.CreatedAt,
                UpdatedAt = task.UpdatedAt
            };
        }


        public async Task<List<TaskCategoryDTO>> GetCategoriesAsync()
        {
            var categories = await _taskRepository.GetAllCategoriesAsync();
            return categories.Select(c => new TaskCategoryDTO { Id = c.Id, Name = c.Name }).ToList();
        }

        public async Task<DashboardDTO> GetDashboardAsync(int currentUserId, string currentUserRole)
        {
            bool isAdmin = currentUserRole == "Admin";
            var tasks = await _taskRepository.GetAllForUserAsync(currentUserId, isAdmin);

            var dashboard = new DashboardDTO
            {
                PendingCount = tasks.Count(t => t.Status == WorkStatus.Pending),
                InProgressCount = tasks.Count(t => t.Status == WorkStatus.InProgress),
                CompletedCount = tasks.Count(t => t.Status == WorkStatus.Completed)
            };

            if (isAdmin)
            {
                var allUsers = await _userRepository.GetAllAsync();
                dashboard.TotalUsers = allUsers.Count;
                dashboard.TotalTasks = await _taskRepository.GetTotalTasksCountAsync();
                dashboard.DeletedTasksCount = await _taskRepository.GetDeletedTasksCountAsync();
            }

            return dashboard;
        }
    }
}ParseOptions.0.json·

eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Services\UserService.cs‚	using TaskManagement.Application.DTOs;
using TaskManagement.Application.Interfaces;

namespace TaskManagement.Application.Services
{
    public class UserService
    {
        private readonly IUserRepository _userRepository;

        public UserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<List<UserDTO>> GetAllUsersAsync()
        {
            var users = await _userRepository.GetAllAsync();
            return users.Select(u => new UserDTO
            {
                Id = u.Id,
                Username = u.Username,
                Email = u.Email,
                Role = u.Role.Name
            }).ToList();
        }

        public async Task<UserDTO> GetUserByIdAsync(int userId)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
            {
                throw new KeyNotFoundException("User not found.");
            }

            return new UserDTO
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                Role = user.Role.Name
            };
        }
    }
}ParseOptions.0.jsonñ
åD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\obj\Debug\net10.0\TaskManagement.Application.GlobalUsings.g.csÔ// <auto-generated/>
global using System;
global using System.Collections.Generic;
global using System.IO;
global using System.Linq;
global using System.Net.Http;
global using System.Threading;
global using System.Threading.Tasks;
ParseOptions.0.jsonÚ
èD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\obj\Debug\net10.0\.NETCoreApp,Version=v10.0.AssemblyAttributes.cs»// <autogenerated />
using System;
using System.Reflection;
[assembly: global::System.Runtime.Versioning.TargetFrameworkAttribute(".NETCoreApp,Version=v10.0", FrameworkDisplayName = ".NET 10.0")]
ParseOptions.0.json¡	
äD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\obj\Debug\net10.0\TaskManagement.Application.AssemblyInfo.csú//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Reflection;

[assembly: System.Reflection.AssemblyCompanyAttribute("TaskManagement.Application")]
[assembly: System.Reflection.AssemblyConfigurationAttribute("Debug")]
[assembly: System.Reflection.AssemblyFileVersionAttribute("1.0.0.0")]
[assembly: System.Reflection.AssemblyInformationalVersionAttribute("1.0.0+1fe372dbe293cb307e8228638d7dd6674e2101d8")]
[assembly: System.Reflection.AssemblyProductAttribute("TaskManagement.Application")]
[assembly: System.Reflection.AssemblyTitleAttribute("TaskManagement.Application")]
[assembly: System.Reflection.AssemblyVersionAttribute("1.0.0.0")]

// Generated by the MSBuild WriteCodeFragment class.

ParseOptions.0.json