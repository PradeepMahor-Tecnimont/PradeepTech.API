using API.Errors;
using System.Net;
using System.Text.Json;

namespace API.Middleware
{
    public class ExceptionMiddleWare(
            IHostEnvironment env,
            RequestDelegate next)
    {
        public async Task InvokeAsync(HttpContext content)
        {
            try
            {
                await next(content);
            }
            catch (Exception ex)
            {
                await HandleExceptionAsync(content, ex, env);
            }
        }

        private static Task HandleExceptionAsync(HttpContext content, Exception ex, IHostEnvironment env)
        {
            content.Response.ContentType = "application/json";
            content.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

            var responce = env.IsDevelopment()
                ? new ApiErrorResponse(content.Response.StatusCode, ex.Message, ex.StackTrace)
                : new ApiErrorResponse(content.Response.StatusCode, ex.Message, "Internal server error");

            var option = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            };

            var json = JsonSerializer.Serialize(responce, option);

            return content.Response.WriteAsync(json);
        }

        // Extension method used to add the middleware to the HTTP request pipeline.
    }

    //public static class ExceptionMiddlewareExtensions
    //{
    //    public static IApplicationBuilder UseExceptionMiddleware(this IApplicationBuilder builder)
    //    {
    //        return builder.UseMiddleware<ExceptionMiddleWare>();
    //    }
    //}
}