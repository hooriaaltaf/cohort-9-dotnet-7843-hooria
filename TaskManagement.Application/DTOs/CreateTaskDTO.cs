using System;
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

        [Required]
        public int Priority { get; set; }

        [Required]
        public int CategoryId { get; set; }

        [Required]
        public DateTime DueDate { get; set; }

        // Only meaningful when the creator is Admin.
        // Regular users' input here is ignored server-side — they're always self-assigned.
        public int? AssignedToUserId { get; set; }
    }
}
