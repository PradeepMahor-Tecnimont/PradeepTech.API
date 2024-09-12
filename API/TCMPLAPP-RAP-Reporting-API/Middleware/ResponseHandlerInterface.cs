using Microsoft.AspNetCore.Builder;
using TIMESHEEET_API.Middleware;

namespace RapReportingApi.Middleware
{
    public static class IResponseHandlerMiddleware
    {
        public static IApplicationBuilder UseRequestDecryptMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<RequestDecryptMiddleWare>();
        }

        public static IApplicationBuilder UseResponseHandlingMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<ResponseHandlerMiddleware>();
        }
    }
}