using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web;
using TCMPLApp.WebApp.Classes;
using System.Text;
using Newtonsoft.Json;

namespace TCMPLApp.WebApp.Services
{
    public interface IHttpClientRapReporting
    {
        public Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri, string activeyear = null);

        public Task<HttpResponseMessage> ExecutePutUriAsync(HCModel hcModel, string uri, object postObject, string activeyear = null);

        public Task<HttpResponseMessage> ExecutePostUriAsync(HCModel hcModel, string uri, object postObject, string activeyear = null);

        public Task<HttpResponseMessage> ExecutePutStrUriAsync(HCModel hcModel, string uri, string postStr, string activeyear = null);

        public Task<HttpResponseMessage> ExecuteDeleteUriAsync(HCModel hcModel, string uri, object postObject, string activeyear = null);
    }

    public class HttpClientRapReporting : IHttpClientRapReporting
    {
        private IConfiguration _configuration;
        private HttpClient _httpClient;
        private string _baseUri;
        private int _port;
        private IWebHostEnvironment _env;

        //private bool IsProductionEnvironment = false;
        //private bool IsStagingEnvironment = false;
        //private bool IsDevelopmentEnvironment = false;

        public HttpClientRapReporting(HttpClient httpClient, IConfiguration configuration, IWebHostEnvironment env)
        {
            _httpClient = httpClient;
            _configuration = configuration;

            if (env.IsProduction())
            {
                _baseUri = _configuration.GetValue<string>("ProductionRapReportingApiBaseUri");
                _port = configuration.GetValue<int>("ProductionRapReportingApiPort");
            }
            else if (env.IsStaging())
            {
                _baseUri = _configuration.GetValue<string>("StagingRapReportingApiBaseUri");
                _port = configuration.GetValue<int>("StagingRapReportingApiPort");
            }
            else
            {
                _baseUri = _configuration.GetValue<string>("DevelopmentRapReportingApiBaseUri");
                _port = configuration.GetValue<int>("DevelopmentRapReportingApiPort");
            }

            _httpClient.Timeout = TimeSpan.FromMinutes(25);
            _env = env;
        }

        public async Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri, string activeyear = null)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            // Timeout enhanced
            //_httpClient.Timeout = TimeSpan.FromMinutes(10);

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
            var query = HttpUtility.ParseQueryString(builder.Query);

            PropertyInfo[] properties = typeof(T).GetProperties();

            foreach (PropertyInfo property in properties)
            {
                if (property.GetValue(t, null) != null && !string.IsNullOrEmpty(property.GetValue(t, null).ToString()))
                {
                    if (property.Name.ToLower() == "top")
                    {
                        query["$" + property.Name.ToLower()] = property.GetValue(t, null).ToString();
                    }
                    else if (property.Name.ToLower() == "skip")
                    {
                        query["$" + property.Name.ToLower()] = property.GetValue(t, null).ToString();
                    }
                    else if (property.Name.ToLower() == "count")
                    {
                        query["$" + property.Name.ToLower()] = property.GetValue(t, null).ToString();
                    }
                    else if (property.Name.ToLower() == "orderby")
                    {
                        query["$" + property.Name.ToLower()] = property.GetValue(t, null).ToString();
                    }
                    else
                    {
                        query[property.Name.ToLower()] = property.GetValue(t, null).ToString();
                    }
                }
                builder.Query = query.ToString();
            }
            return builder.Uri.ToString();
        }

        public async Task<HttpResponseMessage> ExecutePostUriAsync(HCModel hcModel, string uri, object postObject, string activeyear = null)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            if (!string.IsNullOrEmpty(activeyear))
            {
                _httpClient.DefaultRequestHeaders.Add("activeYear", activeyear);
            }

            //var objAsJson = new JavaScriptSerializer().Serialize(putObject);
            var objAsJson = JsonConvert.SerializeObject(postObject);
            var content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.PostAsync(requestUri, content); //or PostAsync for POST
        }

        public async Task<HttpResponseMessage> ExecutePutStrUriAsync(HCModel hcModel, string uri, string putStr, string activeyear = null)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);
            ;
            if (!string.IsNullOrEmpty(activeyear))
            {
                _httpClient.DefaultRequestHeaders.Add("activeYear", activeyear);
            }

            var objAsJson = JsonConvert.SerializeObject(putStr);
            var content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.PutAsync(requestUri, content); //or PostAsync for POST
        }

        public async Task<HttpResponseMessage> ExecutePutUriAsync(HCModel hcModel, string uri, object postObject, string activeyear = null)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            if (!string.IsNullOrEmpty(activeyear))
            {
                _httpClient.DefaultRequestHeaders.Add("activeYear", activeyear);
            }

            //var objAsJson = new JavaScriptSerializer().Serialize(putObject);
            var objAsJson = JsonConvert.SerializeObject(postObject);
            var content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.PutAsync(requestUri, content); //or PostAsync for POST
        }

        public async Task<HttpResponseMessage> ExecuteDeleteUriAsync(HCModel hcModel, string uri, object postObject, string activeyear = null)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            if (!string.IsNullOrEmpty(activeyear))
            {
                _httpClient.DefaultRequestHeaders.Add("activeYear", activeyear);
            }

            //var objAsJson = new JavaScriptSerializer().Serialize(putObject);
            var objAsJson = JsonConvert.SerializeObject(postObject);
            var content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.DeleteAsync(requestUri); //or PostAsync for POST
        }
    }
}