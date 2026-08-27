using System;
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
