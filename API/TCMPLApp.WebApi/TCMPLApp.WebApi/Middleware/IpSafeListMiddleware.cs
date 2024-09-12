using System.Net;

namespace TCMPLApp.WebApi.Middleware
{
    public class IpSafeListMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<IpSafeListMiddleware> _logger;
        private readonly byte[][] _safelist;
        private readonly IConfiguration _configuration;

        public IpSafeListMiddleware(RequestDelegate next, IConfiguration configuration, ILogger<IpSafeListMiddleware> logger)
        {
            //var ips = safelist.Split(';');
            _configuration = configuration;

            var safelist = _configuration
                .GetSection("IpWhitelist")
                .GetChildren()
                .Select(x => x.Value)
                .ToArray();


            var ips = safelist;
            _safelist = new byte[ips.Length][];
            for (var i = 0; i < ips.Length; i++)
            {
                _safelist[i] = IPAddress.Parse(ips[i]).GetAddressBytes();
            }

            _next = next;
            _logger = logger;
        }

        public async Task Invoke(HttpContext context)
        {
            //if (context.Request.Method != HttpMethod.Get.Method)
            {
                var remoteIp = context.Connection.RemoteIpAddress;
                var userName = context.Request.HttpContext.User.Identity.Name;
                _logger.LogInformation("Request by user: {UserName}; from Remote IP address: {RemoteIp}", userName,remoteIp);

                var bytes = remoteIp.GetAddressBytes();
                var badIp = true;
                foreach (var address in _safelist)
                {
                    if (address.SequenceEqual(bytes))
                    {
                        badIp = false;
                        break;
                    }
                }

                if (badIp)
                {
                    _logger.LogWarning(
                        "Forbidden Request from Remote IP address: {RemoteIp}", remoteIp);
                    context.Response.StatusCode = (int)HttpStatusCode.Forbidden;
                    return;
                }
            }

            await _next.Invoke(context);
        }
    }
}



