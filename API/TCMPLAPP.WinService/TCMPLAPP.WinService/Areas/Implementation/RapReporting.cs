using Newtonsoft.Json;
using System.Data;
using System.IO.Compression;
using System.Net.Http;
using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;

namespace TCMPLAPP.WinService.Areas
{
    public class RapReporting : IRapReporting
    {
        ILogger<ISWP> _logger;
        IHttpClientTCMPLAppWebApi _httpClientTCMPLAppWebApi;
        IHttpClientRapReporting _httpClientRapReporting;
        IConfiguration _configuration;
        private readonly IProcessDBLogger _processDBLogger;

        protected static string uriCostcodeGroupCostcodeList = "RapReportingProcesses/GetCostcodeGroupCostcodeList";
        protected static string uriCha1Sta6Tm02 = "api/rap/rpt/cmplx/cc/GetCha1Sta6Tm02";

        protected static string urlTM01All = "api/rap/rpt/cmplx/proco/GetTM01All";

        protected static string urlDept = "api/rap/rpt/cmplx/cc/getCha1Costcodes";
        protected static string urlCHA1 = "api/rap/rpt/cmplx/cc/GetCHA01EData";
        
        protected static string urlCHA1Common = "api/rap/rpt/cmplx/mgmt/GetCHA1Engg";
        
        protected static string urlTMACommon = "api/rap/rpt/cmplx/mgmt/GetTMA";
        
        protected static string urlProjectTCMJobsGrp = "api/rap/rpt/cmplx/proj/getProjectsTCMJobsGrp";
        protected static string uriTM11Data = "api/rap/rpt/cmplx/proj/GetTM11Data";
        
        protected static string uriSendMail = "Email/SendEmailAddToQueue";
        private static string ModuleRapReporting = "M07";
        private static string TM01AllReportName = "TM01All";        

        public RapReporting(ILogger<ISWP> logger, IHttpClientTCMPLAppWebApi httpClientTCMPLAppWebApi, IHttpClientRapReporting httpClientRapReporting, IConfiguration configuration, IProcessDBLogger processDBLogger)
        {
            _logger = logger;
            _httpClientTCMPLAppWebApi = httpClientTCMPLAppWebApi;
            _httpClientRapReporting = httpClientRapReporting;
            _configuration = configuration;
            _processDBLogger = processDBLogger;
        }

        public WSMessageModel ExecuteProcess(ProcessQueueModel currProcess)
        {
            if (currProcess.ModuleId == ModuleRapReporting)
            {
                if (currProcess.ProcessId == "CHA1E")
                    return CHA1EReport(currProcess);
                else if (currProcess.ProcessId == "CHA1STA602")
                    return Cha1Sta6Tm02Report(currProcess);
                else if (currProcess.ProcessId == "TM01DUPL")
                    return TM01DuplReport(currProcess);
                else if (currProcess.ProcessId == "CHA1ExptEngg" || currProcess.ProcessId == "CHA1ExptEnggMumbai" || currProcess.ProcessId == "CHA1ExptEnggDelhi" ||
                         currProcess.ProcessId == "CHA1ExptNonEngg" || currProcess.ProcessId == "CHA1ExptNonEnggMumbai" || currProcess.ProcessId == "CHA1ExptNonEnggDelhi" ||
                         currProcess.ProcessId == "CHA1ExptEnggNonEngg" || currProcess.ProcessId == "CHA1ExptEnggNonEnggMumbai" || currProcess.ProcessId == "CHA1ExptEnggNonEnggDelhi" ||
                         currProcess.ProcessId == "CHA1ExptEnggS" || currProcess.ProcessId == "CHA1ExptEnggMumbaiS" || currProcess.ProcessId == "CHA1ExptEnggDelhiS" ||
                         currProcess.ProcessId == "CHA1ExptNonEnggS" || currProcess.ProcessId == "CHA1ExptNonEnggMumbaiS" || currProcess.ProcessId == "CHA1ExptNonEnggDelhiS" ||
                         currProcess.ProcessId == "CHA1ExptEnggNonEnggS" || currProcess.ProcessId == "CHA1ExptEnggNonEnggMumbaiS" || currProcess.ProcessId == "CHA1ExptEnggNonEnggDelhiS" ||
                         currProcess.ProcessId == "CHA1ExptProcurement" || currProcess.ProcessId == "CHA1ExptProcurementMumbai" || currProcess.ProcessId == "CHA1ExptProcurementDelhi" ||
                         currProcess.ProcessId == "CHA1ExptProco" || currProcess.ProcessId == "CHA1ExptProcoMumbai" || currProcess.ProcessId == "CHA1ExptProcoDelhi")
                    return Cha1ExptReport(currProcess, "SINGLE");
                else if (currProcess.ProcessId == "CHA1ExptEnggC" || currProcess.ProcessId == "CHA1ExptNonEnggC" || currProcess.ProcessId == "CHA1ExptEnggNonEnggC")
                    return Cha1ExptReport(currProcess, "COMBINED");
                else if (currProcess.ProcessId == "TMAProcoDetail" || currProcess.ProcessId == "TMAProcoSummary" ||
                         currProcess.ProcessId == "TMAAFCDetail" || currProcess.ProcessId == "TMAAFCSummary" ||
                         currProcess.ProcessId == "TMAMngtDetail" || currProcess.ProcessId == "TMAMngtSummary")
                    return TMAReport(currProcess);
                else if (currProcess.ProcessId == "TCMJobsGrp")
                    return TCMJobsGrpReport(currProcess);
            }

            return new WSMessageModel { Status = "KO", Message = "RAP - Corresponding method not found" };
        }

