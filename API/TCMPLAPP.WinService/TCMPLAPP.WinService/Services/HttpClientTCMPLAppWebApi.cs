//using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using TCMPLAPP.WinService.Models;

namespace TCMPLAPP.WinService.Services
{
    public interface IHttpClientTCMPLAppWebApi
    {
        public Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri);

        public Task<HttpResponseMessage> PostUriAsync(HCModel hcModel, string uri);

        public Task<HttpResponseMessage> PostFileUriAsync(HCModel hcModel, System.IO.FileInfo files, string uri);

    }

    public class HttpClientTCMPLAppWebApi : IHttpClientTCMPLAppWebApi
    {
        private readonly IConfiguration _configuration;
        private readonly HttpClient _httpClient;
        private readonly string _baseUri;
        private readonly int _port;

        public HttpClientTCMPLAppWebApi(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _configuration = configuration;
            _httpClient.Timeout = TimeSpan.FromMinutes(5);
            _baseUri = "";

            _baseUri = _configuration.GetValue<string>("TCMPLAppAPIBaseUri");
            _port = configuration.GetValue<int>("TCMPLAppAPIPort");

        }

        public class JsonToPost
        {
            public string KeyId { get; set; }
            public string LogMessage { get; set; }
        }

        public async Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            return await _httpClient.GetAsync(requestUri);
        }

        public async Task<HttpResponseMessage> PostUriAsync(HCModel hcModel, string uri)
        {
            string uriToExecute = _baseUri + uri;

            var jsondata = new JsonToPost() { KeyId = hcModel.Keyid, LogMessage = hcModel.LogMessage };

            var postUri = (new UriBuilder(uriToExecute) { Port = _port }).Uri.ToString();

            return await _httpClient.PostAsJsonAsync(postUri, jsondata);
        }

        public async Task<HttpResponseMessage> PostFileUriAsync(HCModel hcModel, FileInfo file, string uri)
        {
            string uriToExecute = _baseUri + uri;

            var jsonToPost = JsonConvert.SerializeObject(hcModel, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore });


            var postUri = (new UriBuilder(uriToExecute) { Port = _port }).Uri.ToString();

            byte[] fileContents = File.ReadAllBytes(file.FullName);
            MultipartFormDataContent content = new MultipartFormDataContent();
            ByteArrayContent byteContent = new ByteArrayContent(fileContents);
            //byteContent.Headers.Add("Content-Type", "application/octet-stream");
            content.Add(byteContent, "file", file.Name);

            return await _httpClient.PostAsync(postUri, content);
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