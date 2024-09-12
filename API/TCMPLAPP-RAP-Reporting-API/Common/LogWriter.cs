using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.IO;

namespace RapReportingApi.Common
{
    public static class RAPLog
    {
        public static void Write(ILogger log, HttpContext context, string logMessage, Exception exception = null)
        {
            //string bodyText = "";

            //using (var bodyReader = new StreamReader(context.Request.Body))
            //{
            //    bodyText = bodyReader.ReadToEnd();
            //}

            //var reader = new StreamReader(context.Request.Body);
            //reader.BaseStream.Seek(0, SeekOrigin.Begin);

            string bodyText = GetBodyText(context);

            log.LogError("Error at url {URL}", context.Request.Path.ToString());
            log.LogError("---->Query Parameters-----{QUERYPARAMS}", context.Request.QueryString.ToString());
            log.LogError("---->RequestBody----------{BODY}", bodyText);
            log.LogError("---->Identity-------------{UserID}", context.User.Identity.Name);
            log.LogError(exception, logMessage);
        }

        public static void Write(ILogger log, HttpContext context, string[] logMessages)
        {
            //string bodyText = "";

            //using (var bodyReader = new StreamReader(context.Request.Body))
            //{
            //    bodyText = bodyReader.ReadToEnd();
            //}

            string bodyText = GetBodyText(context);

            log.LogError("Error at url {URL}", context.Request.Path.ToString());
            log.LogError("---->Query Parameters-----{QUERYPARAMS}", context.Request.QueryString.ToString());
            log.LogError("---->RequestBody----------{BODY}", bodyText);
            log.LogError("---->Identity-------------{UserID}", context.User.Identity.Name);
            foreach (string logMessage in logMessages)
            {
                log.LogError("---->Message-------------{MSG}", logMessage);
            }
        }

        public enum LogType
        { Warning, Error, Critical };

        private static string GetBodyText(HttpContext context)
        {
            var rawMessage = "";
            if (context.Request.Body.CanSeek)
            {
                var reader = new StreamReader(context.Request.Body);
                reader.BaseStream.Seek(0, SeekOrigin.Begin);
                rawMessage = reader.ReadToEnd();
            }
            return rawMessage;
        }
    }
}