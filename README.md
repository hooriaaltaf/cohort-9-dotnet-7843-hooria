# cohort-9-dotnet-7843-hooria : Task Management System

A full-stack task management application built with **ASP.NET Core**, **React.js**, and **SQL Server**, following **Clean Architecture** principles.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | ASP.NET Core Web API (.NET 10) |
| Frontend | React.js (Vite + Tailwind CSS) |
| Database | SQL Server LocalDB |
| ORM | Entity Framework Core |
| Auth | JWT Bearer Tokens |
| Logging | Serilog |
| Testing | xUnit |
| Code Quality | SonarCloud |

## Architecture

Clean Architecture with 4 layers:
- **Domain** — Entities, Enums (no dependencies)
- **Application** — DTOs, Interfaces, Services (depends on Domain)
- **Infrastructure** — EF Core, Repositories, Token Service (depends on Application)
- **API** — Controllers, Middleware (depends on Application + Infrastructure)

## Features

### Authentication & Authorization
- JWT-based authentication
- Role-based authorization (Admin / User)
- First-time setup creates Admin account via `/setup` page

### Task Management
- Create, Read, Update, Delete tasks (soft delete)
- Assign tasks to users (Admin only, at creation time)
- Set priority (Low / Medium / High) and status (Pending / InProgress / Completed)
- Categorize tasks, set due dates

### Dashboard
- User: Pending, InProgress, Completed task counts
- Admin: Pending, InProgress, Completed task, Total users, Total tasks, Deleted tasks count
- Clickable cards navigate to filtered task list

### Task List
- Search by assigned username
- Filter by status
- View, Edit, Delete actions

### User Profile
- View own profile details
- Admin sees all registered users

### Technical Features
- Global exception handling middleware
- Serilog logging (console + rolling file)
- EF Core global query filter for soft delete
- Unit tests for AuthService and TaskService (11 tests)
- SonarCloud code quality analysis

## Setup Instructions

### Prerequisites
- [.NET 10 SDK](https://dotnet.microsoft.com/download)
- [Node.js 18+](https://nodejs.org/)
- SQL Server LocalDB (comes with Visual Studio)

### 1. Clone the repository
```bash
git clone https://github.com/hooriaaltaf/cohort-9-dotnet-7843-hooria.git
cd cohort-9-dotnet-7843-hooria
git checkout develop
```

### 2. Backend setup
```bash
cd TaskManagement.API
dotnet restore
dotnet ef database update --project ../TaskManagement.Infrastructure --startup-project .
dotnet run
```

API will start at `http://localhost:5285`
Swagger UI: `http://localhost:5285/swagger`

### 3. Frontend setup
```bash
cd taskmanagement.client
npm install
npm run dev
```

Frontend will start at `http://localhost:5173`

### 4. First-time Admin setup
On first run, no admin account exists. Navigate to: `http://localhost:5173/setup`
Create your admin account here. This page is **automatically disabled** once an admin exists.

### 5. Run tests
```bash
dotnet test
```

## Project Structure

```text
TaskManagementSystem/
├── TaskManagement.Domain/
│   ├── Entities/              # User, Role, TaskItem, TaskCategory
│   └── Enums/                 # WorkStatus, TaskPriority
│
├── TaskManagement.Application/
│   ├── DTOs/                  # Request/Response DTOs
│   ├── Interfaces/            # Repository & Service contracts
│   └── Services/              # AuthService, TaskService, UserService
│
├── TaskManagement.Infrastructure/
│   ├── Data/                  # AppDbContext, DBSeeder, Migrations
│   ├── Repositories/          # EF Core implementations
│   └── Services/              # TokenService
│
├── TaskManagement.API/
│   ├── Controllers/           # AuthController, TasksController, UsersController
│   └── Middleware/            # ExceptionHandlingMiddleware
│
├── TaskManagement.Application.Tests/
│   └── Tests/                 # AuthServiceTests, TaskServiceTests
│
└── taskmanagement.client/
    └── src/
        ├── pages/              # Login, Signup, Dashboard, TaskList, etc.
        ├── components/         # Navbar, ProtectedRoute
        ├── context/            # AuthContext
        └── services/           # api.js, taskApi.js, userApi.js

## API Endpoints

### Auth
| Method | Endpoint | Access | Description |
|--------|----------|--------|-------------|
| POST | /api/Auth/register | Public | Register new user |
| POST | /api/Auth/login | Public | Login, returns JWT |
| POST | /api/Auth/setup-admin | Public (once) | Create first admin |

### Tasks
| Method | Endpoint | Access | Description |
|--------|----------|--------|-------------|
| GET | /api/Tasks | Authenticated | Get tasks (filtered by role) |
| POST | /api/Tasks | Authenticated | Create task |
| GET | /api/Tasks/{id} | Authenticated | Get task detail |
| PUT | /api/Tasks/{id} | Authenticated | Update task |
| DELETE | /api/Tasks/{id} | Authenticated | Soft delete task |
| GET | /api/Tasks/dashboard | Authenticated | Get dashboard counts |
| GET | /api/Tasks/categories | Authenticated | Get all categories |

### Users
| Method | Endpoint | Access | Description |
|--------|----------|--------|-------------|
| GET | /api/Users | Admin only | Get all users |
| GET | /api/Users/me | Authenticated | Get current user profile |

## Permission Rules

| Action | Regular User | Admin |
|--------|-------------|-------|
| Create task | Yes (self-assigned) | Yes (can assign to anyone) |
| View tasks | Own tasks only | All tasks |
| Edit task | Own tasks only | Any task |
| Delete task | Self-created only | Any task |
| Assign task | No | Yes (at creation only) |
| View all users | No | Yes |

## Code Quality

SonarCloud analysis: [View Dashboard](https://sonarcloud.io/project/overview?id=hooriaaltaf_cohort-9-dotnet-7843-hooria)

## Git Workflow

Branches:
- `main` — stable
- `develop` — integration branch
- `feature/auth-login-signup` — authentication feature
- `feature/task-management-crud` — task CRUD backend
- `feature/dashboard-profile` — dashboard & profile backend
- `feature/task-management-frontend` — React frontend
