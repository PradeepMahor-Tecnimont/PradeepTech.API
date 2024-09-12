using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RapReportingApi.Common;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Models.Middelware;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RapReportingApi.Middleware
{
    public class ExceptionHandlingMiddleWare
    {
        private const string ErrorWhileEncrypt = "!@#$ErrorWhileEncrypt!@#$";
        private const string Success_OK = "OK";
        private const string Error_KO = "KO";
        private readonly IOptions<AppSettings> appSettings;
        private readonly RequestDelegate _next;
        private readonly ILogger<ExceptionHandlingMiddleWare> _log;

        public ExceptionHandlingMiddleWare(RequestDelegate next, IOptions<AppSettings> appSettings, ILogger<ExceptionHandlingMiddleWare> log)
        {
            this._next = next;
            this.appSettings = appSettings;
            _log = log;
        }

        public async Task Invoke(HttpContext context)
        {
            Stream originalBody = context.Response.Body;
            var memStream = new MemoryStream();
            try
            {
                context.Response.Body = memStream;

                await _next(context);

                //await memStream.CopyToAsync(originalBody);
                memStream.Position = 0;

                string[] UrlsToSkip4ResponseHandling = appSettings.Value.RAPAppSettings.SkipResponseHandlerUrls;
                UrlsToSkip4ResponseHandling = Array.ConvertAll<string, string>(UrlsToSkip4ResponseHandling, delegate (string s) { return s.ToLower(); });
                string currentURL = context.Request.Path.ToString();
                if (!(UrlsToSkip4ResponseHandling.Contains(currentURL.ToLower())))
                {
                    string responseBody = new StreamReader(memStream).ReadToEnd();

                    if (responseBody.Length > 0)
                    {
                        context.Response.ContentType = "application/json";
                        context.Response.StatusCode = 200;
                        var ojbResponseBody = JToken.Parse(responseBody);
                        ApiResponseModel oResponseBody = new ApiResponseModel(status: Success_OK, objData: ojbResponseBody);
                        var result = JToken.FromObject(oResponseBody).ToString();
                        result = JsonConvert.SerializeObject(oResponseBody);

                        if (this.appSettings.Value.RAPAppSettings.IsEncryptionEnable)
                        {
                            string[] UrlsToSkipEncryption = appSettings.Value.RAPAppSettings.SkipResponseEncryptUrls;
                            UrlsToSkipEncryption = Array.ConvertAll<string, string>(UrlsToSkipEncryption, delegate (string s) { return s.ToLower(); });

                            if (!(UrlsToSkipEncryption.Contains(currentURL.ToLower())))
                            {
                                string PassCode = context.Items["PASSCODE"].ToString();
                                string IV = context.Items["IV"].ToString();
                                result = this.AESEncrypt(result, PassCode, IV);
                            }
                        }

                        Stream finalBody = GenerateStreamFromString(result);
                        await finalBody.CopyToAsync(originalBody);
                    }
                }
                else
                    await memStream.CopyToAsync(originalBody);

                context.Response.Body = originalBody;
            }
            catch (System.Exception ex)
            {
                HandleException(context, ex, originalBody);
            }
        }

        private void HandleException(HttpContext context, System.Exception ex, Stream originalBody)
        {
            string currentURL = context.Request.Path.ToString();

            HttpStatusCode code = HttpStatusCode.OK; // 200
            string result = "";
            if (ex is RAPCustomException)
            {
                RAPCustomException appEx = (RAPCustomException)ex;
                result = JsonConvert.SerializeObject(new ApiResponseModel(status: Error_KO, message: appEx.Message, messageCode: appEx.RAPErrorCode));
                if (ex is RAPDBException)
                    RAPLog.Write(_log, context, appEx.Message);
            }
            else
            {
                result = JsonConvert.SerializeObject(new ApiResponseModel(status: Error_KO, message: ex.Message, messageCode: "UNKNOWN_ERROR"));
                //using (_log.BeginScope("ErrorAtUrl", currentURL))
                //{
                //    _log.LogError("Exception at url {URL}", currentURL);
                //    _log.LogError(ex, "Exception execution request.");
                //}
                //_log()
                //_log.LogCritical(ex, "Exception while executing api - {url}.", currentURL);
                RAPLog.Write(_log, context, "Exception while executing API", ex);
            }
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)code;

            if (appSettings.Value.RAPAppSettings.IsEncryptionEnable)
            {
                string[] UrlsToSkipEncryption = appSettings.Value.RAPAppSettings.SkipResponseEncryptUrls;
                UrlsToSkipEncryption = Array.ConvertAll<string, string>(UrlsToSkipEncryption, delegate (string s) { return s.ToLower(); });

                string PassCode;
                string IV;
                if (!(UrlsToSkipEncryption.Contains(currentURL.ToLower())))
                {
                    PassCode = context.Items["PASSCODE"].ToString();
                    IV = context.Items["IV"].ToString();
                    result = this.AESEncrypt(result, PassCode, IV);
                }
            }

            //string PassCode = context.Items["PASCCODE"].ToString();
            //string IV = context.Items["IV"].ToString();
            // result = AESEncrypt(result, PassCode, IV);

            Stream finalBody = GenerateStreamFromString(result);
            finalBody.CopyTo(originalBody);
            //return context.Response.WriteAsync(result);
            context.Response.Body = originalBody;
            return;
        }

        private static Stream GenerateStreamFromString(string s)
        {
            var stream = new MemoryStream();
            var writer = new StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }

        private string AESEncrypt(string paramString2Encrypt, string paramPassCode, string paramPassCodeIV)
        {
            try
            {
                //var dataInBytes = Convert.FromBase64String(paramString2Encrypt);
                //var dataInBytes = Encoding.UTF8.GetBytes(paramString2Encrypt);
                var EncryptedData = RSAHelper.EncryptString_Aes(paramString2Encrypt, Encoding.UTF8.GetBytes(paramPassCode), Encoding.UTF8.GetBytes(paramPassCodeIV));
                return EncryptedData;
            }
            catch
            {
                return ErrorWhileEncrypt;
            }
        }
    }
}