using System;
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
