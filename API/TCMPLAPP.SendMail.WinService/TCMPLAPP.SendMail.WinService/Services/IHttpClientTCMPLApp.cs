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
using TCMPLAPP.SendMail.WinService;

namespace TCMPLApp.SendMail.WinService.Services
{
    public interface IHttpClientTCMPLApp
    {
        public Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri);
    }

    public class HttpClientTCMPLApp : IHttpClientTCMPLApp
    {
        private readonly IConfiguration _configuration;
        private readonly HttpClient _httpClient;
        private readonly string? _baseUri;
        private readonly int _port;

        public HttpClientTCMPLApp(HttpClient httpClient, IConfiguration configuration, IHostEnvironment hostEnvironment)
        {
            _httpClient = httpClient;
            _configuration = configuration;
            _httpClient.Timeout = TimeSpan.FromMinutes(5);
            _baseUri = "";
            if (hostEnvironment.IsDevelopment())
            {
                _baseUri = _configuration.GetValue<string>("DevelopmentTCMPLAppBaseUri");
                _port = configuration.GetValue<int>("DevelopmentTCMPLAppPort");

            }
            else if (hostEnvironment.IsStaging())
            {
                _baseUri = _configuration.GetValue<string>("StagingTCMPLAppBaseUri");
                _port = configuration.GetValue<int>("StagingTCMPLAppPort");

            }
            else if (hostEnvironment.IsProduction())
            {
                _baseUri = _configuration.GetValue<string>("ProductionTCMPLAppBaseUri");
                _port = configuration.GetValue<int>("ProductionTCMPLAppPort");

            }



        }

        public async Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            // Timeout enhanced
            //_httpClient.Timeout = TimeSpan.FromMinutes(10);

            //if (!string.IsNullOrEmpty(activeyear))
            //{
            //    _httpClient.DefaultRequestHeaders.Add("activeYear", activeyear);
            //}
            return await _httpClient.GetAsync(requestUri);
        }

        private static string GetUriWithparameters<T>(T t, string uri, int port) where T : class, new()
        {
            var builder = new UriBuilder(uri)
            {
                Port = port
            };
            if (t != null)
            {
                var query = HttpUtility.ParseQueryString(builder.Query);

                PropertyInfo[] properties = typeof(T).GetProperties();

                foreach (PropertyInfo property in properties)
                {
                    if (property.GetValue(t, null) != null && !string.IsNullOrEmpty(property.GetValue(t, null)?.ToString()))
                    {
                        query[property.Name.ToLower()] = property?.GetValue(t, null)?.ToString();
                    }
                    builder.Query = query.ToString();
                }
            }
            return builder.Uri.ToString();
        }
    }
}