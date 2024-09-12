using ClosedXML.Excel;
using ClosedXML.Report;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using MoreLinq;
using MoreLinq.Extensions;
using Org.BouncyCastle.Utilities;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt
{
    [Authorize]
    [Produces("application/json")]
    public class AfterPostHRController : ControllerBase
    {
        private IOptions<AppSettings> appSettings;
        private IHRRepository hrRepository;
        private XLColor customColor = XLColor.FromArgb(r: 79, g: 129, b: 189);

        public AfterPostHRController(IHRRepository _hrRepository, IOptions<AppSettings> _settings)
        {
            appSettings = _settings;
            hrRepository = _hrRepository;
        }

        [HttpGet]
        [Route("api/rap/rpt/Employee_2011onwards_Download")]
        public async Task<ActionResult> Employee_2011onwards_Download(string Empno)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(Empno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (Empno.Trim().Length != 5)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostHR\Employee_2011onwards.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)hrRepository.Employee_2011onwards(Empno); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for Empno : {Empno} ");
                }

                string Title = "Employee Details ";

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
                    strFileName = Title + "_" + Empno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });

                Response.Headers.Add("xl_file_name", Title + "_" + Empno.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/SUBCONTRACTOR_TS_Download")]
        public async Task<ActionResult> SUBCONTRACTOR_TS_Download(string Yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(Yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (Yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostHR\SUBCONTRACTOR_TS.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)hrRepository.SUBCONTRACTOR_TS(Yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for yymm : {Yymm}");
                }

                string Title = "SUBCONTRACTOR_TS";

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
                    strFileName = Title + "_" + Yymm.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + Yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/TSPENDING")]
        public async Task<ActionResult> TSPENDING(string Yymm, string ReportType)
        {
            string filename = string.Empty;
            string title = string.Empty;

            try
            {
                if (string.IsNullOrWhiteSpace(Yymm) && string.IsNullOrWhiteSpace(ReportType))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (Yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostHR\TSNOTFILLED_POSTED.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)hrRepository.TSPENDING(Yymm, ReportType);
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for yymm : {Yymm}");
                }

                if (ReportType == "Filled")
                {
                    title = "TIMESHEET NOT FILLED";
                    filename = "TIMESHEET_NOT_FILLED";
                }

                if (ReportType == "Posted")
                {
                    title = "TIMESHEET NOT POSTED";
                    filename = "TIMESHEET_NOT_POSTED";
                }

                template.AddVariable("Title", title);
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
                    strFileName = filename + "_" + Yymm.ToString() + ".xlsx";
                    return this.File(
                                  fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                  fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", filename + "_" + Yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/LeaveHRRptDownload")]
        public async Task<ActionResult> LeaveHRRptDownload(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                
                byte[] m_Bytes = null;
                DateTime dd = new DateTime();
                DataSet ds = new DataSet();                
                ds = (DataSet)hrRepository.LeaveHRReport(yymm);
                IXLWorksheet ws;
                string pwsDataTableName = "Data1";

                if (ds.Tables[0].Rows.Count == 0 && ds.Tables[1].Rows.Count == 0)
                {
                    throw new RAPDataNotFound(@$"No data exists");
                }

                using (XLWorkbook wb = new XLWorkbook(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostHR\Leave_Manhours.xlsx"))
                {
                    for (int i = 0; i < 2; i++)
                    {
                        if (ds.Tables[i].Rows.Count > 0)
                        {
                            DateTime d = new DateTime(int.Parse(yymm.Substring(0, 4)), int.Parse(yymm.Substring(4, 2)), 1);
                            dd = d.AddMonths(-i);
                            
                            ws = wb.Worksheet(i+1);

                            Int32 cols = ds.Tables[i].Columns.Count;
                            Int32 rows = ds.Tables[i].Rows.Count;

                            ws.Name = string.Concat(dd.ToString("MMM"), " ", dd.Year);
                            ws.Cell(1, 1).Value = "Leave Report - " + string.Concat(dd.ToString("MMM"), " ", dd.Year);

                            if (i==0)
                                ws.Cell(3, 1).InsertTable(ds.Tables[i]);
                            else
                                wb.Table(pwsDataTableName).ReplaceData(ds.Tables[1]);

                            ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;

                            var rngTable = ws.Range("A3:AM" + (rows + 4));
                            rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                            rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
                            rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                            rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
                            rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                            rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
                            rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
                            rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

                            ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
                            ws.Columns().AdjustToContents();
                            wb.CalculateMode = XLCalculateMode.Auto;                            

                            if (i == 1)
                            {
                                ws = wb.Worksheet(3);
                                ws.Cell(1, 1).Value = "Pivot - " + string.Concat(dd.ToString("MMM"), " ", dd.Year);                                
                            }

                        }
                    }
                    
                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }
                }
                var t = Task.Run(() =>
                {
                    string strFileName = string.Empty;
                    strFileName = "Leave_timesheets_" + yymm.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                 "Leave_timesheets_" + yymm.ToString() + ".xlsx");

                return await t;
                
            }
            catch (Exception)
            {
                throw;
            }
        }

        [Route("api/rap/rpt/downloadTimesheet")]
        [HttpGet]
        public async Task<ActionResult> getDownLoadTimesheet(string empno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(empno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else
                {
                    if (empno.ToString().Length != 5 || yymm.ToString().Length != 6)
                    {
                        throw new RAPInvalidParameter("Parameter values are invalid, please check");
                    }
                }

                var t = Task.Run(() =>
                {
                    byte[] m_Bytes = hrRepository.getDownLoadTimesheet(empno, yymm);

                    if (m_Bytes == null)
                        throw new Exception("No data found");

                    string strFileName = string.Empty;

                    strFileName = "Timesheet_" + empno + "_" + yymm + ".xlsx";

                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                 "Timesheet_" + yymm.ToString() + "_" + empno.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("api/rap/rpt/RunExeFile")]
        ////api/rap/rpt/RunExeFile
        //public async Task<ActionResult> RunExeFile()
        //{
        //    try
        //    {
        //        var t = Task.Run(() =>
        //        {
        //            Test();
        //        });
        //        return Ok();
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        //public async Task Test()
        //{
        //    Process p = new Process();
        //    p.StartInfo.FileName = @$"D:\HostedApps\TestApiCall\RapBulkReportGenerator.exe";
        //    p.Start();
        //    p.WaitForExit();
        //    p.Close();

        //    // Create a Process Object here.
        //    System.Diagnostics.Process process1 = new System.Diagnostics.Process();
        //    //Working Directory Of .exe File.
        //    process1.StartInfo.WorkingDirectory = @$"D:\HostedApps\TestApiCall\";
        //    //exe File Name.
        //    process1.StartInfo.FileName = "RapBulkReportGenerator.exe";
        //    //Argement Which you have tp pass.
        //    process1.StartInfo.Arguments = " ";
        //    process1.StartInfo.LoadUserProfile = true;
        //    //Process Start on exe.
        //    process1.Start();
        //    process1.WaitForExit();
        //    process1.Close();
        //}
    }
}