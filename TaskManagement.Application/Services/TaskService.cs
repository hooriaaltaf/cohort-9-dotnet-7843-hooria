using System;
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
                Priority = (TaskPriority)dto.Priority,
                CategoryId = dto.CategoryId,
                DueDate = dto.DueDate,
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
            return MapToDto(createdTask!);
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

            task.Title = dto.Title;
            task.Description = dto.Description;
            task.Status = (WorkStatus)dto.Status;
            task.Priority = (TaskPriority)dto.Priority;
            task.CategoryId = dto.CategoryId;
            task.DueDate = dto.DueDate;
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
    }
}