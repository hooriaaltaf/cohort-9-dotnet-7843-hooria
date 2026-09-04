÷

cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Controllers\AuthController.csŸ	using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Services;

namespace TaskManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AuthService _authService;
        
        public AuthController(AuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDTO dto)
        {
                var result = await _authService.RegisterAsync(dto);
                return Ok(result);
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDTO dto)
        {
                var (token, role) = await _authService.LoginAsync(dto);
                return Ok(new { token, role });
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("admin-only")]
        public IActionResult AdminOnly()
        {
            return Ok(new { message = "You are an Admin." });
        }

       

    }
}
ParseOptions.0.json¨
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Controllers\TaskController.csØusing System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TaskManagement.Application.DTOs;
using TaskManagement.Application.Services;

namespace TaskManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class TasksController : ControllerBase
    {
        private readonly TaskService _taskService;

        public TasksController(TaskService taskService)
        {
            _taskService = taskService;
        }

        private int GetCurrentUserId()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (!int.TryParse(idClaim, out var userId) || userId <= 0)
            {
                throw new UnauthorizedAccessException("The access token has an invalid user identifier.");
            }
            return userId;
        }


        private string GetCurrentUserRole()
        {
            return User.FindFirst(ClaimTypes.Role)?.Value ?? string.Empty;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var tasks = await _taskService.GetTasksForUserAsync(GetCurrentUserId(), GetCurrentUserRole());
            return Ok(tasks);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var task = await _taskService.GetTaskByIdAsync(id, GetCurrentUserId(), GetCurrentUserRole());
            return Ok(task);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateTaskDTO dto)
        {
            var task = await _taskService.CreateTaskAsync(dto, GetCurrentUserId(), GetCurrentUserRole());
            return CreatedAtAction(nameof(GetById), new { id = task.Id }, task);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateTaskDTO dto)
        {
            var task = await _taskService.UpdateTaskAsync(id, dto, GetCurrentUserId(), GetCurrentUserRole());
            return Ok(task);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _taskService.DeleteTaskAsync(id, GetCurrentUserId(), GetCurrentUserRole());
            return NoContent();
        }

        [HttpGet("categories")]
        public async Task<IActionResult> GetCategories()
        {
            var categories = await _taskService.GetCategoriesAsync();
            return Ok(categories);
        }

        [HttpGet("dashboard")]
        public async Task<IActionResult> GetDashboard()
        {
            var dashboard = await _taskService.GetDashboardAsync(GetCurrentUserId(), GetCurrentUserRole());
            return Ok(dashboard);
        }
    }
}ParseOptions.0.jsonÉ	
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Controllers\UserController.csÜusing System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TaskManagement.Application.Services;

namespace TaskManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class UsersController : ControllerBase
    {
        private readonly UserService _userService;

        public UsersController(UserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> GetAll()
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(users);
        }

        [HttpGet("me")]
        public async Task<IActionResult> GetCurrentUser()
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var user = await _userService.GetUserByIdAsync(userId);
            return Ok(user);
        }
    }
}ParseOptions.0.json“
oD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Middleware\ExceptionHandlingMiddleware.cs…using System.Net;
using System.Text.Json;
using TaskManagement.Application.Exceptions;


namespace TaskManagement.API.Middleware
{
    public class ExceptionHandlingMiddleware
    {
            private readonly RequestDelegate _next;
            private readonly ILogger<ExceptionHandlingMiddleware> _logger;

            public ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger)
            {
                _next = next;
                _logger = logger;
            }

            public async Task InvokeAsync(HttpContext context)
            {
                try
                {
                    await _next(context);
                }
                catch (Exception ex)
                {
                    await HandleExceptionAsync(context, ex);
                }
            }

