using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IO;
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
    public class ResponseHandlerMiddleware
    {
        private const string ErrorWhileEncrypt = "!@#$ErrorWhileEncrypt!@#$";
        private const string Success_OK = "OK";
        private const string Error_KO = "KO";
        private readonly IOptions<AppSettings> appSettings;
        private readonly RequestDelegate _next;
        private readonly ILogger<ResponseHandlerMiddleware> _log;
        private readonly RecyclableMemoryStreamManager _recyclableMemoryStreamManager;

        public ResponseHandlerMiddleware(RequestDelegate next, IOptions<AppSettings> appSettings, ILogger<ResponseHandlerMiddleware> log)
        {
            this._next = next;
            this.appSettings = appSettings;
            _log = log;
            _recyclableMemoryStreamManager = new RecyclableMemoryStreamManager();
        }

        public async Task Invoke(HttpContext context)
        {
            Stream originalBody = context.Response.Body;
            var memStream = _recyclableMemoryStreamManager.GetStream();
            string result = string.Empty;
            try
            {
                context.Response.Body = memStream;

                await _next(context);

                context.Response.Body = originalBody;

                memStream.Seek(0, SeekOrigin.Begin);

                string[] UrlsToSkip4ResponseHandling = appSettings.Value.RAPAppSettings.SkipResponseHandlerUrls;
                UrlsToSkip4ResponseHandling = Array.ConvertAll<string, string>(UrlsToSkip4ResponseHandling, delegate (string s) { return s.ToLower(); });
                string currentURL = context.Request.Path.ToString();
                if (
                    !(UrlsToSkip4ResponseHandling.Contains(currentURL.ToLower())) &&
                    !(context.Response.ContentType == appSettings.Value.RAPAppSettings.ClosedXMLContentType) &&
                    !(context.Response.ContentType == appSettings.Value.RAPAppSettings.ZipContentType)
                   )
                {
                    string responseBody = new StreamReader(memStream).ReadToEnd();
                    if (context.Response.StatusCode == StatusCodes.Status404NotFound)
                    {
                        result = JToken.FromObject(new ApiResponseModel(status: Success_OK, message: "Data not found")).ToString();
                    }
                    else if (responseBody.Length > 0)
                    {
                        context.Response.ContentType = "application/json";
                        //context.Response.StatusCode = 200;

                        ApiResponseModel oResponseBody;
                        try
                        {
                            var ojbResponseBody = JToken.Parse(responseBody);
                            oResponseBody = new ApiResponseModel(status: Success_OK, objData: ojbResponseBody);
                        }
                        catch
                        {
                            oResponseBody = new ApiResponseModel(status: Success_OK, objData: responseBody);
                        }
                        result = JToken.FromObject(oResponseBody).ToString();
                        result = JsonConvert.SerializeObject(oResponseBody);
                    }
                    //if (this._AppSettings.Value.RAPAppSettings.IsEncryptionEnable)
                    //{
                    //    string[] UrlsToSkipEncryption = _AppSettings.Value.RAPAppSettings.SkipResponseEncryptUrls;
                    //    UrlsToSkipEncryption = Array.ConvertAll<string, string>(UrlsToSkipEncryption, delegate (string s) { return s.ToLower(); });

                    //    if (!(UrlsToSkipEncryption.Contains(currentURL.ToLower())))
                    //    {
                    //        string PassCode = context.Items["PASSCODE"].ToString();
                    //        string IV = context.Items["IV"].ToString();
                    //        result = this.AESEncrypt(result, PassCode, IV);
                    //    }
                    //}

                    //await context.Response.WriteAsync(result);
                    //await context.Response.Body.FlushAsync();

                    //Stream finalBody = GenerateStreamFromString(result);

                    //await finalBody.CopyToAsync(originalBody);
                    context.Response.ContentLength = Encoding.UTF8.GetByteCount(result);
                    await context.Response.WriteAsync(result);
                }
                else
                    await memStream.CopyToAsync(originalBody);

                //context.Response.Body = originalBody;
            }
            catch (System.Exception ex)
            {
                await HandleException(context, ex, originalBody);
            }
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

        private async Task HandleException(HttpContext context, System.Exception ex, Stream paramOriginalBody)
        {
            string currentURL = context.Request.Path.ToString();
            //Stream copyOfOriginalBody = paramOriginalBody;
            context.Response.Body = paramOriginalBody;

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
                RAPLog.Write(_log, context, "Exception while executing API" + System.Environment.NewLine, ex);
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
            context.Response.ContentLength = Encoding.UTF8.GetByteCount(result);
            await context.Response.WriteAsync(result);

            //string PassCode = context.Items["PASCCODE"].ToString();
            //string IV = context.Items["IV"].ToString();
            // result = AESEncrypt(result, PassCode, IV);

            //Stream finalBody = GenerateStreamFromString(result);

            //await finalBody.CopyToAsync(copyOfOriginalBody);

            //context.Response.Body = copyOfOriginalBody;
            //return;
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