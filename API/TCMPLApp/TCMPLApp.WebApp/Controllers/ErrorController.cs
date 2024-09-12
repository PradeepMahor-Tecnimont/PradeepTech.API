using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Diagnostics;
using System.Net;
using TCMPLApp.Models;
using TCMPLApp.WebApp.Classes;

namespace TCMPLApp.WebApp.Controllers
{
    public class ErrorController : BaseController
    {
        public string RequestId { get; set; }
        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
        public string ExceptionMessage { get; set; }
        private readonly ILogger _logger;
        private IWebHostEnvironment _env;


        public ErrorController(ILogger<ErrorController> logger, IWebHostEnvironment env)
        {
            _logger = logger;
            _env = env;
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Index()
        {
            RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier;

            var exceptionHandlerPathFeature = HttpContext.Features.Get<IExceptionHandlerPathFeature>();

            string errorMessage = string.Empty;
            if (exceptionHandlerPathFeature?.Error is CustomJsonException)
            {
                errorMessage = "An internal error occurred while processing your request.";
                return StatusCode((int)HttpStatusCode.InternalServerError, errorMessage);
            }
            else if (exceptionHandlerPathFeature.Error.Message.StartsWith("ORA-20001"))
            {
                errorMessage = "An internal error occurred while processing your request. Meta Id could not be matched.";
            }
            else
            {
                errorMessage = "An internal error occurred while processing your request.";
                if (_env.IsDevelopment() || _env.IsStaging())
                    errorMessage += exceptionHandlerPathFeature.Error.Message;
            }

            return View("Error", new ErrorViewModel
            {
                RequestId = RequestId,
                Message = errorMessage
            });

        }

        public IActionResult Details()
        {
            RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier;

            var exceptionHandlerPathFeature = HttpContext.Features.Get<IExceptionHandlerPathFeature>();
            string errorMessage = "";
            if (exceptionHandlerPathFeature?.Error is CustomJsonException)
            {
                errorMessage = exceptionHandlerPathFeature.Error.Message + " - " + exceptionHandlerPathFeature.Error.InnerException + " - " + exceptionHandlerPathFeature.Error.StackTrace;
                return StatusCode((int)HttpStatusCode.InternalServerError, errorMessage);
            }
            else if (exceptionHandlerPathFeature.Error.Message.StartsWith("ORA-20001"))
            {
                errorMessage = "An internal error occurred while processing your request. Meta Id could not be matched.";
            }
            else
            {
                errorMessage = exceptionHandlerPathFeature.Error.Message + " - " + exceptionHandlerPathFeature.Error.InnerException + " - " + exceptionHandlerPathFeature.Error.StackTrace;
            }
            return View("Error", new ErrorViewModel
            {
                RequestId = RequestId,
                Message = errorMessage
            });

        }

        public IActionResult AccessDenied()
        {
            string errorMessage = "Access is denied to requested resource.";
            return View("Error", new ErrorViewModel
            {
                RequestId = RequestId,
                Message = errorMessage
            });
        }

        public IActionResult StatusCodePages(int? statusCode = null)
        {
            ErrorViewModel objError = new ErrorViewModel();
            objError.RequestId = RequestId;
            if (statusCode.HasValue)
            {
                if (statusCode == 403)
                    objError.Message = "Access is denied to requested resource.";
                if (statusCode == 404)
                    objError.Message = "Requested resource could not be found.";
                else
                    objError.Message = string.Format("Error - StatusCode {0} generated", statusCode);

            }
            return View("Error", objError);
        }
    }
}
