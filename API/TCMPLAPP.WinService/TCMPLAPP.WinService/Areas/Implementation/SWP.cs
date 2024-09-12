using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;

namespace TCMPLAPP.WinService.Areas
{
    public class SWP : ISWP
    {
        ILogger<ISWP> _logger;
        IHttpClientTCMPLAppWebApi _httpClientTCMPLAppWebApi;
        private readonly IProcessDBLogger _processDBLogger;

        protected static string uriPROCO01 = "SWPProcesses/AttendanceStatusForPrevWorkDate";
        protected static string uriSendMail = "Email/SendEmailAddToQueue";
        public SWP(ILogger<ISWP> logger, IHttpClientTCMPLAppWebApi httpClientTCMPLAppWebApi, IProcessDBLogger processDBLogger)
        {
            _logger = logger;
            _httpClientTCMPLAppWebApi = httpClientTCMPLAppWebApi;
            _processDBLogger = processDBLogger;
        }

        public WSMessageModel ExecuteProcess(ProcessQueueModel currProcess)
        {
            if (currProcess.ProcessId == "PROC01")
            {
                return AttendanceStatusReport(currProcess);
            }

            return new WSMessageModel { Status = "KO", Message = "SWP - Corresponding method not found" };
        }

        protected WSMessageModel AttendanceStatusReport(ProcessQueueModel currProcess)
        {

            var httpResponse = Task.Run(async () => await _httpClientTCMPLAppWebApi.ExecuteUriAsync(null, uriPROCO01)).Result;

            var retObj = HttpResponseHelper.ConvertResponseMessageToObject<byte[]>(httpResponse);

            if (retObj.Status == "OK")
            {
                File.WriteAllBytes("d:\\mytemp\\text.xlsx", retObj.Data);

                var sendMailResult = Task.Run(async () => await _httpClientTCMPLAppWebApi.ExecuteUriAsync(new HCModel
                {
                    MailTo = currProcess.MailTo,
                    MailSubject = "Mail from Winservice",
                    MailBody1 = "This is a test message",
                    MailType = "HTML",
                    MailFrom = "WINSERVICE",
                    MailAttachmentsOsNm = "text.xlsx",
                    MailAttachmentsBusinessNm = "text.xlsx"
                }, uriSendMail)).Result;

                _processDBLogger.LogInformation(new HCModel { Keyid = currProcess.KeyId, LogMessage = "This is a test info message" });


                return new WSMessageModel { Status = "OK", Message = "Procedure execute successfully" };
            }
            else if (retObj.Status == "KO")
                return new WSMessageModel { Status = "KO", Message = retObj.Message };
            else
                return new WSMessageModel { Status = "KO", Message = "URI returned unknown." };

        }
    }
}
