using ClosedXML.Excel;
using ClosedXML.Report;
using ClosedXML.Report.Utils;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Org.BouncyCastle.Utilities;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers
{
    [Authorize]
    [Produces("application/json")]
    public class AfterPostAFCController : ControllerBase
    {
        private IOptions<AppSettings> appSettings;
        private IAfterPostAFCRepository afterPostAFCRepository;
        private XLColor customColor = XLColor.FromArgb(r: 79, g: 129, b: 189);

        public AfterPostAFCController(IAfterPostAFCRepository _afterPostAFCRepository, IOptions<AppSettings> _settings)
        {
            appSettings = _settings;
            afterPostAFCRepository = _afterPostAFCRepository;
        }

        [HttpGet]
        [Route("api/rap/rpt/Auditor_Download")]
        public async Task<ActionResult> Auditor_Download(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostAFC\Auditor.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostAFCRepository.Auditor(yymm, Request.Headers["activeYear"].ToString()); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound("No data exists for " + yymm);
                }

                string Title = "Monthly Report for Manhours";

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
                    strFileName = Title + "_" + yymm.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("api/rap/rpt/Finance_TS_Download")]
        //public async Task<ActionResult> Finance_TS_Download(string yymm)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(yymm))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        else if (yymm.Length != 6)
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }

        // var template = new XLTemplate(oAppSettings.Value.RAPAppSettings
        // .ApplicationRepository.ToString() + @"\AfterPostAFC\Finance_TS.xlsx");

        // DataTable dataTable = new DataTable(); dataTable =
        // (DataTable)afterPostAFCRepository.Finance_TS(yymm); //Get DataTable if
        // (dataTable.Rows.Count <= 0) { throw new RAPDataNotFound("No data exists for " + yymm); }

        // string Title = "Finance_TS ";

        // template.AddVariable("Title", Title); template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

        // template.AddVariable("Data", dataTable); template.Generate();

        //        var wb = template.Workbook;
        //        byte[] m_Bytes = null;
        //        using (MemoryStream ms = new MemoryStream())
        //        {
        //            wb.SaveAs(ms);
        //            byte[] buffer = ms.GetBuffer();
        //            long length = ms.Length;
        //            m_Bytes = ms.ToArray();
        //        }
        //        var t = Task.Run(() =>
        //        {
        //            string strFileName = string.Empty;
        //            strFileName = Title + "_" + yymm.ToString() + ".xlsx";
        //            return this.File(
        //                           fileContents: m_Bytes,
        //                          contentType: oAppSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        //                           fileDownloadName: strFileName
        //                       );
        //        });
        //        Response.Headers.Add("xl_file_name", Title + "_" + yymm.ToString() + ".xlsx");
        //        return await t;
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/Finance_TS_Download")]
        public async Task<ActionResult> Finance_TS_Download(string yymm, string yearmode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yearmode.Trim() != "A" && yearmode.Trim() != "J")
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostAFC\Finance_TS.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostAFCRepository.Finance_TS(yymm, yearmode, Request.Headers["activeYear"].ToString()); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound("No data exists for " + yymm);
                }

                string Title = "Finance_TS ";

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
                    strFileName = Title + "_" + yymm.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/JOB_PROJ_PH_LIST_Download")]
        public async Task<ActionResult> JOB_PROJ_PH_LIST_Download(string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostAFC\JOB_PROJ_PH_LIST.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostAFCRepository.JOB_PROJ_PH_LIST(yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound("No data exists for " + yymm);
                }

                string Title = "Job Phase List";

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
                    strFileName = Title + "_" + yymm.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Auditor_Subcontractor_wise_Download")]
        public async Task<ActionResult> Auditor_Subcontractor_wise_Download(string yymm, string yearmode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yearmode.Trim() != "A" && yearmode.Trim() != "J")
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtAuditor = new DataTable();
                dtAuditor = (DataTable)afterPostAFCRepository.AuditorSubcontractorWiseList(yymm, yearmode, Request.Headers["activeYear"].ToString());
                if (dtAuditor.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for  yymm : {yymm}");
                }
                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtAuditor.Columns.Count;
                    Int32 rows = dtAuditor.Rows.Count;

                    ws.Range(1, 1, 1, 15).Merge();
                    ws.Range(1, 1, 1, 15).Value = "Projectwise Employeewise Manhours Report";
                    ws.Range(1, 1, 1, 15).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 15).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 15).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 11).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 15).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtAuditor);
                    //var cells = ws.Range(2, cols, rows + 1, cols).Cells().ToList();
                    //var sum = cells.Sum(xlCell => (double)xlCell.Value);
                    //ws.Cell(rows + 2, cols).Value = sum;

                    ws.Cell(rows + 4, 1).Value = "Total";

                    ws.Cell(rows + 4, cols - 2).FormulaA1 = "=SUM(M2:M" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 2, cols - 2).Style.Font.Bold = true;

                    ws.Cell(rows + 4, cols - 1).FormulaA1 = "=SUM(N2:N" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 2, cols - 1).Style.Font.Bold = true;

                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(O2:O" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 2, cols).Style.Font.Bold = true;

                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;
                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

                    //ws.Cell(rows + 4, 1).Value = "Grand Total";
                    //ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(O2:O" + (rows + 3) + ")";
                    //ws.Range(rows + 4, 1, rows + 2, cols).Style.Font.Bold = true;

                    //ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;
                    //ws.Range(rows + 4, 1, rows + 4, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

                    var rngTable = ws.Range("A3:F" + (rows + 4));
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
                    strFileName = "AuditorReport_" + yymm.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "ProjwiseEmpwiseManhours_" + yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/CovidManhrsDistribution")]
        public async Task<ActionResult> CovidManhrsDistribution(string yymm, string costcode, string projno)
        {
            try
            {
                //if (string.IsNullOrWhiteSpace(yymm))
                //{
                //    throw new RAPInvalidParameter("Parameter value is invalid (yymm), please check");
                //}
                //else if (yymm.Trim().Length != 6)
                //{
                //    throw new RAPInvalidParameter("Parameter value is invalid (yymm), please check");
                //}

                //if (string.IsNullOrWhiteSpace(costcode))
                //{
                //    throw new RAPInvalidParameter("Parameter value is invalid (costcode), please check");
                //}
                //if (string.IsNullOrWhiteSpace(projno))
                //{
                //    throw new RAPInvalidParameter("Parameter value is invalid (projno), please check");
                //}

                byte[] m_Bytes = null;
                DataTable dt = new DataTable();
                dt = (DataTable)afterPostAFCRepository.CovidManhrsDistributionReport(yymm, costcode, projno);

                if (dt.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for yymm : {yymm} , costcode : {costcode} , projno : {projno}");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Covid Manhrs Distribution");
                    Int32 cols = dt.Columns.Count;
                    Int32 rows = dt.Rows.Count;

                    ws.Range(1, 1, 1, 14).Merge();
                    ws.Range(1, 1, 1, 14).Value = "Covid Manhrs Distribution";
                    ws.Range(1, 1, 1, 14).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 14).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 14).Style.Font.FontColor = XLColor.White;
                    ws.Range(1, 1, 1, 14).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dt);

                    ws.Cell(rows + 4, 1).Value = "Grand Total";
                    ws.Cell(rows + 4, cols - 3).FormulaA1 = "=SUM(J2:J" + (rows + 3) + ")";
                    ws.Cell(rows + 4, cols - 2).FormulaA1 = "=SUM(K2:K" + (rows + 3) + ")";
                    ws.Cell(rows + 4, cols - 1).FormulaA1 = "=SUM(L2:L" + (rows + 3) + ")";
                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(M2:M" + (rows + 3) + ")";

                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;

                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

                    var rngTable = ws.Range("A3:L" + (rows + 2));
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
                    strFileName = "CovidManhrsDistribution.xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "CovidManhrsDistribution.xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Manhour_Export_To_SAP_Download")]
        public async Task<ActionResult> Manhour_Export_To_SAP_Download(string yymm, string reporttype, string costcenter, string projno, string employeetypelist)
        {
            string fileNameZip = "Manhour_Export_To_SAP_" + yymm.ToString() + ".zip";

            try
            {
                if (string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(reporttype) || string.IsNullOrWhiteSpace(employeetypelist))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (reporttype == "C" && string.IsNullOrWhiteSpace(costcenter))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (reporttype == "P" && string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                                                                
                DataSet ds  = new DataSet();
                ds = (DataSet)afterPostAFCRepository.ManhourExportToSAPList(yymm, reporttype, costcenter, projno, employeetypelist);
                                
                byte[] compressedBytes;                

                using (var outStream = new MemoryStream())
                {  
                    using (var archive = new ZipArchive(outStream, ZipArchiveMode.Create, true))
                    {
                        foreach (DataTable tab in ds.Tables)
                        {
                            if (tab.Rows.Count > 0)
                            {
                                byte[] fileBytes = null;
                                string fname_txt = String.Empty;
                                string fname_csv = String.Empty;

                                StringBuilder sb = new StringBuilder();
                                IEnumerable<string> columnNames = tab.Columns.Cast<DataColumn>().
                                                                    Select(column => column.ColumnName);
                                sb.AppendLine(string.Join(",", columnNames));

                                foreach (DataRow row in tab.Rows)
                                {
                                    IEnumerable<string> fields = row.ItemArray.Select(field => field.ToString());
                                    sb.AppendLine(string.Join(",", fields));
                                }

                                fileBytes = System.Text.Encoding.UTF8.GetBytes(sb.ToString());

                                switch (tab.TableName)
                                {
                                    case "all":
                                        fname_txt = "sap_all_" + yymm.ToString() + ".txt";
                                        fname_csv = "sap_all_" + yymm.ToString() + ".csv";
                                        break;
                                    case "all_neg":
                                        fname_txt = "sap_all_negative_" + yymm.ToString() + ".txt";
                                        fname_csv = "sap_all_negative_" + yymm.ToString() + ".csv";
                                        break;
                                    case "dept":
                                        fname_txt = "sap_0238_0245_0291_" + yymm.ToString() + ".txt";
                                        fname_csv = "sap_0238_0245_0291_" + yymm.ToString() + ".csv";
                                        break;
                                    case "dept_neg":
                                        fname_txt = "sap_0238_0245_0291_negative_" + yymm.ToString() + ".txt";
                                        fname_csv = "sap_0238_0245_0291_negative_" + yymm.ToString() + ".csv";
                                        break;
                                    case "custom":
                                        if (!string.IsNullOrEmpty(costcenter))
                                        {
                                            fname_txt = "sap_costcenter_" + costcenter.ToString() + "_all_" + yymm.ToString() + ".txt";
                                            fname_csv = "sap_costcenter_" + costcenter.ToString() + "_all_" + yymm.ToString() + ".csv";
                                        }
                                        if (!string.IsNullOrEmpty(projno))
                                        {
                                            fname_txt = "sap_project_" + projno.ToString() + "_all_" + yymm.ToString() + ".txt";
                                            fname_csv = "sap_project_" + projno.ToString() + "_all_" + yymm.ToString() + ".csv";
                                        }
                                        break;
                                    case "custom_ng":
                                        if (!string.IsNullOrEmpty(costcenter))
                                        {
                                            fname_txt = "sap_costcenter_" + costcenter.ToString() + "_" + employeetypelist.Replace(",","_") + "_all_negative_" + yymm.ToString() + ".txt";
                                            fname_csv = "sap_costcenter_" + costcenter.ToString() + "_" + employeetypelist.Replace(",", "_") +"_all_negative_" + yymm.ToString() + ".csv";
                                        }
                                        if (!string.IsNullOrEmpty(projno))
                                        {
                                            fname_txt = "sap_project_" + projno.ToString() + "_" + employeetypelist.Replace(",", "_") + "_all_negative_" + yymm.ToString() + ".txt";
                                            fname_csv = "sap_project_" + projno.ToString() + "_" + employeetypelist.Replace(",", "_") + "_all_negative_" + yymm.ToString() + ".csv";
                                        }
                                        break;
                                    default:
                                        break;
                                }

                                var farchive_txt = archive.CreateEntry(fname_txt, CompressionLevel.Optimal);
                                    
                                using (var entryStream_txt = farchive_txt.Open())
                                {
                                    using (var fileToCompStream_txt = new MemoryStream(fileBytes))
                                    {
                                        using (var reader_txt = new StreamReader(fileToCompStream_txt))
                                        {
                                            string line_txt = null;
                                            if ((line_txt = reader_txt.ReadLine()) != null)
                                            {
                                                fileToCompStream_txt.Position = line_txt.Length + 2;
                                            }
                                            fileToCompStream_txt.CopyTo(entryStream_txt);
                                        }
                                    }                                    
                                }

                                var farchive_csv = archive.CreateEntry(fname_csv, CompressionLevel.Optimal);

                                using (var entryStream_csv = farchive_csv.Open())
                                {
                                    using (var fileToCompStream_csv = new MemoryStream(fileBytes))
                                    {
                                        using (var reader_csv = new StreamReader(fileToCompStream_csv))
                                        {
                                            string line_csv = null;
                                            if ((line_csv = reader_csv.ReadLine()) != null)
                                            {
                                                fileToCompStream_csv.Position = line_csv.Length + 2;
                                            }
                                            fileToCompStream_csv.CopyTo(entryStream_csv);
                                        }
                                    }                                                                       
                                }
                            }
                            
                        }
                    }
                    compressedBytes = outStream.ToArray();
                }
                var t = Task.Run(() =>
                {
                    return this.File(
                                   fileContents: compressedBytes,
                                   contentType: appSettings.Value.RAPAppSettings.ZipContentType.ToString(),
                                   fileDownloadName: fileNameZip
                               );
                    
                });
                Response.Headers.Add("xl_file_name", fileNameZip);

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}