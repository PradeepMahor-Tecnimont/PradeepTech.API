using Microsoft.AspNetCore.Hosting;
using System.Reflection;
using System.Web;
using TCMPLAPP.WinService.Models;

namespace TCMPLAPP.WinService.Services
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

        public HttpClientRapReporting(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _configuration = configuration;

            _baseUri = _configuration.GetValue<string>("RapReportingApiBaseUri");
            _port = configuration.GetValue<int>("RapReportingApiPort");

            _httpClient.Timeout = TimeSpan.FromMinutes(20);            
        }

        public async Task<HttpResponseMessage> ExecuteUriAsync(HCModel hcModel, string uri, string activeyear = null)
        {
            string uriToExecute = _baseUri + uri;
            var requestUri = GetUriWithparameters(hcModel, uriToExecute, _port);

            if (!string.IsNullOrEmpty(activeyear))
            {
                _httpClient.DefaultRequestHeaders.Remove("activeYear");
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
    }
}