        protected WSMessageModel Cha1Sta6Tm02Report(ProcessQueueModel currProcess)
        {
            HCModel hCModel;
            hCModel = JsonConvert.DeserializeObject<HCModel>(currProcess.ParameterJson);

            //string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppBaseRepository"), _configuration.GetValue<string>("FileDownloadPath"));
            string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppDownloadRepository"), _configuration.GetValue<string>("RAPRepository"));

            var httpResponse = Task.Run(async () => await _httpClientTCMPLAppWebApi.ExecuteUriAsync(new HCModel
            { CostcodeGroupId = hCModel.CostcodeGroupId }, uriCostcodeGroupCostcodeList)).Result;
            var retObj = HttpResponseHelper.ConvertResponseMessageToObject<IEnumerable<CostcodeData>>(httpResponse);

            if (retObj.Status == "OK")
            {                
                if (retObj.Data.Count() > 0)
                {
                    CreateFolder(currProcess.KeyId.ToString(), strFileDownloadPath);

                    foreach (var cc in retObj.Data)
                    {
                        var returnResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(new HCModel
                        {
                            Costcode = cc.Costcode,
                            Yymm = hCModel.Yyyymm,
                            YearMode = hCModel.YearMode,
                            ReportMode = "SINGLE"
                        }, uriCha1Sta6Tm02, hCModel.Yyyy)).Result;

                        if (returnResponse.IsSuccessStatusCode)
                        {                            
                            string fName = cc.Costcode.Trim().ToString() + hCModel.Yyyymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                            string strFilename = string.Format(@"{0}\{1}\{2}", strFileDownloadPath,
                                                                               currProcess.KeyId.ToString(),
                                                                               fName.ToString());
                            DownloadFile(returnResponse, strFilename);
                        }
                    }

                    MakeZip(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

                    DeleteFolder(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

                    string mailSubject = Task.Run(async () => await GetMailSubject()).Result;
                    string mailBody = Task.Run(async () => await GetMailBody()).Result;
                    string mailAttachmentsOsNm = currProcess.KeyId.ToString();
                    string mailAttachmentsBusinessNm = currProcess.KeyId.ToString();
                    Task.Run(async () => await SendMail(currProcess.MailTo, mailSubject, mailBody, mailAttachmentsOsNm, mailAttachmentsBusinessNm));
                }

                _processDBLogger.LogInformation(new HCModel { Keyid = currProcess.KeyId, LogMessage = "This is a test info message" });

                return new WSMessageModel { Status = "OK", Message = "Procedure executed successfully" };
            }
            else if (retObj.Status == "KO")
                return new WSMessageModel { Status = "KO", Message = retObj.Message };
            else
                return new WSMessageModel { Status = "KO", Message = "URI returned unknown." };
        }

        protected WSMessageModel TM01DuplReport(ProcessQueueModel currProcess)
        {
            HCModel hCModel;
            hCModel = JsonConvert.DeserializeObject<HCModel>(currProcess.ParameterJson);

            //string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppBaseRepository"), _configuration.GetValue<string>("FileDownloadPath"));
            string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppDownloadRepository"), _configuration.GetValue<string>("RAPRepository"));

            CreateFolder(currProcess.KeyId.ToString(), strFileDownloadPath);
                    
            var returnResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(new HCModel
            {                
                Yymm = hCModel.Yyyymm,
                YearMode = hCModel.YearMode,
                Simul = ""
            }, urlTM01All, hCModel.Yyyy)).Result;

            if (returnResponse.IsSuccessStatusCode)
            {
                string fName = TM01AllReportName + hCModel.Yyyymm.Trim().Substring(2, 4).ToString() + ".xlsm";
                string strFilename = string.Format(@"{0}\{1}\{2}", strFileDownloadPath,
                                                                    currProcess.KeyId.ToString(),
                                                                    fName.ToString());
                DownloadFile(returnResponse, strFilename);
            }                    

            MakeZip(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

            DeleteFolder(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

            string mailSubject = Task.Run(async () => await GetMailSubject()).Result;
            string mailBody = Task.Run(async () => await GetMailBody()).Result;
            string mailAttachmentsOsNm = currProcess.KeyId.ToString();
            string mailAttachmentsBusinessNm = currProcess.KeyId.ToString();
            Task.Run(async () => await SendMail(currProcess.MailTo, mailSubject, mailBody, mailAttachmentsOsNm, mailAttachmentsBusinessNm));                                

            return new WSMessageModel { Status = "OK", Message = "Procedure executed successfully" };                        
            
        }

        protected WSMessageModel CHA1EReport(ProcessQueueModel currProcess)
        {
            HCModel hCModel;
            hCModel = JsonConvert.DeserializeObject<HCModel>(currProcess.ParameterJson);

            //string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppBaseRepository"), _configuration.GetValue<string>("FileDownloadPath"));
            string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppDownloadRepository"), _configuration.GetValue<string>("RAPRepository"));

            DataTable dt = new DataTable();
            dt.Columns.Add("costcode");
            var httpResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(null, urlDept)).Result;

            if (httpResponse.IsSuccessStatusCode)
            {
                var fileJsonString = Task.Run(async () => await httpResponse.Content.ReadAsStringAsync()).Result;
                CostcodeModel costcode = JsonConvert.DeserializeObject<CostcodeModel>(fileJsonString);

                if (costcode.data.Count() > 0)
                {
                    CreateFolder(currProcess.KeyId.ToString(), strFileDownloadPath);

                    foreach (var cc in costcode.data)
                    {
                        var returnResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(new HCModel
                        {
                            Costcode = cc.costcode,
                            Yymm = hCModel.Yyyymm,
                            YearMode = hCModel.YearMode,
                            ReportMode = "SINGLE"
                        }, urlCHA1, hCModel.Yyyy)).Result;

                        if (returnResponse.IsSuccessStatusCode)
                        {
                            string fName = cc.costcode + "E" + hCModel.Yyyymm.Trim().Substring(2, 4).ToString() + ".xlsm";
                            string strFilename = string.Format(@"{0}\{1}\{2}", strFileDownloadPath,
                                                                               currProcess.KeyId.ToString(),
                                                                               fName.ToString());
                            DownloadFile(returnResponse, strFilename);
                        }
                    }

                    MakeZip(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

                    DeleteFolder(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

                    string mailSubject = Task.Run(async () => await GetMailSubject()).Result;
                    string mailBody = Task.Run(async () => await GetMailBody()).Result;
                    string mailAttachmentsOsNm = currProcess.KeyId.ToString();
                    string mailAttachmentsBusinessNm = currProcess.KeyId.ToString();
                    Task.Run(async () => await SendMail(currProcess.MailTo, mailSubject, mailBody, mailAttachmentsOsNm, mailAttachmentsBusinessNm));
                }

                _processDBLogger.LogInformation(new HCModel { Keyid = currProcess.KeyId, LogMessage = "This is a test info message" });

                return new WSMessageModel { Status = "OK", Message = "Procedure executed successfully" };
            }
            else
                return new WSMessageModel { Status = "KO", Message = "URI returned unknown." };

        }

        protected WSMessageModel Cha1ExptReport(ProcessQueueModel currProcess, string reportMode)
        {
            HCModel hCModel;
            hCModel = JsonConvert.DeserializeObject<HCModel>(currProcess.ParameterJson);

            //string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppBaseRepository"), _configuration.GetValue<string>("FileDownloadPath"));
            string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppDownloadRepository"), _configuration.GetValue<string>("RAPRepository"));

            CreateFolder(currProcess.KeyId.ToString(), strFileDownloadPath);

            var returnResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(new HCModel
            {
                Yymm = hCModel.Yyyymm,
                YearMode = hCModel.YearMode,
                Category = hCModel.Category,
                Simul = hCModel.Simul,
                ReportMode = reportMode
            }, urlCHA1Common, hCModel.Yyyy)).Result;

            if (returnResponse.IsSuccessStatusCode)
            {
                string fName = currProcess.ProcessId + hCModel.Yyyymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                string strFilename = string.Format(@"{0}\{1}\{2}", strFileDownloadPath,
                                                                    currProcess.KeyId.ToString(),
                                                                    fName.ToString());
                DownloadFile(returnResponse, strFilename);
            }

            MakeZip(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

            DeleteFolder(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

            string mailSubject = Task.Run(async () => await GetMailSubject()).Result;
            string mailBody = Task.Run(async () => await GetMailBody()).Result;
            string mailAttachmentsOsNm = currProcess.KeyId.ToString();
            string mailAttachmentsBusinessNm = currProcess.KeyId.ToString();
            Task.Run(async () => await SendMail(currProcess.MailTo, mailSubject, mailBody, mailAttachmentsOsNm, mailAttachmentsBusinessNm));

            return new WSMessageModel { Status = "OK", Message = "Procedure executed successfully" };

        }

        protected WSMessageModel TMAReport(ProcessQueueModel currProcess)
        {
            HCModel hCModel;
            hCModel = JsonConvert.DeserializeObject<HCModel>(currProcess.ParameterJson);

            //string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppBaseRepository"), _configuration.GetValue<string>("FileDownloadPath"));
            string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppDownloadRepository"), _configuration.GetValue<string>("RAPRepository"));

            CreateFolder(currProcess.KeyId.ToString(), strFileDownloadPath);

            var returnResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(new HCModel
            {
                Yymm = hCModel.Yyyymm,
                YearMode = hCModel.YearMode,            
                ReportType = hCModel.ReportType,
            }, urlTMACommon, hCModel.Yyyy)).Result;

            if (returnResponse.IsSuccessStatusCode)
            {
                string fName = currProcess.ProcessId + hCModel.Yyyymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                string strFilename = string.Format(@"{0}\{1}\{2}", strFileDownloadPath,
                                                                    currProcess.KeyId.ToString(),
                                                                    fName.ToString());
                DownloadFile(returnResponse, strFilename);
            }

            MakeZip(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

            DeleteFolder(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

            string mailSubject = Task.Run(async () => await GetMailSubject()).Result;
            string mailBody = Task.Run(async () => await GetMailBody()).Result;
            string mailAttachmentsOsNm = currProcess.KeyId.ToString();
            string mailAttachmentsBusinessNm = currProcess.KeyId.ToString();
            Task.Run(async () => await SendMail(currProcess.MailTo, mailSubject, mailBody, mailAttachmentsOsNm, mailAttachmentsBusinessNm));

            return new WSMessageModel { Status = "OK", Message = "Procedure executed successfully" };

        }

        protected WSMessageModel TCMJobsGrpReport(ProcessQueueModel currProcess)
        {
            HCModel hCModel;
            hCModel = JsonConvert.DeserializeObject<HCModel>(currProcess.ParameterJson);

            //string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppBaseRepository"), _configuration.GetValue<string>("FileDownloadPath"));
            string strFileDownloadPath = Path.Combine(_configuration.GetValue<string>("TCMPLAppDownloadRepository"), _configuration.GetValue<string>("RAPRepository"));

            DataTable dt = new DataTable();
            dt.Columns.Add("projno");
            var httpResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(new HCModel
                            { Yymm = hCModel.Yyyymm }, urlProjectTCMJobsGrp)).Result;
            
            if (httpResponse.IsSuccessStatusCode)
            {
                var fileJsonString = Task.Run(async () => await httpResponse.Content.ReadAsStringAsync()).Result;
                ProjectModel project = JsonConvert.DeserializeObject<ProjectModel>(fileJsonString);

                if (project.Data.value.Count() > 0)
                {
                    CreateFolder(currProcess.KeyId.ToString(), strFileDownloadPath);

                    foreach (var proj in project.Data.value)
                    {
                        var returnResponse = Task.Run(async () => await _httpClientRapReporting.ExecuteUriAsync(new HCModel
                        {
                            Projno = proj.projno,
                            Yymm = hCModel.Yyyymm,
                            YearMode = hCModel.YearMode,
                            Yyyy = hCModel.Yyyy,
                        }, uriTM11Data)).Result;

                        if (returnResponse.IsSuccessStatusCode)
                        {
                            string fName = proj.projno.Substring(0, 5).Trim().ToString() + "G" + hCModel.Yyyymm.Trim().Substring(2, 4).ToString() + ".xlsm";
                            string strFilename = string.Format(@"{0}\{1}\{2}", strFileDownloadPath,
                                                                               currProcess.KeyId.ToString(),
                                                                               fName.ToString());
                            DownloadFile(returnResponse, strFilename);
                        }
                    }

                    MakeZip(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

                    DeleteFolder(strFileDownloadPath + "\\" + currProcess.KeyId.ToString());

                    string mailSubject = Task.Run(async () => await GetMailSubject()).Result;
                    string mailBody = Task.Run(async () => await GetMailBody()).Result;
                    string mailAttachmentsOsNm = currProcess.KeyId.ToString();
                    string mailAttachmentsBusinessNm = currProcess.KeyId.ToString();
                    Task.Run(async () => await SendMail(currProcess.MailTo, mailSubject, mailBody, mailAttachmentsOsNm, mailAttachmentsBusinessNm));
                }

                _processDBLogger.LogInformation(new HCModel { Keyid = currProcess.KeyId, LogMessage = "This is a test info message" });

                return new WSMessageModel { Status = "OK", Message = "Procedure executed successfully" };
            }            
            else
                return new WSMessageModel { Status = "KO", Message = "URI returned unknown." };

        }

        public static void CreateFolder(string folderName, string strFileDownloadPath)
        {           
            if (!Directory.Exists(folderName))
            {
                Directory.CreateDirectory(strFileDownloadPath + "\\" + folderName);
            }           
        }

        public static void DownloadFile(HttpResponseMessage httpResponseMessage, string strFilename)
        {
            var result = httpResponseMessage.Content.ReadAsByteArrayAsync().Result;
            File.WriteAllBytes(strFilename, result);
        }

        public static void MakeZip(string folderName)
        {            
            if (Directory.Exists(folderName))
            {
                ZipFile.CreateFromDirectory(folderName, folderName + ".zip");
            }            
        }

        public static void DeleteFolder(string folderName)
        {            
            if (Directory.Exists(folderName))
            {
                Directory.Delete(folderName, true);
            }            
        }

        public static Task<string> GetMailSubject()
        {
            return Task.FromResult("Rap Reporting - Cha1Sta6Tm02 report");
        }

        public static Task<string> GetMailBody()
        {
            return Task.FromResult("Dear Sir/Madam, Please find the attachment. Regards,WinService");
        }

        public async Task SendMail(string mailTo, string mailSubject, string mailBody, string mailAttachmentsOsNm, string mailAttachmentsBusinessNm)
        {
            var sendMailResult = await _httpClientTCMPLAppWebApi.ExecuteUriAsync(new HCModel
            {
                MailTo = mailTo,
                MailSubject = mailSubject,
                MailBody1 = mailBody,
                MailType = "HTML",
                MailFrom = "WINSERVICE",
                MailAttachmentsOsNm = mailAttachmentsOsNm,
                MailAttachmentsBusinessNm = mailAttachmentsBusinessNm
            }, uriSendMail);
        }
    }
}
