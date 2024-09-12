using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Text.Json;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.WebApp.Classes;

namespace TCMPLApp.WebApp.Extensions
{

    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger _logger;
        public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext httpContext)
        {
            try
            {
                await _next(httpContext);
            }
            catch (Exception ex)
            {
                switch (ex)
                {
                    case CustomJsonException:
                        await HandleExceptionAsync(httpContext, (CustomJsonException)ex);
                        break;
                    default:
                        await HandleExceptionAsync(httpContext, ex);
                        break;
                }

                //switch ex
                //    case CustomJsonException:
                //    await HandleExceptionAsync(httpContext, (CustomJsonException)ex);
                //default:
                //    HandleExceptionAsync(httpContext, ex);
                //}
            }
        }
        private async Task HandleExceptionAsync(HttpContext context, Exception exception)
        {

            UserIdentity userIdentity = null;
            if (context.Items["UserIdentity"] != null)
            {
                userIdentity = await Task.FromResult((UserIdentity)context.Items["UserIdentity"]);
            }

            //Add logging code to log exception details
            _logger.LogError("Url - " + context.Request.Path);
            _logger.LogError("User - " + context.User.Identity.Name);
            if (userIdentity != null)
            {
                _logger.LogError("MetaId - " + userIdentity.MetaId);
                _logger.LogError("PersonId - " + userIdentity.EmployeeId);
                _logger.LogError("Empno - " + userIdentity.EmpNo);
            }
            _logger.LogError(exception.StackTrace);
            //_logger.LogError(id.ToString() + " - Msg - " + ex.Message);
            //_logger.LogError(id.ToString() + " - Trace - " + ex.StackTrace);

            throw exception;
            //var result = JsonSerializer.Serialize(new ErrorViewModel
            //{
            //    StatusCode = StatusCodes.Status500InternalServerError,
            //    Message = "Internal server error - Deven" 
            //});
            //httpContext.Response.StatusCode = StatusCodes.Status500InternalServerError;
            //httpContext.Response.ContentType = "application/json";
            //await httpContext.Response.WriteAsync(result);

        }

        private async Task HandleExceptionAsync(HttpContext context, CustomJsonException exception)
        {

            UserIdentity userIdentity = null;
            if (context.Items["UserIdentity"] != null)
            {
                userIdentity = await Task.FromResult((UserIdentity)context.Items["UserIdentity"]);
            }

            //Add logging code to log exception details
            _logger.LogError("Url - " + context.Request.Path);
            _logger.LogError("User - " + context.User.Identity.Name);
            if (userIdentity != null)
            {
                _logger.LogError("MetaId - " + userIdentity.MetaId);
                _logger.LogError("PersonId - " + userIdentity.EmployeeId);
                _logger.LogError("Empno - " + userIdentity.EmpNo);
            }
            _logger.LogError(exception.StackTrace);
            //_logger.LogError(id.ToString() + " - Msg - " + ex.Message);
            //_logger.LogError(id.ToString() + " - Trace - " + ex.StackTrace);

            throw exception;
            //var result = JsonSerializer.Serialize(new ErrorViewModel
            //{
            //    StatusCode = StatusCodes.Status500InternalServerError,
            //    Message = "Internal server error - Deven" 
            //});
            //httpContext.Response.StatusCode = StatusCodes.Status500InternalServerError;
            //httpContext.Response.ContentType = "application/json";
            //await httpContext.Response.WriteAsync(result);

        }
    }

    // Extension method used to add the middleware to the HTTP request pipeline.
    public static class ExceptionMiddlewareExtensions
    {
        public static IApplicationBuilder UseExceptionMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<ExceptionMiddleware>();
        }
    }
}
