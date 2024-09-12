using Newtonsoft.Json;
using System.Data;
using System.IO.Compression;
using System.Net.Http.Headers;
using System.Text;
using TCMPLApp.RAPReporting.WinService.Services;

namespace TCMPLApp.RAPReporting.WinService
{
    public static class RAPLib
    {          

        public static async Task<Yearobject> GetYears(ILogger logger, AppSettings appSettings, IServiceProvider serviceProvider)
        {
            string urlYear = appSettings.WinServiceAppSettings.urlYear;
            IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
            var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(null , urlYear);

            if (returnResponse.IsSuccessStatusCode)
            {
                var fileJsonString = await returnResponse.Content.ReadAsStringAsync();
                Yearobject yr = JsonConvert.DeserializeObject<Yearobject>(fileJsonString);
                return yr;
            }
            else
            {
                return null;
            }                          
        }               

        public static async Task bulkDownload(string keyid, string user, string yyyy, string yymm, string yearmode, string reportid, string reportMode, AppSettings appSettings, ILogger logger, IServiceProvider serviceProvider )
        {

            logger.LogInformation($"{DateTime.Now}: Parameters - " + keyid + "-" + user + "-" + yyyy + "-" + yearmode + "-" + reportid);

            try
            {
                string urlDept = appSettings.WinServiceAppSettings.urlDept;
                string strFilePath = appSettings.WinServiceAppSettings.FilePath;
                
                DataTable dt = new DataTable();
                dt.Columns.Add("costcode");

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(null, urlDept);
               
                if (returnResponse.IsSuccessStatusCode)
                {
                    var fileJsonString = await returnResponse.Content.ReadAsStringAsync();
                    Costcodeobject dept = JsonConvert.DeserializeObject<Costcodeobject>(fileJsonString);
                    if (!Directory.Exists(keyid.ToString()))
                    {
                        Directory.CreateDirectory(strFilePath + "\\" + keyid.ToString());
                    }
                    foreach (var cc in dept.data)
                    {
                        dt.Rows.Add(cc.costcode.ToString());
                    }
                }                    
                
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow rr in dt.Rows)
                    {
                        try
                        {
                            await cha1_dept_download(keyid.ToString(),
                                                     rr["costcode"].ToString(),
                                                     yyyy,
                                                     yymm.ToString(),
                                                     yearmode.ToString(), 
                                                     reportMode, 
                                                     appSettings, 
                                                     logger,serviceProvider);
                        }
                        catch (Exception ex)
                        {
                            string xx = ex.Message.ToString();
                        }
                    }
                    // Update Process complete flag
                    await RAPLib.insertRptProcess(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString(), null, null, null, reportid.ToString(), "G", appSettings, logger,serviceProvider);
                    // Make a zip file
                    await makeZip(strFilePath + "\\" + keyid.ToString());
                    // Delete Folder
                    await deleteFolder(strFilePath + "\\" + keyid.ToString());
                    // Send mail
                    await getRptMailDetails(keyid.ToString(), "SUCCESS", appSettings,logger, serviceProvider);
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'buldDownload'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), appSettings, logger, serviceProvider);
            }
        }

        public static async Task makeZip(string foldername)
        {
            await Task.Run(() =>
            {
                if (Directory.Exists(foldername))
                {
                    ZipFile.CreateFromDirectory(foldername, foldername + ".zip");
                }
            });
        }

        public static async Task deleteFolder(string foldername)
        {
            await Task.Run(() =>
            {
                if (Directory.Exists(foldername))
                {
                    Directory.Delete(foldername, true);
                }
            });
        }

        public static async Task cha1_dept_download(string keyid, string costcode, string yyyy, string yymm, string yearmode, string reportMode, AppSettings _appSettings, ILogger logger, IServiceProvider serviceProvider )
        {            
            string urlCHA1 = _appSettings.WinServiceAppSettings.urlCHA1;
            string strFilePath = _appSettings.WinServiceAppSettings.FilePath;
            try
            {                            
                string url = String.Format(urlCHA1, costcode, yymm, yearmode);
                logger.LogDebug("Url --> " + url);

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Costcode = costcode, Yymm = yymm, YearMode = yearmode, ReportMode = reportMode}, urlCHA1, yyyy);

                if (returnResponse.IsSuccessStatusCode)
                {
                    string fName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                            
                    string strFilename = string.Format(@"{0}\{1}\{2}", strFilePath,
                                                                        keyid.ToString(),
                                                                        fName.ToString());

                    byte[] m_Bytes = null;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        await returnResponse.Content.CopyToAsync(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    File.WriteAllBytes(strFilename, m_Bytes);
                }                   
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'cha1_dept_download'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), _appSettings, logger, serviceProvider);
            }
        }

        public static async Task bulkCha1Sta6Tm02Download(string keyid, string user, string yyyy, string yymm, string yearmode, string reportid, AppSettings appSettings, ILogger logger, IServiceProvider serviceProvider )
        {
            logger.LogInformation($"{DateTime.Now}: Parameters - " + keyid + "-" + user + "-" + yyyy + "-" + yearmode + "-" + reportid);
                        
            string urlCha1Sta6Tm02Dept = appSettings.WinServiceAppSettings.urlCha1Sta6Tm02Dept;
            string strFilePath = appSettings.WinServiceAppSettings.FilePath;

            try
            {                
                DataTable dt = new DataTable();
                dt.Columns.Add("costcode");

                

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));

                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(null, urlCha1Sta6Tm02Dept);

                if (returnResponse.IsSuccessStatusCode)
                {
                    var fileJsonString = await returnResponse.Content.ReadAsStringAsync();
                    Costcodeobject dept = JsonConvert.DeserializeObject<Costcodeobject>(fileJsonString);
                    if (!Directory.Exists(keyid.ToString()))
                    {
                        Directory.CreateDirectory(strFilePath + "\\" + keyid.ToString());
                    }
                    foreach (var cc in dept.data)
                    {
                        dt.Rows.Add(cc.costcode.ToString());
                    }
                }                    
                
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow rr in dt.Rows)
                    {
                        try
                        {
                            await cha1sta6tm02_dept_download(keyid.ToString(),
                                                             rr["costcode"].ToString(),
                                                             yyyy,
                                                             yymm.ToString(),
                                                             yearmode.ToString(), appSettings, logger,serviceProvider);
                        }
                        catch (Exception ex)
                        {
                            string xx = ex.Message.ToString();
                        }
                    }
                    // Update Process complete flag
                    await RAPLib.insertRptProcess(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString(), null, null, null, reportid.ToString(), "G", appSettings, logger, serviceProvider);
                    // Make a zip file
                    await makeZip(strFilePath + "\\" + keyid.ToString());
                    // Delete Folder
                    await deleteFolder(strFilePath + "\\" + keyid.ToString());
                    // Send mail
                    await getRptMailDetails(keyid.ToString(), "SUCCESS", appSettings, logger, serviceProvider);
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'bulkCha1Sta6Tm02Download'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), appSettings, logger, serviceProvider);
                //System.Environment.Exit(0);
            }
        }

        public static async Task cha1sta6tm02_dept_download(string keyid, string costcode, string yyyy, string yymm, string yearmode, AppSettings _appSettings, ILogger logger,
            IServiceProvider serviceProvider
            )
        {            
            string urlCha1Sta6Tm02 = _appSettings.WinServiceAppSettings.urlCha1Sta6Tm02;
            string strFilePath = _appSettings.WinServiceAppSettings.FilePath;

            try
            {                                 
                string url = String.Format(urlCha1Sta6Tm02, costcode, yymm, yearmode);
                logger.LogDebug("Url --> " + url);

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));


                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Costcode = costcode, Yymm = yymm, YearMode = yearmode }, urlCha1Sta6Tm02, yyyy);

                if (returnResponse.IsSuccessStatusCode)
                {
                    string fName = costcode.Trim().ToString() + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                    string strFilename = string.Format(@"{0}\{1}\{2}", strFilePath,
                                                                        keyid.ToString(),
                                                                        fName.ToString());

                    byte[] m_Bytes = null;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        await returnResponse.Content.CopyToAsync(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    File.WriteAllBytes(strFilename, m_Bytes);
                }                                   
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'cha1sta6tm02_dept_download'");

                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), _appSettings, logger, serviceProvider);
            }
        }

        public static async Task insertRptProcess(string keyid, string user, string yyyy, string yymm, string yearmode, string category, string reporttype, string simul, string reportid, string runmode, AppSettings _appSettings, ILogger logger, IServiceProvider serviceProvider )
        {            
            string urlInsertRptProcess = _appSettings.WinServiceAppSettings.urlInsertRptProcess;
            try
            {
                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Keyid = keyid, User = user, Yyyy = yyyy, Yymm = yymm, YearMode = yearmode, Category = category, ReportType = reporttype, Simul = simul, Reportid = reportid, Runmode = runmode }, urlInsertRptProcess);
                                               
                if (returnResponse.IsSuccessStatusCode)
                {
                    var fileJsonString = await returnResponse.Content.ReadAsStringAsync();
                }                   
                
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'insertRptProcess'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), _appSettings, logger, serviceProvider);
            }
        }

        public static async Task getRptMailDetails(string keyid, string status, AppSettings _appSettings, ILogger logger, IServiceProvider serviceProvider)
        {
            
            try
            {
                string urlMailDetails = _appSettings.WinServiceAppSettings.urlMailDetails;
                bool retVal = true;

                if (retVal)
                    return;
                else
                    urlMailDetails = _appSettings.WinServiceAppSettings.urlMailDetails;

                DataTable dtSendMail = new DataTable();

                dtSendMail.Columns.Add("mailTo", typeof(string));
                dtSendMail.Columns.Add("mailCC", typeof(string));
                dtSendMail.Columns.Add("mailBCC", typeof(string));
                dtSendMail.Columns.Add("mailSubject", typeof(string));
                dtSendMail.Columns.Add("mailBody", typeof(string));
                dtSendMail.Columns.Add("mailType", typeof(string));
                dtSendMail.Columns.Add("mailFrom", typeof(string));
                DataRow row = dtSendMail.NewRow();

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Keyid = keyid, Status = status }, urlMailDetails);

                if (returnResponse.IsSuccessStatusCode)
                {
                    string mailAction = string.Empty;
                    var fileJsonString = await returnResponse.Content.ReadAsStringAsync();
                    EmailModelobject mail = JsonConvert.DeserializeObject<EmailModelobject>(fileJsonString);
                    foreach (var m in mail.data)
                    {
                        row["mailTo"] = m.mailTo?.ToString();
                        row["mailCC"] = string.Empty;
                        row["mailBCC"] = string.Empty;
                        row["mailSubject"] = m.mailSubject?.ToString();
                        row["mailBody"] = m.mailBody?.ToString();
                        row["mailType"] = m.mailType?.ToString();
                        row["mailFrom"] = m.mailFrom?.ToString();
                    }
                    dtSendMail.Rows.Add(row);
                    mailAction = sendMail(dtSendMail, _appSettings);
                }
                dtSendMail.Dispose();
            }
            catch(Exception ex)
            {
                logger.LogError(ex, "Error in sending mail - action getRptMailDetails");
            }

        }

        public static string sendMail(DataTable dataTable, AppSettings _appSettings)
        {            
            string urlSendMail = _appSettings.WinServiceAppSettings.urlMailDetails;

            HttpClient client = new HttpClient();
            HttpResponseMessage httpResponse = new HttpResponseMessage();
            ResponseModel responseModel = new ResponseModel();
            try
            {
                string[] blankArray = new string[] { };
                foreach (DataRow dtr in dataTable.Rows)
                {
                    EmailModel EmailEnvelop = new EmailModel();
                    EmailEnvelop.mailTo = dtr["mailTo"].ToString().Split(',');
                    EmailEnvelop.mailCC = blankArray;
                    EmailEnvelop.mailBCC = blankArray;
                    EmailEnvelop.mailSubject = dtr["mailSubject"].ToString();
                    EmailEnvelop.mailBody = dtr["mailBody"].ToString();
                    EmailEnvelop.mailType = dtr["mailType"].ToString();
                    EmailEnvelop.mailFrom = dtr["mailFrom"].ToString();

                    string mailString = string.Empty;
                    mailString = JsonConvert.SerializeObject(EmailEnvelop);

                    client.DefaultRequestHeaders.Accept.Clear();
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var httpContent = new StringContent(mailString, Encoding.UTF8, "application/json");
                    httpResponse = client.PostAsync(urlSendMail, httpContent).Result;
                    string httpResponseContent = httpResponse.Content.ReadAsStringAsync().Result;
                    responseModel = JsonConvert.DeserializeObject<ResponseModel>(httpResponseContent);
                }
                return responseModel.ResponseStatus;
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }
            finally
            {
                if (client != null)
                {
                    client.Dispose();
                }
                if (httpResponse != null)
                {
                    httpResponse.Dispose();
                }
            }
        }

        public static async Task bulkTM01DuplDownload(string keyid, string user, string yyyy, string yymm, string yearmode, string simul, string reportid, AppSettings appSettings, ILogger logger, IServiceProvider serviceProvider )
        {
            logger.LogInformation($"{DateTime.Now}: Parameters - " + keyid + "-" + user + "-" + yyyy + "-" + yymm + "-" + yearmode + "-" + reportid);

            string urlTM01All = appSettings?.WinServiceAppSettings?.urlTM01All;
            string strFilePath = appSettings?.WinServiceAppSettings?.FilePath;

            try
            {                
                if (!Directory.Exists(keyid.ToString()))
                {
                    Directory.CreateDirectory(strFilePath + "\\" + keyid.ToString());
                }
                    
                string url = String.Format(urlTM01All, yymm, simul, yearmode);
                logger.LogDebug("Url --> " + url);

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Simul = simul, YearMode = yearmode}, urlTM01All, yyyy);

                if (returnResponse.IsSuccessStatusCode && returnResponse.Content.Headers.ContentType.MediaType != "application/json")
                {
                    string fName = "TM01All" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";
                    string strFilename = string.Format(@"{0}\{1}\{2}", strFilePath,
                                                                        keyid.ToString(),
                                                                        fName.ToString());

                    byte[] m_Bytes = null;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        await returnResponse.Content.CopyToAsync(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    File.WriteAllBytes(strFilename, m_Bytes);

                    // Update Process complete flag
                    await RAPLib.insertRptProcess(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString(), null, null, null, reportid.ToString(), "G", appSettings, logger, serviceProvider);
                    // Make a zip file
                    await makeZip(strFilePath + "\\" + keyid.ToString());
                    // Delete Folder
                    await deleteFolder(strFilePath + "\\" + keyid.ToString());
                    // Send mail
                    await getRptMailDetails(keyid.ToString(), "SUCCESS", appSettings, logger, serviceProvider);
                }               
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'bulkTM01DuplDownload'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), appSettings, logger, serviceProvider);
            }
        }

        public static async Task bulkCha1ExptDownload(string keyid, string user, string yyyy, string yymm, string yearmode, string category, string simul, string reportid, AppSettings appSettings, ILogger logger, IServiceProvider serviceProvider )
        {
            logger.LogInformation($"{DateTime.Now}: Parameters - " + keyid + "-" + user + "-" + yyyy + "-" + yymm + "-" + yearmode + "-" + category + "-" + simul + "-" + reportid);
                        
            string urlCHA1Common = appSettings?.WinServiceAppSettings?.urlCHA1Common;
            string strFilePath = appSettings?.WinServiceAppSettings?.FilePath;

            try
            {                
                if (!Directory.Exists(keyid.ToString()))
                {
                    Directory.CreateDirectory(strFilePath + "\\" + keyid.ToString());
                }
                    
                string url = String.Format(urlCHA1Common, yymm, category, simul, yearmode);
                logger.LogDebug("Url --> " + url);

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, Category = category, Simul = simul, YearMode = yearmode}, urlCHA1Common, yyyy);

                if (returnResponse.IsSuccessStatusCode && returnResponse.Content.Headers.ContentType.MediaType != "application/json")
                {
                    string fName = reportid + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                    string strFilename = string.Format(@"{0}\{1}\{2}", strFilePath,
                                                                        keyid.ToString(),
                                                                        fName.ToString());

                    byte[] m_Bytes = null;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        await returnResponse.Content.CopyToAsync(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    File.WriteAllBytes(strFilename, m_Bytes);

                    // Update Process complete flag
                    await RAPLib.insertRptProcess(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString(), category, null, simul?.ToString(), reportid.ToString(), "G", appSettings, logger, serviceProvider);
                    // Make a zip file
                    await makeZip(strFilePath + "\\" + keyid.ToString());
                    // Delete Folder
                    await deleteFolder(strFilePath + "\\" + keyid.ToString());
                    // Send mail
                    await getRptMailDetails(keyid.ToString(), "SUCCESS", appSettings, logger, serviceProvider);
                }                               
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'bulkCha1ExptDownload'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), appSettings, logger, serviceProvider);
            }
        }

        public static async Task bulkTMADownload(string keyid, string user, string yyyy, string yymm, string yearmode, string reporttype, string reportid, AppSettings appSettings, ILogger logger, IServiceProvider serviceProvider )
        {
            logger.LogInformation($"{DateTime.Now}: Parameters - " + keyid + "-" + user + "-" + yyyy + "-" + yymm + "-" + yearmode + "-" + reporttype + "-" + reportid);

            string urlTMACommon = appSettings?.WinServiceAppSettings?.urlTMACommon;
            string strFilePath = appSettings?.WinServiceAppSettings?.FilePath;

            try
            {
                if (!Directory.Exists(keyid.ToString()))
                {
                    Directory.CreateDirectory(strFilePath + "\\" + keyid.ToString());
                }

                string url = String.Format(urlTMACommon, yymm, yearmode, reporttype);
                logger.LogDebug("Url --> " + url);

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Yymm = yymm, YearMode = yearmode, ReportType = reporttype }, urlTMACommon, yyyy);                
                returnResponse.EnsureSuccessStatusCode();

                if (returnResponse.IsSuccessStatusCode && returnResponse.Content.Headers.ContentType.MediaType != "application/json")
                {
                    string fName = reportid + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                    string strFilename = string.Format(@"{0}\{1}\{2}", strFilePath,
                                                                        keyid.ToString(),
                                                                        fName.ToString());

                    byte[] m_Bytes = null;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        await returnResponse.Content.CopyToAsync(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    File.WriteAllBytes(strFilename, m_Bytes);

                    // Update Process complete flag
                    await RAPLib.insertRptProcess(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString(), null, reporttype, null, reportid.ToString(), "G", appSettings, logger, serviceProvider);
                    // Make a zip file
                    await makeZip(strFilePath + "\\" + keyid.ToString());
                    // Delete Folder
                    await deleteFolder(strFilePath + "\\" + keyid.ToString());
                    // Send mail
                    await getRptMailDetails(keyid.ToString(), "SUCCESS", appSettings, logger, serviceProvider);
                }                    
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'bulkTM01DuplDownload'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), appSettings, logger, serviceProvider);
            }
        }

        public static async Task bulkTCMJobsGrp(string keyid, string user, string yyyy, string yymm, string yearmode, string reportid, AppSettings appSettings, ILogger logger, IServiceProvider serviceProvider)
        {

            logger.LogInformation($"{DateTime.Now}: Parameters - " + keyid + "-" + user + "-" + yyyy + "-" + yymm + "-" + yearmode + "-" + reportid);

            try
            {
                string urlProjectTCMJobsGrp = appSettings.WinServiceAppSettings.urlProjectTCMJobsGrp;
                string strFilePath = appSettings.WinServiceAppSettings.FilePath;

                DataTable dt = new DataTable();
                dt.Columns.Add("projno");

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel { Yymm = yymm }, urlProjectTCMJobsGrp);

                if (returnResponse.IsSuccessStatusCode)
                {
                    var fileJsonString = await returnResponse.Content.ReadAsStringAsync();
                    ProjnoObject project = JsonConvert.DeserializeObject<ProjnoObject>(fileJsonString);
                    if (!Directory.Exists(keyid.ToString()))
                    {
                        Directory.CreateDirectory(strFilePath + "\\" + keyid.ToString());
                    }
                    foreach (var cc in project.data.Value)
                    {
                        dt.Rows.Add(cc.projno.ToString());
                    }
                }

                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow rr in dt.Rows)
                    {
                        try
                        {
                            await bulkTCMJobsGrp_download(keyid.ToString(),
                                                     rr["Projno"].ToString(),
                                                     yyyy,
                                                     yymm.ToString(),
                                                     yearmode.ToString(), appSettings, logger, serviceProvider);
                        }
                        catch (Exception ex)
                        {
                            string xx = ex.Message.ToString();
                        }
                    }
                    // Update Process complete flag
                    await RAPLib.insertRptProcess(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString(), null, null, null, reportid.ToString(), "G", appSettings, logger, serviceProvider);
                    // Make a zip file
                    await makeZip(strFilePath + "\\" + keyid.ToString());
                    // Delete Folder
                    await deleteFolder(strFilePath + "\\" + keyid.ToString());
                    // Send mail
                    await getRptMailDetails(keyid.ToString(), "SUCCESS", appSettings, logger, serviceProvider);
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'bulkTCMJobsGrp'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), appSettings, logger, serviceProvider);
            }
        }

        public static async Task bulkTCMJobsGrp_download(string keyid, string projno, string yyyy, string yymm, string yearmode, AppSettings _appSettings, ILogger logger, IServiceProvider serviceProvider)
        {
            string _uriTM11Data = _appSettings.WinServiceAppSettings.uriTM11Data;
            string strFilePath = _appSettings.WinServiceAppSettings.FilePath;
            try
            {
                string url = String.Format(_uriTM11Data, projno, yymm, yearmode);
                logger.LogDebug("Url --> " + url);

                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)serviceProvider.GetService(typeof(IHttpClientRapReporting));
                var returnResponse = await _httpClientRapReporting.ExecuteUriAsync(new Classes.HCModel
                { Projno = projno, Yymm = yymm, YearMode = yearmode, Yyyy = yyyy }, _uriTM11Data);

                if (returnResponse.IsSuccessStatusCode)
                {                    
                    string fName = projno.Substring(0, 5).Trim().ToString() + "G" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";

                    string strFilename = string.Format(@"{0}\{1}\{2}", strFilePath,
                                                                        keyid.ToString(),
                                                                        fName.ToString());

                    byte[] m_Bytes = null;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        await returnResponse.Content.CopyToAsync(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    File.WriteAllBytes(strFilename, m_Bytes);
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error in 'cha1_dept_download'");
                await getRptMailDetails(keyid.ToString(), ex.Message.ToString(), _appSettings, logger, serviceProvider);
            }
        }

    }
}
