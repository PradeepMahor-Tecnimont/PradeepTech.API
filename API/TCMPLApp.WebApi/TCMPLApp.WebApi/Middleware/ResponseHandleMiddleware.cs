using Microsoft.IO;
using Newtonsoft.Json;
using System.Net;
using System.Text;

namespace TCMPLApp.WebApi.Middleware
{
    public class ResponseHandleMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ResponseHandleMiddleware> _logger;
        private RecyclableMemoryStreamManager _recyclableMemoryStreamManager;
        private readonly IConfiguration _configuration;

        public ResponseHandleMiddleware(RequestDelegate next, IConfiguration configuration, ILogger<ResponseHandleMiddleware> logger)
        {
            _next = next;
            _logger = logger;
            _configuration = configuration;
            _recyclableMemoryStreamManager = new RecyclableMemoryStreamManager();
        }

        public async Task Invoke(HttpContext context)
        {
            Stream originalBody = context.Response.Body;
            var memStream = _recyclableMemoryStreamManager.GetStream();
            try
            {
                context.Response.Body = memStream;

                await _next(context);

                context.Response.Body = originalBody;

                memStream.Seek(0, SeekOrigin.Begin);

                string[] UrlsToSkip4ResponseHandling = Array.Empty<string>();

                string openXMLType = _configuration.GetSection("ContentTypeOpenXML").Value.ToString();
                string openXMLTypeDoc = _configuration.GetSection("ContentTypeOpenXMLDoc").Value.ToString();
                string zipType = _configuration.GetSection("ContentTypeZIP").Value.ToString();
                string pdfType = _configuration.GetSection("ContentTypePDF").Value.ToString();
                UrlsToSkip4ResponseHandling = Array.ConvertAll<string, string>(UrlsToSkip4ResponseHandling, delegate (string s) { return s.ToLower(); });
                string currentURL = context.Request.Path.ToString();
                if (
                    !(UrlsToSkip4ResponseHandling.Contains(currentURL.ToLower())) &&
                    !(context.Response.ContentType == openXMLType) &&
                    !(context.Response.ContentType == openXMLTypeDoc) &&
                    !(context.Response.ContentType == zipType) &&
                    !(context.Response.ContentType == pdfType)
                   )
                {
                    string responseBody = new StreamReader(memStream).ReadToEnd();

                    if (responseBody.Length > 0)
                    {
                        context.Response.ContentType = "application/json";
                        //context.Response.StatusCode = 200;

                        var result = JsonConvert.SerializeObject(responseBody);

                        context.Response.ContentLength = Encoding.UTF8.GetByteCount(result);
                        await context.Response.WriteAsync(result);
                    }
                }
                else
                    await memStream.CopyToAsync(originalBody);

            }
            catch (System.Exception ex)
            {
                await HandleException(context, ex, originalBody);
            }
        }

        private async Task HandleException(HttpContext context, System.Exception ex, Stream paramOriginalBody)
        {
            string currentURL = context.Request.Path.ToString();

            context.Response.Body = paramOriginalBody;

            HttpStatusCode internalError = HttpStatusCode.InternalServerError; // 500
                                                                               //ResponseModel responseModel = new ResponseModel { Status = "KO", Message=ex.Message };
            _logger.LogError("Url - " + context.Request.Path);
            _logger.LogError("User - " + context.User.Identity.Name);


            _logger.LogError(ex, "Exception while executing API");

            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)internalError;

            //var responseContent = JsonConvert.SerializeObject(new ResponseModel { Status = "KO", Message = ex.Message });
            var responseContent = JsonConvert.SerializeObject(ex.Message);
            context.Response.ContentLength = Encoding.UTF8.GetByteCount(responseContent);
            await context.Response.WriteAsync(responseContent);

        }

    }
}
