using System;
using System.Collections.Generic;
using System.Text;
using Moq;
using Xunit;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Exceptions;
using TaskManagement.Application.Interfaces;
using TaskManagement.Application.Services;
using TaskManagement.Domain.Entities;
using TaskManagement.Domain.Enums;
using Microsoft.Extensions.Logging;

namespace TaskManagement.Application.Tests
{
    public class TaskServiceTests
    {
        private readonly Mock<ITaskRepository> _taskRepoMock;
        private readonly Mock<IUserRepository> _userRepoMock;
        private readonly Mock<ILogger<TaskService>> _loggerMock;
        private readonly TaskService _taskService;

        public TaskServiceTests()
        {
            _taskRepoMock = new Mock<ITaskRepository>();
            _userRepoMock = new Mock<IUserRepository>();
            _loggerMock = new Mock<ILogger<TaskService>>();

            _taskService = new TaskService(
                _taskRepoMock.Object,
                _userRepoMock.Object,
                _loggerMock.Object);
        }

        private static TaskItem BuildTask(int id, int createdBy, int assignedTo)
        {
            return new TaskItem
            {
                Id = id,
                Title = "Sample Task",
                Description = "Sample",
                Status = WorkStatus.Pending,
                Priority = TaskPriority.Medium,
                CategoryId = 1,
                Category = new TaskCategory { Id = 1, Name = "Work" },
                DueDate = DateTime.UtcNow.AddDays(1),
                CreatedByUserId = createdBy,
                CreatedByUser = new User { Id = createdBy, Username = "creator" },
                AssignedToUserId = assignedTo,
                AssignedToUser = new User { Id = assignedTo, Username = "assignee" },
                IsDeleted = false,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };
        }

        [Fact]
        public async Task DeleteTaskAsync_ShouldSucceed_WhenUserDeletesOwnSelfCreatedTask()
        {
            // Arrange: task created by user 1, assigned to user 1 (self-created)
            var task = BuildTask(id: 1, createdBy: 1, assignedTo: 1);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act
            await _taskService.DeleteTaskAsync(taskId: 1, currentUserId: 1, currentUserRole: "User");

            // Assert
            Assert.True(task.IsDeleted);
            _taskRepoMock.Verify(r => r.SaveChangesAsync(), Times.Once);
        }

        [Fact]
        public async Task DeleteTaskAsync_ShouldThrow_WhenUserTriesToDeleteAdminAssignedTask()
        {
            // Arrange: task created by admin (user 2), assigned to user 1 — not self-created
            var task = BuildTask(id: 1, createdBy: 2, assignedTo: 1);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act + Assert
            await Assert.ThrowsAsync<ForbiddenAccessException>(
                () => _taskService.DeleteTaskAsync(taskId: 1, currentUserId: 1, currentUserRole: "User"));
        }

        [Fact]
        public async Task DeleteTaskAsync_ShouldSucceed_WhenAdminDeletesAnyTask()
        {
            // Arrange: task created and assigned to a regular user, admin deletes it
            var task = BuildTask(id: 1, createdBy: 1, assignedTo: 1);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act
            await _taskService.DeleteTaskAsync(taskId: 1, currentUserId: 99, currentUserRole: "Admin");

            // Assert
            Assert.True(task.IsDeleted);
        }

        [Fact]
        public async Task CreateTaskAsync_ShouldForceSelfAssignment_WhenRegularUserProvidesDifferentAssignee()
        {
            // Arrange: regular user tries to assign task to someone else via the DTO
            var dto = new CreateTaskDTO
            {
                Title = "New Task",
                Description = "Test",
                Priority = 1,
                CategoryId = 1,
                DueDate = DateTime.UtcNow.AddDays(1),
                AssignedToUserId = 999 // attempting to assign to someone else
            };

            TaskItem? capturedTask = null;
            _taskRepoMock.Setup(r => r.AddAsync(It.IsAny<TaskItem>()))
                          .Callback<TaskItem>(t => capturedTask = t)
                          .Returns(Task.CompletedTask);
            _taskRepoMock.Setup(r => r.GetByIdAsync(It.IsAny<int>()))
                          .ReturnsAsync(() => capturedTask);

            // Act
            await _taskService.CreateTaskAsync(dto, currentUserId: 5, currentUserRole: "User");

            // Assert — regardless of dto.AssignedToUserId, task must be assigned to the current user
            Assert.NotNull(capturedTask);
            Assert.Equal(5, capturedTask!.AssignedToUserId);
            Assert.Equal(5, capturedTask.CreatedByUserId);
        }

        [Fact]
        public async Task CreateTaskAsync_ShouldAllowAdminToAssignToAnotherUser()
        {
            // Arrange
            var dto = new CreateTaskDTO
            {
                Title = "Admin Assigned Task",
                Description = "Test",
                Priority = 2,
                CategoryId = 1,
                DueDate = DateTime.UtcNow.AddDays(1),
                AssignedToUserId = 42
            };

            _userRepoMock.Setup(r => r.GetByIdAsync(42))
                          .ReturnsAsync(new User { Id = 42, Username = "assignee" });

            TaskItem? capturedTask = null;
            _taskRepoMock.Setup(r => r.AddAsync(It.IsAny<TaskItem>()))
                          .Callback<TaskItem>(t => capturedTask = t)
                          .Returns(Task.CompletedTask);
            _taskRepoMock.Setup(r => r.GetByIdAsync(It.IsAny<int>()))
                          .ReturnsAsync(() => capturedTask);

            // Act
            await _taskService.CreateTaskAsync(dto, currentUserId: 1, currentUserRole: "Admin");

            // Assert
            Assert.NotNull(capturedTask);
            Assert.Equal(42, capturedTask!.AssignedToUserId);
            Assert.Equal(1, capturedTask.CreatedByUserId);
        }

        [Fact]
        public async Task GetTaskByIdAsync_ShouldThrow_WhenUserHasNoRelationToTask()
        {
            // Arrange: task belongs to user 1 and 2, current user is 3 (unrelated)
            var task = BuildTask(id: 1, createdBy: 1, assignedTo: 2);
            _taskRepoMock.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(task);

            // Act + Assert
            await Assert.ThrowsAsync<ForbiddenAccessException>(
                () => _taskService.GetTaskByIdAsync(taskId: 1, currentUserId: 3, currentUserRole: "User"));
        }
    }
}
