using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using RapReportingApi.Models;
using System.Threading.Tasks;

namespace RapReportingApi.Middleware
{
    [Authorize]
    public class SetHeaderUserIdentity
    {
        private readonly RequestDelegate _next;
        private IOptions<AppSettings> appSettings;
        private readonly ILogger<SetHeaderUserIdentity> _log;

        public SetHeaderUserIdentity(RequestDelegate next, IOptions<AppSettings> _settings, ILogger<SetHeaderUserIdentity> log)
        {
            _next = next;
            appSettings = _settings;
            _log = log;
        }

        public async Task Invoke(HttpContext context)
        {
            //var request_headers = context.Request.Headers;
            context.Request.Headers.Add("x-UserIdentityName", context.User.Identity.Name);
            await _next.Invoke(context);
        }
    }
}