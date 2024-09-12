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
    public interface IHttpClientWebApi
    {
        public Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri);

        public Task<HttpResponseMessage> ExecutePutUriAsync(HCModel hcModel, string uri, object postObject);

        public Task<HttpResponseMessage> ExecutePostUriAsync(HCModel hcModel, string uri, object postObject);

        public Task<HttpResponseMessage> ExecutePutStrUriAsync(HCModel hcModel, string uri, string postStr);

        public Task<HttpResponseMessage> ExecuteDeleteUriAsync(HCModel hcModel, string uri, object postObject);
    }

    public class HttpClientWebApi : IHttpClientWebApi
    {
        private IConfiguration _configuration;
        private HttpClient _httpClient;
        private string _baseUri;
        private int _port;
        private IWebHostEnvironment _env;

        public HttpClientWebApi(HttpClient httpClient, IConfiguration configuration, IWebHostEnvironment env)
        {
            _httpClient = httpClient;
            _configuration = configuration;

            _baseUri = _configuration.GetValue<string>("TCMPLAppWebApiBaseUri");
            _port = _configuration.GetValue<int>("TCMPLAppWebApiPort");

            _httpClient.Timeout = TimeSpan.FromMinutes(25);
            _env = env;
        }

        public async Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

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
                if (property.GetValue(t, null) != null && property.PropertyType == typeof(string))
                {
                    if (!string.IsNullOrEmpty(property.GetValue(t, null).ToString()))
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
                }
                builder.Query = query.ToString();
            }
            return builder.Uri.ToString();
        }

        public async Task<HttpResponseMessage> ExecutePostUriAsync(HCModel hcModel, string uri, object postObject)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            var objAsJson = JsonConvert.SerializeObject(postObject,
                            Newtonsoft.Json.Formatting.None,
                            new JsonSerializerSettings
                            {
                                NullValueHandling = NullValueHandling.Ignore
                            });

            HttpContent content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.PostAsync(requestUri, content); //or PostAsync for POST
        }

        public async Task<HttpResponseMessage> ExecutePostUriWithFilesAsync(HCModel hcModel, string uri)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);
            var multiForm = new MultipartFormDataContent();
            var t = hcModel.GetType();
            PropertyInfo[] properties = t.GetProperties();
            foreach (PropertyInfo pi in properties)
            {
                if (pi.GetValue(t, null) != null && pi.Name != "Files")
                {
                    multiForm.Add(new StringContent((string)pi.GetValue(t, null)), pi.Name);
                }
            }

            foreach (var file in hcModel.Files)
            {
                multiForm.Add(new StreamContent(file.OpenReadStream()), "file", file.FileName);
            }

            return await _httpClient.PostAsync(requestUri, multiForm); //or PostAsync for POST
        }

        public async Task<HttpResponseMessage> ExecutePutStrUriAsync(HCModel hcModel, string uri, string putStr)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            var objAsJson = JsonConvert.SerializeObject(putStr);
            var content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.PutAsync(requestUri, content); //or PostAsync for POST
        }

        public async Task<HttpResponseMessage> ExecutePutUriAsync(HCModel hcModel, string uri, object postObject)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            var objAsJson = JsonConvert.SerializeObject(postObject);
            var content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.PutAsync(requestUri, content); //or PostAsync for POST
        }

        public async Task<HttpResponseMessage> ExecuteDeleteUriAsync(HCModel hcModel, string uri, object postObject)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            var objAsJson = JsonConvert.SerializeObject(postObject);
            var content = new StringContent(objAsJson, Encoding.UTF8, "application/json");
            return await _httpClient.DeleteAsync(requestUri); //or PostAsync for POST
        }
    }
}