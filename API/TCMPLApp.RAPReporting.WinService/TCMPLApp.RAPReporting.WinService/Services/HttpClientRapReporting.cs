//using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web;
using TCMPLApp.RAPReporting.WinService.Classes;

namespace TCMPLApp.RAPReporting.WinService.Services
{
    public interface IHttpClientRapReporting
    {
        public Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri, string activeyear = null);
    }

    public class HttpClientRapReporting : IHttpClientRapReporting
    {
        private IConfiguration _configuration;
        private HttpClient _httpClient;
        private string _baseUri;
        private int _port;
        private ILogger<HttpClientRapReporting> _logger;

        public HttpClientRapReporting(HttpClient httpClient, IConfiguration configuration, IHostEnvironment hostEnvironment,ILogger<HttpClientRapReporting> logger)
        {
            _logger = logger;
            _httpClient = httpClient;
            _configuration = configuration;
            

            var clientTimeOutInMin = double.Parse(_configuration.GetValue<string>("RapHttpClientTimeOutInMinutes") ?? "30");

            _httpClient.Timeout = TimeSpan.FromMinutes(clientTimeOutInMin);

            if (hostEnvironment.IsDevelopment())
            {
                _baseUri = _configuration.GetValue<string>("DevelopmentRapReportingApiBaseUri");
                _port = configuration.GetValue<int>("DevelopmentRapReportingApiPort");
            }
            else if (hostEnvironment.IsStaging())
            {
                _baseUri = _configuration.GetValue<string>("QualityRapReportingApiBaseUri");
                _port = configuration.GetValue<int>("QualityRapReportingApiPort");
            }
            else if(hostEnvironment.IsProduction())
            {
                _baseUri = _configuration.GetValue<string>("ProductionRapReportingApiBaseUri");
                _port = configuration.GetValue<int>("ProductionRapReportingApiPort");
            }
        }

        public async Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri, string activeyear = null)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);
            _logger.LogInformation("requestUri - " + requestUri);
            // Timeout enhanced

            if (!string.IsNullOrEmpty(activeyear))
            {
                _httpClient.DefaultRequestHeaders.Add("activeYear", activeyear);
            }
            return await _httpClient.GetAsync(requestUri);
        }

        private static string GetUriWithparameters<T>(T t, string uri, int port) where T : class, new()
        {
            var builder = new UriBuilder(uri);
            builder.Port = port;
            if (t != null)
            {
                var query = HttpUtility.ParseQueryString(builder.Query);

                PropertyInfo[] properties = typeof(T).GetProperties();

                foreach (PropertyInfo property in properties)
                {
                    if (property.GetValue(t, null) != null && !string.IsNullOrEmpty(property.GetValue(t, null).ToString()))
                    {
                        query[property.Name.ToLower()] = property.GetValue(t, null).ToString();
                    }
                    builder.Query = query.ToString();
                }
            }
            return builder.Uri.ToString();
        }
    }
}