using Newtonsoft.Json;
using System.Data;
using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;
using System.IO.Compression;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;
using System.Text.RegularExpressions;

namespace TCMPLAPP.WinService.Areas
{
    public class EmpGenInfo : IEmpGenInfo
    {
        private readonly ILogger<IEmpGenInfo> _logger;
        private readonly IHttpClientTCMPLAppWebApi _httpClientTCMPLAppWebApi;
        private readonly IConfiguration _configuration;
        private readonly IProcessDBLogger _processDBLogger;
         
        protected static string uriSendMail = "Email/SendEmailAddToQueue";
        protected static string uriEmpList = "EmpGenInfoDetails/SetLoaDeemedAcceptance";
        private static readonly string moduleEmpGenInfo = "M11";

        public EmpGenInfo(ILogger<IEmpGenInfo> logger,
                          IHttpClientTCMPLAppWebApi httpClientTCMPLAppWebApi,
                          IConfiguration configuration,
                          IProcessDBLogger processDBLogger)
        {
            _logger = logger;
            _httpClientTCMPLAppWebApi = httpClientTCMPLAppWebApi;
            _configuration = configuration;
            _processDBLogger = processDBLogger;
        }

        public WSMessageModel ExecuteProcess(ProcessQueueModel processQueueModel)
        {
            if (processQueueModel.ModuleId == moduleEmpGenInfo)
            {
                if (processQueueModel.ProcessId == "SendDeemedAcceptanceMail")
                {
                    return SendDeemedAcceptanceMail(processQueueModel);
                }
            }

            return new WSMessageModel { Status = "KO", Message = "EmpGenInfo - Method not found" };
        }

        protected WSMessageModel SendDeemedAcceptanceMail(ProcessQueueModel currProcess)
        {

            HCModel hCModel = new HCModel();
            //hCModel.Empno = employeeDetails.PForEmpno;
            //hCModel.Htmlcontent = htmlString;
            //hCModel.MailTo = employeeDetails.PEmail + ";hr_tcmpl@tecnimont.in;";
            //hCModel.MailSubject = emailSubject;
            //hCModel.MailBody1 = emailText;
            //hCModel.MailType = "HTML";

            var httpResponse = Task.Run(async () => await _httpClientTCMPLAppWebApi.ExecuteUriAsync(null, uriEmpList)).Result;
            //   var retObj = HttpResponseHelper.ConvertResponseMessageToObject<IEnumerable<CostcodeData>>(httpResponse);

            DataTable dt = new DataTable();
            dt.Columns.Add("empno");

            if (httpResponse.IsSuccessStatusCode)
            {
                var fileJsonString = Task.Run(async () => await httpResponse.Content.ReadAsStringAsync()).Result;
                var retObj = HttpResponseHelper.ConvertResponseMessageToObject<IEnumerable<LoaDeemedAcceptanceData>>(httpResponse);

                if (retObj.Status == "OK")
                {
                    if (retObj.Data.Count() > 0)
                    {
 
                        foreach (var itm in retObj.Data)
                        {
                            //item["EmployeeNo"] = Convert.ToString(itm.EmployeeNo);

                        }
                    }
                } 
                            
            }

            string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppDownloadRepository"), _configuration.GetValue<string>("EmpGenInfo"));

            return new WSMessageModel { Status = "KO", Message = "Returned unknown." };
        }

        public async Task<bool> LoaAddendumSendAcceptanceMail(LoaDeemedAcceptanceData loaDeemedAcceptanceData)
        {
            //try
            {
                
                if (loaDeemedAcceptanceData == null)
                {
                    return false;
                }

                string htmlString = string.Empty;
                string emailText = string.Empty;
                string emailSubject = string.Empty;

                string _uriGeneratePdfSendMail = "EmpGenInfoDetails/LoaAddendumGeneratePDFSendMail";
                string fileName = "LoaAddendumAcceptancePrint.txt";
                string emailFileName = "LoaAddendumAcceptanceEmail.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: fileName, _configuration);

                string emailFilePath = StorageHelper.GetTemplateFilePath(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: emailFileName, _configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                using (StreamReader r = new StreamReader(emailFilePath))
                {
                    emailText = r.ReadToEnd();
                }

                string regexMatchStr = "<subject>(.*?)</subject>";

                Regex regex = new Regex(regexMatchStr);
                var v = regex.Match(emailText);
                emailSubject = v.Groups[1].ToString();

                regexMatchStr = regexMatchStr.Replace("(.*?)", emailSubject);
                emailText = emailText.Replace(regexMatchStr, "");

                if (! string.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    htmlString = htmlString.Replace("PDate", currDate.ToString("dd-MMM-yyyy"));
                    htmlString = htmlString.Replace("PEmpNo", loaDeemedAcceptanceData.EmployeeNo);
                    htmlString = htmlString.Replace("PNameOfEmp", loaDeemedAcceptanceData.EmployeeName);

                    emailText = emailText.Replace("PDate", currDate.ToString("dd-MMM-yyyy"));
                    emailText = emailText.Replace("PNameOfEmp", loaDeemedAcceptanceData.EmployeeName);

                    if (loaDeemedAcceptanceData.StatusCode == 1)
                        htmlString = htmlString.Replace("PAcceptanceStatus", "Already registered your consent on " + loaDeemedAcceptanceData.AcceptanceDate);
                    else if (loaDeemedAcceptanceData.StatusCode == 2)
                        htmlString = htmlString.Replace("PAcceptanceStatus", "Deemed Confirmation on " + loaDeemedAcceptanceData.AcceptanceDate);
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString += filePath + "-Template not found, contact system administrator !!!";
                }

                HCModel hCModel = new HCModel();
                hCModel.Empno = loaDeemedAcceptanceData.EmployeeNo;
                hCModel.Htmlcontent = htmlString;
                hCModel.MailTo = loaDeemedAcceptanceData.Email + ";hr_tcmpl@tecnimont.in;";
                hCModel.MailSubject = emailSubject;
                hCModel.MailBody1 = emailText;
                hCModel.MailType = "HTML";

                var returnResponse = await _httpClientTCMPLAppWebApi.PostUriAsync(hCModel, _uriGeneratePdfSendMail);
                return returnResponse.IsSuccessStatusCode;

                //if (returnResponse.IsSuccessStatusCode)
                //    return Ok();
                //else
                //    return StatusCode((int)HttpStatusCode.InternalServerError, "Error executing sending mail");
            }
            //catch (Exception ex)
            //{
            //    throw new CustomJsonException(ex.Message, ex);
            //}
        }

    }
}