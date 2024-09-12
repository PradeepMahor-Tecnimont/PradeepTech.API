using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RapReportingApi.Common;
using RapReportingApi.Models;
using RapReportingApi.Models.Middelware;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TIMESHEEET_API.Middleware
{
    public class RequestDecryptMiddleWare
    {
        private readonly string ErrorWhileDecrypt;
        private readonly RequestDelegate _next;
        private AESEssentials _oAESEssentials;
        private IOptions<AppSettings> appSettings;
        private readonly ILogger<RequestDecryptMiddleWare> _log;

        public RequestDecryptMiddleWare(RequestDelegate next, IOptions<AppSettings> _settings, ILogger<RequestDecryptMiddleWare> log)
        {
            ErrorWhileDecrypt = "$#@!ErrorWhileDecrypting$#@!";
            _next = next;
            appSettings = _settings;
            _oAESEssentials = new AESEssentials();
            _log = log;
        }

        public async Task Invoke(HttpContext context)
        {
            string[] UrlsToSkipDecrypt = appSettings.Value.RAPAppSettings.SkipDecryptParamsUrls;
            UrlsToSkipDecrypt = Array.ConvertAll<string, string>(UrlsToSkipDecrypt, delegate (string s) { return s.ToLower(); });

            string currentURL = context.Request.Path.ToString().ToLower();
            var request = context.Request;
            request.EnableBuffering();
            //var stream1 = request.Body;// currently holds the original stream
            //var originalBodyContent1 = new StreamReader(stream1).ReadToEnd();
            //request.Body.Seek(0, SeekOrigin.Begin);
            if (UrlsToSkipDecrypt.Contains(currentURL, StringComparer.OrdinalIgnoreCase))
            {
                await _next.Invoke(context);
            }
            else
            {
                string jsonPassCode = this.RSADecrypt(request);
                if (jsonPassCode == this.ErrorWhileDecrypt)
                {
                    RAPLog.Write(_log, context, "Request has been forbidden - PassCode DeCrypt Issue.");
                    context.Response.StatusCode = (int)System.Net.HttpStatusCode.Forbidden;
                    return;
                }
                var myJObject = JObject.Parse(jsonPassCode);
                var passCode = myJObject.SelectToken("key").Value<string>();
                var iv = myJObject.SelectToken("iv").Value<string>();

                StringValues queryParams = "";
                string strQueryParams = "";
                var qryStr = request.Query;

                if (qryStr.ContainsKey("q"))
                {
                    qryStr.TryGetValue("q", out queryParams);

                    //base64Decoded = RSAHelper.DecryptStringFromBytesUsingRijndaelManaged(data, Encoding.UTF8.GetBytes(passCode), Encoding.UTF8.GetBytes(iv));
                    //base64Decoded = RSAHelper.DecryptStringAES(passCode, iv, data);

                    //byte[] queryParamsBytes = Convert.FromBase64String(System.Net.WebUtility.UrlDecode(queryParams));
                    //strQueryParams = RSAHelper.DecryptStringUsingAESManaged(queryParamsBytes, Encoding.UTF8.GetBytes(passCode), Encoding.UTF8.GetBytes(iv));

                    strQueryParams = this.AESDecrypt(System.Net.WebUtility.UrlDecode(queryParams), passCode, iv);
                    if (strQueryParams == this.ErrorWhileDecrypt)
                    {
                        RAPLog.Write(_log, context, "Request has been forbidden - QueryParams DeCrypt Issue.");
                        context.Response.StatusCode = (int)System.Net.HttpStatusCode.Forbidden;
                        return;
                    }
                    context.Request.Query = null;
                    var values = JsonConvert.DeserializeObject<Dictionary<string, string>>(strQueryParams);
                    for (int i = 0; i < values.Count; i++)
                    {
                        var item = values.ElementAt(i);

                        request.QueryString = request.QueryString.Add(item.Key, item.Value);
                    }
                }

                this.SetUserIdentityHeader(context, passCode, iv);

                //get the request body and put it back for the downstream items to read
                var stream = request.Body;// currently holds the original stream
                var originalBodyContent = new StreamReader(stream).ReadToEnd();

                //request.Body = null;
                //put original data back for the downstream to read
                //var bodyBytes = Encoding.UTF8.GetBytes(originalBodyContent);
                if (originalBodyContent.Length > 0)
                {
                    //var bodyBytes = Convert.FromBase64String(originalBodyContent);
                    //var strBody = RSAHelper.DecryptStringUsingAESManaged(bodyBytes, Encoding.UTF8.GetBytes(passCode), Encoding.UTF8.GetBytes(iv));

                    var strBody = this.AESDecrypt(originalBodyContent, passCode, iv);

                    if (strBody == this.ErrorWhileDecrypt)
                    {
                        RAPLog.Write(_log, context, "Request has been forbidden - Body DeCrypt Issue.");
                        context.Response.StatusCode = (int)System.Net.HttpStatusCode.Forbidden;
                        return;
                    }

                    var ms = new MemoryStream(Encoding.UTF8.GetBytes(strBody));
                    ms.Position = 0;
                    request.Body = ms;
                }
                context.Items.Add("PASSCODE", passCode);
                context.Items.Add("IV", iv);
                await _next.Invoke(context);
            }
        }

        private string AESDecrypt(string paramString2Decrypt, string paramPassCode, string paramPassCodeIV)
        {
            try
            {
                var dataInBytes = Convert.FromBase64String(paramString2Decrypt);
                var DecryptedData = RSAHelper.DecryptBase64StringUsingAESManaged(dataInBytes, Encoding.UTF8.GetBytes(paramPassCode), Encoding.UTF8.GetBytes(paramPassCodeIV));
                return DecryptedData;
            }
            catch
            {
                return this.ErrorWhileDecrypt;
            }
        }

        private void SetUserIdentityHeader(HttpContext context, string paramPassCode, string paramPassCodeIV)
        {
            var request_headers = context.Request.Headers;
            //context.Request.Headers.Add("x-UserIdentityName", context.User.Identity.Name);
            if (request_headers.ContainsKey("x-em"))
            {
                StringValues headerValue = request_headers["x-em"].ToString();
                var value = this.AESDecrypt(headerValue, paramPassCode, paramPassCodeIV);
                if (value == this.ErrorWhileDecrypt)
                {
                    context.Response.StatusCode = (int)System.Net.HttpStatusCode.Forbidden;
                    return;
                }
            }
        }

        private string RSADecrypt(HttpRequest oRequest)
        {
            try
            {
                String PrivateKeyFile = CustomFunctions.GetRAPRepository(appSettings.Value) + "\\Production_RSAPrivateKey";
                var request_headers = oRequest.Headers;
                StringValues headerValue = request_headers["enchrd"].ToString();
                if (StringValues.IsNullOrEmpty(headerValue))
                {
                    oRequest.Query.TryGetValue("enchrd", out headerValue);
                }
                byte[] decryptPassCode = RSAHelper.RSADecryptString(headerValue, PrivateKeyFile);

                string jsonPassCode = System.Text.Encoding.UTF8.GetString(decryptPassCode);
                return jsonPassCode;
            }
            catch
            {
                return this.ErrorWhileDecrypt;
            }
        }

        private void WriteLog(HttpContext context, string logMessage, LogLevel logLevel, Exception ex = null)
        {
            //_log.LogError()
            //_log.BeginScope()
        }

        private enum LogLevel
        { Warning, Error, Fatal };
    }
}