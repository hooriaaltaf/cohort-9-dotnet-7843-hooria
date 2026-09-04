using System.Net;
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
