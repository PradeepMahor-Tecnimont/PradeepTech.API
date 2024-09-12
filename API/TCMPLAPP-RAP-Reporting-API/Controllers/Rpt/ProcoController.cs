using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces;
using RapReportingApi.Repositories.Interfaces.User;
using RapReportingApi.Repositories.User;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt
{
    [Authorize]
    public class ProcoController : ControllerBase
    {
        private IProcoRepository procoRepository;
        private IOptions<AppSettings> appSettings;
        private IUserRepository userRepository;
        private string processingMonth = string.Empty;

        public ProcoController(IProcoRepository _procoRepository, IOptions<AppSettings> _settings, IUserRepository _userRepository)
        {
            procoRepository = _procoRepository;
            appSettings = _settings;
            userRepository = _userRepository;
            processingMonth = userRepository.getProcessingMonth().ToString().Trim();
        }

        //cc_post - PROCO
        [HttpGet]
        [Route("api/rap/rpt/ccpost")]
        public async Task<ActionResult> cc_post()
        {
            try
            {
                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value)
                    + @"\Proco\cc_post.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.cc_post(); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists ");
                }

                string Title = "Cost Centre Posting";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                        Title + "_.xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //check_posted - PROCO
        [HttpGet]
        [Route("api/rap/rpt/checkposted")]
        public async Task<ActionResult> check_posted()
        {
            try
            {
                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString() + @"\Proco\check_posted.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.check_posted(); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists ");
                }

                string Title = "Check_Posted";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                        Title + "_.xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //exptjobs - PROCO
        [HttpGet]
        [Route("api/rap/rpt/exptjobs")]
        public async Task<ActionResult> exptjobs()
        {
            try
            {
                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString() + @"\Proco\exptjobs.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.exptjobs(); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists ");
                }

                string Title = "Expected Jobs Master";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                        Title + "_.xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //kallo_daily - PROCO
        [HttpGet]
        [Route("api/rap/rpt/kallodaily")]
        public async Task<ActionResult> kallo_daily(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Proco\kallo_daily.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.kallo_daily(yymm); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for  yymm : {yymm}");
                }

                string Title = "Kallo ";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + "_" + yymm + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                         Title + "_" + yymm + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //projections - PROCO
        [HttpGet]
        [Route("api/rap/rpt/projections")]
        public async Task<ActionResult> projections(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString() + @"\Proco\projections.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.projections(yymm); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for   yymm : {yymm}");
                }

                string Title = "Projections ";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + "_" + yymm + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                        Title + "_" + yymm + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/PlanRep4")]
        public async Task<ActionResult> PlanRep4(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.PlanRep4(yymm); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for  yymm : {yymm}");
                }

                string Title = "Projections - Projects";
                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Proco\PlanRep4.xlsx";

                var workbook = new XLWorkbook(XlTempPath);
                var sheet = workbook.Worksheet("ReportData");

                var vTable = workbook.Table("DataTable");
                vTable.ReplaceData(dataTable, propagateExtraColumns: true);

                var wb = workbook;

                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + "_" + yymm + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                      Title + "_" + yymm + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/PlanRep5")]
        public async Task<ActionResult> PlanRep5(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.PlanRep5(yymm); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for   yymm : {yymm}");
                }

                string Title = "Projections - Future Projects";
                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Proco\PlanRep5.xlsx";

                var workbook = new XLWorkbook(XlTempPath);
                var sheet = workbook.Worksheet("ReportData");

                var vTable = workbook.Table("DataTable");
                vTable.ReplaceData(dataTable, propagateExtraColumns: true);

                var wb = workbook;

                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + "_" + yymm + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                      Title + "_" + yymm + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/PROCO_TS_ACT")]
        public async Task<ActionResult> PROCO_TS_ACT(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Proco\PROCO_TS_ACT.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.PROCO_TS_ACT(yymm); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for   yymm : {yymm}");
                }

                string Title = "PROCO_TS_ACT";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + "_" + yymm + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                      Title + "_" + yymm + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/DATEWISE_TS")]
        public async Task<ActionResult> DATEWISE_TS(string ProjNo, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                ProjNo = ProjNo.Trim();

                if (ProjNo.Length != 5 && ProjNo.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Proco\DATEWISE_TS.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.DATEWISE_TS(ProjNo, yymm); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {ProjNo} , yymm : {yymm}");
                }

                string Title = "Download of DATEWISE_TS for Project for Month";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + "_" + ProjNo + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                      Title + "_" + ProjNo + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/TS_ACT_COVID")]
        public async Task<ActionResult> TS_ACT_COVID(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Proco\TS_ACT_COVID.xlsx") ;

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)procoRepository.TS_ACT_COVID(yymm); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for  yymm : {yymm}");
                }

                string Title = "Activities beginneing with Y";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = Title + "_" + yymm + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                    Title + "_" + yymm + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //Employees / Manhours who have not posted their Timesheets
        [HttpGet]
        [Route("api/rap/rpt/empl_mhrs_not_posted")]
        public async Task<ActionResult> empl_mhrs_not_posted(string yymm)
        {
            DataSet ds = new DataSet();

            try
            {
                //if (string.IsNullOrWhiteSpace(yymm))
                //{
                //    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                //}
                //else if (yymm.Trim().Length != 6)
                //{
                //    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                //}
                //else if (processingMonth != yymm.Trim())
                //{
                //    throw new RAPInvalidParameter("Parameter value is invalid> Processing Month and selected month not match ,please check");
                //}
                yymm = processingMonth;

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString() + @"\Proco\empl_mhrs_not_posted.xlsx");

                ds = (DataSet)procoRepository.empl_mhrs_not_posted(yymm);

                if (ds.Tables["dtEmployees"].Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists ");
                }
                string Title = string.Empty;
                Title = "List of Employees not posted";
                template.AddVariable("Title_Employees", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));
                template.AddVariable("ProcMonth", "Processing Month : " + yymm);
                template.AddVariable("Data_Employees", ds.Tables["dtEmployees"]);

                Title = "List of Manhours not posted";
                template.AddVariable("Title_Manhours", Title);
                template.AddVariable("Data_Manhours", ds.Tables["dtManhours"]);

                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = yymm.Trim().Substring(2) + "Employees_Manhours_not_Posted.xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                   yymm.Trim().Substring(2) + "Employees_Manhours_not_Posted.xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                ds.Dispose();
            }
        }
    }
}