using System;
using System.Collections.Generic;
using System.Text;

namespace TaskManagement.Application.DTOs
{
    public class DashboardDTO
    {
        public int PendingCount { get; set; }
        public int InProgressCount { get; set; }
        public int CompletedCount { get; set; }

        // Admin-only fields — null for regular users
        public int? TotalUsers { get; set; }
        public int? TotalTasks { get; set; }
        public int? DeletedTasksCount { get; set; }
    }
}