        private Task HandleExceptionAsync(HttpContext context, Exception ex)
        {
            context.Response.ContentType = "application/json";


            var (statusCode, message, logAsWarning) = ex switch
            {
                InvalidOperationException => (HttpStatusCode.BadRequest, ex.Message, true),
                KeyNotFoundException => (HttpStatusCode.NotFound, ex.Message, true),
                UnauthorizedAccessException => (HttpStatusCode.Unauthorized, ex.Message, true),
                ForbiddenAccessException => (HttpStatusCode.Forbidden, ex.Message, true),
                _ => (HttpStatusCode.InternalServerError, "An unexpected error occurred. Please try again later.", false)
            };

            if (logAsWarning)
            {
                _logger.LogWarning("Handled exception: {Message}", ex.Message);
            }
            else
            {
                _logger.LogError(ex, "Unhandled exception occurred: {Message}", ex.Message);
            }

            context.Response.StatusCode = (int)statusCode;
            var response = JsonSerializer.Serialize(new { message });
            return context.Response.WriteAsync(response);
        }


    }
    }
ParseOptions.0.json®"
PD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Program.csæ!using Microsoft.EntityFrameworkCore;
using TaskManagement.Application.Interfaces;
using TaskManagement.Application.Services;
using TaskManagement.Infrastructure.Data;
using TaskManagement.Infrastructure.Repositories;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TaskManagement.Infrastructure.Services;
using Microsoft.OpenApi;
using TaskManagement.API.Middleware;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Information()
    .WriteTo.Console()
    .WriteTo.File("Logs/log-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger();

try
{
    Log.Information("Starting up the application");

    var builder = WebApplication.CreateBuilder(args);

    builder.Host.UseSerilog();

    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen(options =>
    {
        options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
        {
            Name = "Authorization",
            Type = SecuritySchemeType.Http,
            Scheme = "Bearer",
            BearerFormat = "JWT",
            In = ParameterLocation.Header,
            Description = "Enter your JWT token below (no need to type 'Bearer ' prefix)"
        });

        options.AddSecurityRequirement(document => new()
        {
            [new OpenApiSecuritySchemeReference("Bearer", document)] = new List<string>()
        });
    });

    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

    builder.Services.AddScoped<IUserRepository, UserRepository>();
    builder.Services.AddScoped<ITokenService, TokenService>();
    builder.Services.AddScoped<IRoleRepository, RoleRepository>();
    builder.Services.AddScoped<AuthService>();
    builder.Services.AddScoped<ITaskRepository, TaskRepository>();
    builder.Services.AddScoped<TaskService>();
    builder.Services.AddScoped<UserService>();

    builder.Services.AddCors(options =>
    {
        options.AddPolicy("AllowReactApp", policy =>
        {
            policy.WithOrigins("http://localhost:5173")
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
    });

    var jwtKey = builder.Configuration["JwtSettings:Key"];
    if (string.IsNullOrWhiteSpace(jwtKey) || Encoding.UTF8.GetByteCount(jwtKey) < 32)
    {
        throw new InvalidOperationException(
            "JwtSettings:Key must contain at least 32 bytes of signing material.");
    }

    builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["JwtSettings:Issuer"],
            ValidAudience = builder.Configuration["JwtSettings:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

    builder.Services.AddControllers();

    var app = builder.Build();

    app.UseSerilogRequestLogging();
    app.UseMiddleware<ExceptionHandlingMiddleware>();

    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }

    app.UseHttpsRedirection();
    app.UseCors("AllowReactApp");
    app.UseAuthentication();
    app.UseAuthorization();
    app.MapControllers();

    using (var scope = app.Services.CreateScope())
    {
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        var config = scope.ServiceProvider.GetRequiredService<IConfiguration>();
        await TaskManagement.Infrastructure.Data.DBSeeder.SeedAsync(db, config);
    }

    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Application terminated unexpectedly");
}
finally
{
    Log.CloseAndFlush();
}ParseOptions.0.jsonò
|D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\obj\Debug\net10.0\TaskManagement.API.GlobalUsings.g.csÇ// <auto-generated/>
global using Microsoft.AspNetCore.Builder;
global using Microsoft.AspNetCore.Hosting;
global using Microsoft.AspNetCore.Http;
global using Microsoft.AspNetCore.Routing;
global using Microsoft.Extensions.Configuration;
global using Microsoft.Extensions.DependencyInjection;
global using Microsoft.Extensions.Hosting;
global using Microsoft.Extensions.Logging;
global using System;
global using System.Collections.Generic;
global using System.IO;
global using System.Linq;
global using System.Net.Http;
global using System.Net.Http.Json;
global using System.Threading;
global using System.Threading.Tasks;
ParseOptions.0.jsonÍ
áD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\obj\Debug\net10.0\.NETCoreApp,Version=v10.0.AssemblyAttributes.cs»// <autogenerated />
using System;
using System.Reflection;
[assembly: global::System.Runtime.Versioning.TargetFrameworkAttribute(".NETCoreApp,Version=v10.0", FrameworkDisplayName = ".NET 10.0")]
ParseOptions.0.jsonì

zD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\obj\Debug\net10.0\TaskManagement.API.AssemblyInfo.csˇ//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Reflection;

[assembly: Microsoft.Extensions.Configuration.UserSecrets.UserSecretsIdAttribute("6ec9adce-a5d3-4505-a8b9-a1cc6ae59850")]
[assembly: System.Reflection.AssemblyCompanyAttribute("TaskManagement.API")]
[assembly: System.Reflection.AssemblyConfigurationAttribute("Debug")]
[assembly: System.Reflection.AssemblyFileVersionAttribute("1.0.0.0")]
[assembly: System.Reflection.AssemblyInformationalVersionAttribute("1.0.0+1fe372dbe293cb307e8228638d7dd6674e2101d8")]
[assembly: System.Reflection.AssemblyProductAttribute("TaskManagement.API")]
[assembly: System.Reflection.AssemblyTitleAttribute("TaskManagement.API")]
[assembly: System.Reflection.AssemblyVersionAttribute("1.0.0.0")]

// Generated by the MSBuild WriteCodeFragment class.

ParseOptions.0.json·
çD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\obj\Debug\net10.0\TaskManagement.API.MvcApplicationPartsAssemblyInfo.csπ//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Reflection;

[assembly: Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartAttribute("Microsoft.AspNetCore.OpenApi")]
[assembly: Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartAttribute("Swashbuckle.AspNetCore.SwaggerGen")]

// Generated by the MSBuild WriteCodeFragment class.

ParseOptions.0.json‡Œ
ÌD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\obj\Debug\net10.0\Microsoft.AspNetCore.OpenApi.SourceGenerators\Microsoft.AspNetCore.OpenApi.SourceGenerators.XmlCommentGenerator\OpenApiXmlCommentSupport.generated.cs◊Ã//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------
#nullable enable
// Suppress warnings about obsolete types and members
// in generated code
#pragma warning disable CS0612, CS0618

namespace System.Runtime.CompilerServices
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
    file sealed class InterceptsLocationAttribute : System.Attribute
    {
        public InterceptsLocationAttribute(int version, string data)
        {
        }
    }
}

namespace Microsoft.AspNetCore.OpenApi.Generated
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Globalization;
    using System.Linq;
    using System.Reflection;
    using System.Text;
    using System.Text.Json;
    using System.Text.Json.Nodes;
    using System.Threading;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.OpenApi;
    using Microsoft.AspNetCore.Mvc.Controllers;
    using Microsoft.AspNetCore.Mvc.ModelBinding.Metadata;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.OpenApi;

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file record XmlComment(
        string? Summary,
        string? Description,
        string? Remarks,
        string? Returns,
        string? Value,
        bool Deprecated,
        List<string>? Examples,
        List<XmlParameterComment>? Parameters,
        List<XmlResponseComment>? Responses);

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file record XmlParameterComment(string? Name, string? Description, string? Example, bool Deprecated);

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file record XmlResponseComment(string Code, string? Description, string? Example);

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file static class XmlCommentCache
    {
        private static Dictionary<string, XmlComment>? _cache;
        public static Dictionary<string, XmlComment> Cache => _cache ??= GenerateCacheEntries();

        private static Dictionary<string, XmlComment> GenerateCacheEntries()
        {
            var cache = new Dictionary<string, XmlComment>();



            return cache;
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file static class DocumentationCommentIdHelper
    {
        /// <summary>
        /// Generates a documentation comment ID for a type.
        /// Example: T:Namespace.Outer+Inner`1 becomes T:Namespace.Outer.Inner`1
        /// </summary>
        public static string CreateDocumentationId(this Type type)
        {
            if (type == null)
            {
                throw new ArgumentNullException(nameof(type));
            }

            return "T:" + GetTypeDocId(type, includeGenericArguments: false, omitGenericArity: false);
        }

        /// <summary>
        /// Generates a documentation comment ID for a property.
        /// Example: P:Namespace.ContainingType.PropertyName or for an indexer P:Namespace.ContainingType.Item(System.Int32)
        /// </summary>
        public static string CreateDocumentationId(this PropertyInfo property)
        {
            if (property == null)
            {
                throw new ArgumentNullException(nameof(property));
            }

            var sb = new StringBuilder();
            sb.Append("P:");

            if (property.DeclaringType != null)
            {
                sb.Append(GetTypeDocId(property.DeclaringType, includeGenericArguments: false, omitGenericArity: false));
            }

            sb.Append('.');
            sb.Append(property.Name);

            // For indexers, include the parameter list.
            var indexParams = property.GetIndexParameters();
            if (indexParams.Length > 0)
            {
                sb.Append('(');
                for (int i = 0; i < indexParams.Length; i++)
                {
                    if (i > 0)
                    {
                        sb.Append(',');
                    }

                    sb.Append(GetTypeDocId(indexParams[i].ParameterType, includeGenericArguments: true, omitGenericArity: false));
                }
                sb.Append(')');
            }

            return sb.ToString();
        }

        /// <summary>
        /// Generates a documentation comment ID for a property given its container type and property name.
        /// Example: P:Namespace.ContainingType.PropertyName
        /// </summary>
        public static string CreateDocumentationId(Type containerType, string propertyName)
        {
            if (containerType == null)
            {
                throw new ArgumentNullException(nameof(containerType));
            }
            if (string.IsNullOrEmpty(propertyName))
            {
                throw new ArgumentException("Property name cannot be null or empty.", nameof(propertyName));
            }

            var sb = new StringBuilder();
            sb.Append("P:");
            sb.Append(GetTypeDocId(containerType, includeGenericArguments: false, omitGenericArity: false));
            sb.Append('.');
            sb.Append(propertyName);

            return sb.ToString();
        }

        /// <summary>
        /// Generates a documentation comment ID for a method (or constructor).
        /// For example:
        ///   M:Namespace.ContainingType.MethodName(ParamType1,ParamType2)~ReturnType
        ///   M:Namespace.ContainingType.#ctor(ParamType)
        /// </summary>
        public static string CreateDocumentationId(this MethodInfo method)
        {
            if (method == null)
            {
                throw new ArgumentNullException(nameof(method));
            }

            var sb = new StringBuilder();
            sb.Append("M:");

            // Append the fully qualified name of the declaring type.
            if (method.DeclaringType != null)
            {
                sb.Append(GetTypeDocId(method.DeclaringType, includeGenericArguments: false, omitGenericArity: false));
            }

            sb.Append('.');

            // Append the method name, handling constructors specially.
            if (method.IsConstructor)
            {
                sb.Append(method.IsStatic ? "#cctor" : "#ctor");
            }
            else
            {
                sb.Append(method.Name);
                if (method.IsGenericMethod)
                {
                    sb.Append("``");
                    sb.AppendFormat(CultureInfo.InvariantCulture, "{0}", method.GetGenericArguments().Length);
                }
            }

            // Append the parameter list, if any.
            var parameters = method.GetParameters();
            if (parameters.Length > 0)
            {
                sb.Append('(');
                for (int i = 0; i < parameters.Length; i++)
                {
                    if (i > 0)
                    {
                        sb.Append(',');
                    }

                    // Omit the generic arity for the parameter type.
                    sb.Append(GetTypeDocId(parameters[i].ParameterType, includeGenericArguments: true, omitGenericArity: true));
                }
                sb.Append(')');
            }

            // Append the return type after a '~' (if the method returns a value).
            if (method.ReturnType != typeof(void))
            {
                sb.Append('~');
                // Omit the generic arity for the return type.
                sb.Append(GetTypeDocId(method.ReturnType, includeGenericArguments: true, omitGenericArity: true));
            }

            return sb.ToString();
        }

        /// <summary>
        /// Generates a documentation ID string for a type.
        /// This method handles nested types (replacing '+' with '.'),
        /// generic types, arrays, pointers, by-ref types, and generic parameters.
        /// The <paramref name="includeGenericArguments"/> flag controls whether
        /// constructed generic type arguments are emitted, while <paramref name="omitGenericArity"/>
        /// controls whether the generic arity marker (e.g. "`1") is appended.
        /// </summary>
        private static string GetTypeDocId(Type type, bool includeGenericArguments, bool omitGenericArity)
        {
            if (type.IsGenericParameter)
            {
                // Use `` for method-level generic parameters and ` for type-level.
                if (type.DeclaringMethod != null)
                {
                    return "``" + type.GenericParameterPosition;
                }
                else if (type.DeclaringType != null)
                {
                    return "`" + type.GenericParameterPosition;
                }
                else
                {
                    return type.Name;
                }
            }

            if (type.IsGenericType)
            {
                Type genericDef = type.GetGenericTypeDefinition();
                string fullName = genericDef.FullName ?? genericDef.Name;

                var sb = new StringBuilder(fullName.Length);

                // Replace '+' with '.' for nested types
                for (var i = 0; i < fullName.Length; i++)
                {
                    char c = fullName[i];
                    if (c == '+')
                    {
                        sb.Append('.');
                    }
                    else if (c == '`')
                    {
                        break;
                    }
                    else
                    {
                        sb.Append(c);
                    }
                }

                if (!omitGenericArity)
                {
                    int arity = genericDef.GetGenericArguments().Length;
                    sb.Append('`');
                    sb.AppendFormat(CultureInfo.InvariantCulture, "{0}", arity);
                }

                if (includeGenericArguments && !type.IsGenericTypeDefinition)
                {
                    var typeArgs = type.GetGenericArguments();
                    sb.Append('{');

                    for (int i = 0; i < typeArgs.Length; i++)
                    {
                        if (i > 0)
                        {
                            sb.Append(',');
                        }

                        sb.Append(GetTypeDocId(typeArgs[i], includeGenericArguments, omitGenericArity));
                    }

                    sb.Append('}');
                }

                return sb.ToString();
            }

            // For non-generic types, use FullName (if available) and replace nested type separators.
            return (type.FullName ?? type.Name).Replace('+', '.');
        }

        /// <summary>
        /// Normalizes a documentation comment ID to match the compiler-style format.
        /// Strips the return type suffix for ordinary methods but retains it for conversion operators.
        /// </summary>
        /// <param name="docId">The documentation comment ID to normalize.</param>
        /// <returns>The normalized documentation comment ID.</returns>
        public static string NormalizeDocId(string docId)
        {
            // Find the tilde character that indicates the return type suffix
            var tildeIndex = docId.IndexOf('~');
            if (tildeIndex == -1)
            {
                // No return type suffix, return as-is
                return docId;
            }

            // Check if this is a conversion operator (op_Implicit or op_Explicit)
            // For these operators, we need to keep the return type suffix
            if (docId.Contains("op_Implicit") || docId.Contains("op_Explicit"))
            {
                return docId;
            }

            // For ordinary methods, strip the return type suffix
            return docId.Substring(0, tildeIndex);
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file class XmlCommentOperationTransformer : IOpenApiOperationTransformer
    {
        public Task TransformAsync(OpenApiOperation operation, OpenApiOperationTransformerContext context, CancellationToken cancellationToken)
        {
            var methodInfo = context.Description.ActionDescriptor is ControllerActionDescriptor controllerActionDescriptor
                ? controllerActionDescriptor.MethodInfo
                : context.Description.ActionDescriptor.EndpointMetadata.OfType<MethodInfo>().SingleOrDefault();

            if (methodInfo is null)
            {
                return Task.CompletedTask;
            }
            if (XmlCommentCache.Cache.TryGetValue(DocumentationCommentIdHelper.NormalizeDocId(methodInfo.CreateDocumentationId()), out var methodComment))
            {
                if (methodComment.Summary is { } summary)
                {
                    operation.Summary = summary;
                }
                if (methodComment.Description is { } description)
                {
                    operation.Description = description;
                }
                if (methodComment.Remarks is { } remarks)
                {
                    operation.Description = remarks;
                }
                if (methodComment.Parameters is { Count: > 0})
                {
                    foreach (var parameterComment in methodComment.Parameters)
                    {
                        var parameterInfo = methodInfo.GetParameters().SingleOrDefault(info => info.Name == parameterComment.Name);
                        var operationParameter = operation.Parameters?.SingleOrDefault(parameter => parameter.Name == parameterComment.Name);
                        if (operationParameter is not null)
                        {
                            var targetOperationParameter = UnwrapOpenApiParameter(operationParameter);
                            targetOperationParameter.Description = parameterComment.Description;
                            if (parameterComment.Example is { } jsonString)
                            {
                                targetOperationParameter.Example = jsonString.Parse();
                            }
                            targetOperationParameter.Deprecated = parameterComment.Deprecated;
                        }
                        else
                        {
                            var requestBody = operation.RequestBody;
                            if (requestBody is not null)
                            {
                                requestBody.Description = parameterComment.Description;
                                if (parameterComment.Example is { } jsonString)
                                {
                                    var content = requestBody?.Content?.Values;
                                    if (content is null)
                                    {
                                        continue;
                                    }
                                    foreach (var mediaType in content)
                                    {
                                        mediaType.Example = jsonString.Parse();
                                    }
                                }
                            }
                        }
                    }
                }
                // Applies `<returns>` on XML comments for operation with single response value.
                if (methodComment.Returns is { } returns && operation.Responses is { Count: 1 })
                {
                    var response = operation.Responses.First();
                    response.Value.Description = returns;
                }
                // Applies `<response>` on XML comments for operation with multiple response values.
                if (methodComment.Responses is { Count: > 0} && operation.Responses is { Count: > 0 })
                {
                    foreach (var response in operation.Responses)
                    {
                        var responseComment = methodComment.Responses.SingleOrDefault(xmlResponse => xmlResponse.Code == response.Key);
                        if (responseComment is not null)
                        {
                            response.Value.Description = responseComment.Description;
                        }
                    }
                }
            }
            foreach (var parameterDescription in context.Description.ParameterDescriptions)
            {
                var metadata = parameterDescription.ModelMetadata;
                if (metadata is not null
                    && metadata.MetadataKind == ModelMetadataKind.Property
                    && metadata.ContainerType is { } containerType
                    && metadata.PropertyName is { } propertyName)
                {
                    var propertyDocId = DocumentationCommentIdHelper.CreateDocumentationId(containerType, propertyName);
                    if (XmlCommentCache.Cache.TryGetValue(DocumentationCommentIdHelper.NormalizeDocId(propertyDocId), out var propertyComment))
                    {
                        var parameter = operation.Parameters?.SingleOrDefault(p => p.Name == metadata.Name);
                        var description = propertyComment.Summary;
                        if (!string.IsNullOrEmpty(description) && !string.IsNullOrEmpty(propertyComment.Value))
                        {
                            description = $"{description}\n{propertyComment.Value}";
                        }
                        else if (string.IsNullOrEmpty(description))
                        {
                            description = propertyComment.Value;
                        }
                        if (parameter is null)
                        {
                            if (operation.RequestBody is not null)
                            {
                                operation.RequestBody.Description = description;
                                if (propertyComment.Examples?.FirstOrDefault() is { } jsonString)
                                {
                                    var content = operation.RequestBody.Content?.Values;
                                    if (content is null)
                                    {
                                        continue;
                                    }
                                    var parsedExample = jsonString.Parse();
                                    foreach (var mediaType in content)
                                    {
                                        mediaType.Example = parsedExample;
                                    }
                                }
                            }
                            continue;
                        }
                        var targetOperationParameter = UnwrapOpenApiParameter(parameter);
                        if (targetOperationParameter is not null)
                        {
                            targetOperationParameter.Description = description;
                            if (propertyComment.Examples?.FirstOrDefault() is { } jsonString)
                            {
                                targetOperationParameter.Example = jsonString.Parse();
                            }
                        }
                    }
                }
            }

            return Task.CompletedTask;
        }

        private static OpenApiParameter UnwrapOpenApiParameter(IOpenApiParameter sourceParameter)
        {
            if (sourceParameter is OpenApiParameterReference parameterReference)
            {
                if (parameterReference.Target is OpenApiParameter target)
                {
                    return target;
                }
                else
                {
                    throw new InvalidOperationException($"The input schema must be an {nameof(OpenApiParameter)} or {nameof(OpenApiParameterReference)}.");
                }
            }
            else if (sourceParameter is OpenApiParameter directParameter)
            {
                return directParameter;
            }
            else
            {
                throw new InvalidOperationException($"The input schema must be an {nameof(OpenApiParameter)} or {nameof(OpenApiParameterReference)}.");
            }
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file class XmlCommentSchemaTransformer : IOpenApiSchemaTransformer
    {
        public Task TransformAsync(OpenApiSchema schema, OpenApiSchemaTransformerContext context, CancellationToken cancellationToken)
        {
            // Apply comments from the type
            if (XmlCommentCache.Cache.TryGetValue(DocumentationCommentIdHelper.NormalizeDocId(context.JsonTypeInfo.Type.CreateDocumentationId()), out var typeComment))
            {
                schema.Description = typeComment.Summary;
                if (typeComment.Examples?.FirstOrDefault() is { } jsonString)
                {
                    schema.Example = jsonString.Parse();
                }
            }

            if (context.JsonPropertyInfo is { AttributeProvider: PropertyInfo propertyInfo })
            {
                // Apply comments from the property
                if (XmlCommentCache.Cache.TryGetValue(DocumentationCommentIdHelper.NormalizeDocId(propertyInfo.CreateDocumentationId()), out var propertyComment))
                {
                    var description = propertyComment.Summary;
                    if (!string.IsNullOrEmpty(description) && !string.IsNullOrEmpty(propertyComment.Value))
                    {
                        description = $"{description}\n{propertyComment.Value}";
                    }
                    else if (string.IsNullOrEmpty(description))
                    {
                        description = propertyComment.Value;
                    }
                    if (schema.Metadata is null
                        || !schema.Metadata.TryGetValue("x-schema-id", out var schemaId)
                        || string.IsNullOrEmpty(schemaId as string))
                    {
                        // Inlined schema
                        schema.Description = description;
                        if (propertyComment.Examples?.FirstOrDefault() is { } jsonString)
                        {
                            schema.Example = jsonString.Parse();
                        }
                    }
                    else
                    {
                        // Schema Reference
                        if (!string.IsNullOrEmpty(description))
                        {
                            schema.Metadata["x-ref-description"] = description;
                        }
                        if (propertyComment.Examples?.FirstOrDefault() is { } jsonString)
                        {
                            schema.Metadata["x-ref-example"] = jsonString.Parse()!;
                        }
                    }
                }
            }
            return Task.CompletedTask;
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file static class JsonNodeExtensions
    {
        public static JsonNode? Parse(this string? json)
        {
            if (json is null)
            {
                return null;
            }

            try
            {
                return JsonNode.Parse(json);
            }
            catch (JsonException)
            {
                try
                {
                    // If parsing fails, try wrapping in quotes to make it a valid JSON string
                    return JsonNode.Parse($"\"{json.Replace("\"", "\\\"")}\"");
                }
                catch (JsonException)
                {
                    return null;
                }
            }
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.AspNetCore.OpenApi.SourceGenerators, Version=10.0.10.0, Culture=neutral, PublicKeyToken=adb9793829ddae60", "10.0.10.0")]
    file static class GeneratedServiceCollectionExtensions
    {

    }
}
ParseOptions.0.json©
ÈD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\obj\Debug\net10.0\Microsoft.AspNetCore.App.SourceGenerators\Microsoft.AspNetCore.SourceGenerators.PublicProgramSourceGenerator\PublicTopLevelProgram.Generated.g.cs•// <auto-generated />
/// <summary>
/// Auto-generated public partial Program class for top-level statement apps.
/// </summary>
public partial class Program { }ParseOptions.0.json