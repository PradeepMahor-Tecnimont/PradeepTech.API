using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using RapReportingApi.Common;
using RapReportingApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace RapReportingApi.Controllers
{
    //[Authorize]
    [ApiController]
    // [Route("[controller]")]
    [Route("api/[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;
        private IOptions<AppSettings> appSettings;

        public WeatherForecastController(ILogger<WeatherForecastController> logger, IOptions<AppSettings> paramAppSettings)
        {
            _logger = logger;
            appSettings = paramAppSettings;
        }

        [HttpGet]
        public IEnumerable<WeatherForecast> Get()
        {
            var rng = new Random();
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateTime.Now.AddDays(index),
                TemperatureC = rng.Next(-20, 55),
                Summary = Summaries[rng.Next(Summaries.Length)]
            })
            .ToArray();
        }

        [HttpPost]
        public IActionResult Post(string value)
        {
            if (value != "GenerateRSAKeyFile")
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status304NotModified, "Action not performed");

            try
            {
                string strDateStamp = DateTime.Now.ToString("yyyyMMddHHmmss");
                string PrivateKeyFile, PublicKeyFile;
                PrivateKeyFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + "\\" + "RSAPrivateKey_" + strDateStamp;
                PublicKeyFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + "\\" + "RSAPublicKey_" + strDateStamp;
                RSAHelper.GenerateRsaKeyPair(PrivateKeyFile, PublicKeyFile);
                return StatusCode(Microsoft.AspNetCore.Http.StatusCodes.Status200OK, "Action performed");
            }
            catch (Exception)
            {
                throw;
            }

            // For more information on protecting this API from Cross Site Request Forgery (CSRF)
            // attacks, see https://go.microsoft.com/fwlink/?LinkID=717803
        }
    }
}