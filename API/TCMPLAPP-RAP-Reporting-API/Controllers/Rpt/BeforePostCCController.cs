using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt
{
    [Authorize]
    public class BeforePostCCController : ControllerBase
    {
        private IBeforePostCCRepository beforepostccRepository;
        private IOptions<AppSettings> appSettings;
        private XLColor customColor = XLColor.FromArgb(r: 79, g: 129, b: 189);

        public BeforePostCCController(IBeforePostCCRepository _beforepostccRepository, IOptions<AppSettings> _settings)
        {
            beforepostccRepository = _beforepostccRepository;
            appSettings = _settings;
        }

        //[HttpGet]
        ////[Route("GetSalesTaxRate(PostalCode={postalCode})")]
        ////[FromODataUri] int postalCode
        ////[Route("api/[controller]/GetSalesTaxRate")]
        //public IActionResult GetSalesTaxRate()
        //{
        //    double rate = 5.6;  // Use a fake number for the sample.
        //    return Ok(rate);
        //}

        //[HttpGet]
        //[Route("AuditorReport()")]
        ////[Route("api/[controller]/AuditorReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult AuditorReport()
        //{
        //    try
        //    {
        //        DataTable dtAuditor = new DataTable();
        //        dtAuditor = (DataTable)beforepostccRepository.AuditorReport();
        //        var result = dtAuditor.AsEnumerable().Select(row =>
        //                            new Auditor
        //                            {
        //                                Company = ((string)row["company"]),
        //                                Tmagrp = ((string)row["tmagrp"]),
        //                                Emptype = ((string)row["emptype"]),
        //                                Location = ((string)row["location"]),
        //                                Yymm = ((string)row["yymm"]),
        //                                Costcode = ((string)row["costcode"]),
        //                                Projno = ((string)row["projno"]),
        //                                Name = ((string)row["name"]),
        //                                Hours = ((decimal)row["hours"]),
        //                                Othours = ((decimal)row["othours"]),
        //                                Tothours = ((decimal)row["tothours"])
        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/AuditorRptDownload")]
        public async Task<ActionResult> AuditorRptDownload(string yymm, string yearmode)
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

                dtAuditor = (DataTable)beforepostccRepository.AuditorReport(yymm, yearmode, Request.Headers["activeYear"].ToString());

                if (dtAuditor.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for  yymm : {yymm}");
                }
                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtAuditor.Columns.Count;
                    Int32 rows = dtAuditor.Rows.Count;

                    ws.Range(1, 1, 1, 14).Merge();
                    ws.Range(1, 1, 1, 14).Value = "Auditor Report";
                    ws.Range(1, 1, 1, 14).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 14).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 14).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 11).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 14).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtAuditor);
                    //var cells = ws.Range(2, cols, rows + 1, cols).Cells().ToList();
                    //var sum = cells.Sum(xlCell => (double)xlCell.Value);
                    //ws.Cell(rows + 2, cols).Value = sum;

                    ws.Cell(rows + 4, 1).Value = "Total";

                    ws.Cell(rows + 4, cols - 2).FormulaA1 = "=SUM(L2:L" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 2, cols - 2).Style.Font.Bold = true;

                    ws.Cell(rows + 4, cols - 1).FormulaA1 = "=SUM(M2:M" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 2, cols - 1).Style.Font.Bold = true;

                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(N2:N" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 2, cols).Style.Font.Bold = true;

                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;
                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

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
                Response.Headers.Add("xl_file_name", "AuditorReport_" + yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("MJMReport(Assign={assign})")]
        ////[Route("api/[controller]/MJMReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult MJMReport([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtMJM = new DataTable();
        //        dtMJM = (DataTable)beforepostccRepository.MJMReport(assign); ;
        //        var result = dtMJM.AsEnumerable().Select(row =>
        //                            new MJMReport
        //                            {
        //                                Yymm = ((string)row["yymm"]),
        //                                Assign = ((string)row["assign"]),
        //                                Assignname = ((string)row["assignname"]),
        //                                Projno = ((string)row["projno"]),
        //                                Projname = ((string)row["projname"]),
        //                                Tothrs = ((decimal)row["tothrs"])
        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/MJMRptDownload")]
        public async Task<ActionResult> MJMRptDownload(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtMJM = new DataTable();
                dtMJM = (DataTable)beforepostccRepository.MJMReport(yymm, assign);

                if (dtMJM.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }
                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtMJM.Columns.Count;
                    Int32 rows = dtMJM.Rows.Count;

                    ws.Range(1, 1, 1, 6).Merge();
                    ws.Range(1, 1, 1, 6).Value = "Monthly Jobwise Manhours";
                    ws.Range(1, 1, 1, 6).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 6).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 6).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 6).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 6).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtMJM);
                    //var cells = ws.Range(2, cols, rows + 1, cols).Cells().ToList();
                    //var sum = cells.Sum(xlCell => (double)xlCell.Value);
                    //ws.Cell(rows + 2, cols).Value = sum;
                    ws.Cell(rows + 4, 1).Value = "Grand Total";
                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(F2:F" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 2, cols).Style.Font.Bold = true;

                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;
                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

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
                    strFileName = "Monthly_Jobwise_Manhours_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),

                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "Monthly_Jobwise_Manhours_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("MJAMReport(Assign={assign})")]
        ////[Route("api/[controller]/MJAMReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult MJAMReport([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtMJAM = new DataTable();
        //        dtMJAM = (DataTable)beforepostccRepository.MJAMReport(assign); ;
        //        var result = dtMJAM.AsEnumerable().Select(row =>
        //                            new MJAMReport
        //                            {
        //                                Yymm = ((string)row["yymm"]),
        //                                Assign = ((string)row["assign"]),
        //                                Projno = ((string)row["projno"]),
        //                                Projname = ((string)row["projname"]),
        //                                Activity = ((string)row["activity"]),
        //                                Actname = ((string)row["actname"]),
        //                                Tothrs = ((decimal)row["tothrs"])

        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/MJAMRptDownload")]
        public async Task<ActionResult> MJAMRptDownload(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtMJAM = new DataTable();
                dtMJAM = (DataTable)beforepostccRepository.MJAMReport(yymm, assign);
                if (dtMJAM.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtMJAM.Columns.Count;
                    Int32 rows = dtMJAM.Rows.Count;

                    ws.Range(1, 1, 1, 7).Merge();
                    ws.Range(1, 1, 1, 7).Value = "Monthly Jobwise Activity Manhours";
                    ws.Range(1, 1, 1, 7).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 7).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 7).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 7).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 7).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtMJAM);
                    ws.Cell(rows + 4, 1).Value = "Grand Total";
                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(G2:G" + (rows + 3) + ")";
                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;

                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;
                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

                    var rngTable = ws.Range("A3:G" + (rows + 4));
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
                    strFileName = "Job_Activity_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "Job_Activity_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("DUPLSTA6Report(Assign={assign})")]
        ////[Route("api/[controller]/DUPLSTA6Report")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult DUPLSTA6Report([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtDUPLSTA6 = new DataTable();
        //        dtDUPLSTA6 = (DataTable)beforepostccRepository.DUPLSTA6Report(assign); ;
        //        var result = dtDUPLSTA6.AsEnumerable().Select(row =>
        //                            new DUPLSTA6Report
        //                            {
        //                                Yymm = ((string)row["yymm"]),
        //                                Assign = ((string)row["assign"]),
        //                                Empno = ((string)row["empno"]),
        //                                Empname = ((string)row["empname"]),
        //                                Projno = ((string)row["projno"]),
        //                                Activity = ((string)row["activity"]),
        //                                Nhrs = ((decimal)row["nhrs"]),
        //                                Ohrs = ((decimal)row["ohrs"])
        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/DUPLSTA6RptDownloadOld")]
        public async Task<ActionResult> DUPLSTA6RptDownloadOld(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtDUPLSTA6 = new DataTable();
                dtDUPLSTA6 = (DataTable)beforepostccRepository.DUPLSTA6Report(yymm, assign);

                if (dtDUPLSTA6.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtDUPLSTA6.Columns.Count;
                    Int32 rows = dtDUPLSTA6.Rows.Count;

                    ws.Range(1, 1, 1, 8).Merge();
                    ws.Range(1, 1, 1, 8).Value = "STA6 Before Posting";
                    ws.Range(1, 1, 1, 8).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 8).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 8).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 8).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 8).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtDUPLSTA6);

                    ws.Cell(rows + 4, 1).Value = "Total";
                    ws.Cell(rows + 5, 1).Value = "Grand Total";
                    ws.Cell(rows + 4, cols - 1).FormulaA1 = "=SUM(G3:G" + (rows + 3) + ")";
                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(H3:H" + (rows + 3) + ")";
                    ws.Cell(rows + 5, cols).FormulaA1 = "=SUM(G3:H" + (rows + 3) + ")";

                    ws.Range(rows + 4, 1, rows + 5, cols).Style.Font.Bold = true;
                    ws.Range(rows + 4, 1, rows + 5, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

                    var rngTable = ws.Range("A3:H" + (rows + 5));
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
                    strFileName = "DUPLSTA6_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "DUPLSTA6_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //CHA1STA6TM02 - Cost Code
        [HttpGet]
        [Route("api/rap/rpt/DUPLSTA6RptDownload")]
        public async Task<ActionResult> DUPLSTA6RptDownload(string yymm, string assign, string yearmode)
        {
            DataSet dsSta6Tm02Act01 = new DataSet();

            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\BeforePost\DUPLSTA6.xlsx");

                dsSta6Tm02Act01 = (DataSet)beforepostccRepository.DUPLSTA6Report(yymm, assign);

                //STA6
                var wb = template.Workbook;
                var ws = wb.Worksheet("STA6");
                ws.Cell("M2").Value = DateTime.Now.ToString("dd-MMM-yyyy");
                if (yearmode == "J")
                {
                    ws.Cell("M3").Value = "Jan - Dec";
                }
                else
                {
                    ws.Cell("M3").Value = "Apr - Mar";
                }
                ws.Cell("M4").Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                ws.Cell("E6").Value = "'" + assign;
                ws.Cell("J6").Value = dsSta6Tm02Act01.Tables["STA6_CostCode"].Rows[0].Field<string>("CCNAME");
                ws.Cell("J7").Value = dsSta6Tm02Act01.Tables["STA6_CostCode"].Rows[0].Field<string>("EMPLNAME");

                //STA6
                template.AddVariable("STA6_Data", dsSta6Tm02Act01.Tables["STA6_Data"]);

                string notSubmitted = string.Empty;
                string dummyString = string.Empty;
                if (dsSta6Tm02Act01.Tables["STA6_NotSub_Data"].Rows.Count > 0)
                {
                    for (int i = 0; i < 137; i++)
                    {
                        dummyString = dummyString + " ";
                    }
                    notSubmitted = "List of Employees who have not sumbitted their timesheets" + dummyString;
                }
                template.AddVariable("notSubmitted", notSubmitted);
                template.AddVariable("STA6_NotSub_Data", dsSta6Tm02Act01.Tables["STA6_NotSub_Data"]);

                string oddTimesheet = string.Empty;
                if (dsSta6Tm02Act01.Tables["STA6_Odd_Data"].Rows.Count > 0)
                {
                    dummyString = string.Empty;
                    for (int i = 0; i < 172; i++)
                    {
                        dummyString = dummyString + " ";
                    }
                    oddTimesheet = "Timesheets filled in other Cost Centre" + dummyString;
                }
                template.AddVariable("oddTimesheet", oddTimesheet);
                template.AddVariable("STA6_Odd_Data", dsSta6Tm02Act01.Tables["STA6_Odd_Data"]);

                //STA6_1
                template.AddVariable("STA6_1_Data", dsSta6Tm02Act01.Tables["STA6_1_Data"]);

                //STA6_2
                template.AddVariable("STA6_2_Data", dsSta6Tm02Act01.Tables["STA6_2_Data"]);

                template.Generate();

                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                string strFileName = string.Empty;
                strFileName = "Dupl STA6_" + assign.Trim() + "_" + yymm.Trim().Substring(2) + ".xlsx";
                var t = Task.Run(() =>
                {
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", strFileName);
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dsSta6Tm02Act01.Dispose();
            }
        }

        //[HttpGet]
        //[Route("CCPOSTDETReport(Assign={assign})")]
        ////[Route("api/[controller]/CCPOSTDETReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult CCPOSTDETReport([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtCCPOSTDET = new DataTable();
        //        dtCCPOSTDET = (DataTable)beforepostccRepository.CCPOSTDETReport(assign); ;
        //        var result = dtCCPOSTDET.AsEnumerable().Select(row =>
        //                            new CCPOSTDETReport
        //                            {
        //                                Emptype = ((string)row["emptype"]),
        //                                Assign = ((string)row["assign"]),
        //                                Costname = ((string)row["costname"]),
        //                                Hod = ((string)row["hod"]),
        //                                Desc1 = ((string)row["desc1"]),
        //                                Empno = ((string)row["empno"]),
        //                                Empname = ((string)row["empname"]),
        //                                Dol = !Convert.IsDBNull(row["dol"]) ? (DateTime?)row["dol"] : null
        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/CCPOSTDETRptDownload")]
        public async Task<ActionResult> CCPOSTDETRptDownload(string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtCCPOSTDET = new DataTable();
                dtCCPOSTDET = (DataTable)beforepostccRepository.CCPOSTDETReport(assign);

                if (dtCCPOSTDET.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} ");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtCCPOSTDET.Columns.Count;
                    Int32 rows = dtCCPOSTDET.Rows.Count;

                    ws.Range(1, 1, 1, 8).Merge();
                    ws.Range(1, 1, 1, 8).Value = "Timesheet Status";
                    ws.Range(1, 1, 1, 8).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 8).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 8).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 8).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 8).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtCCPOSTDET);

                    var rngTable = ws.Range("A3:H" + (rows + 3));
                    rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
                    rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
                    rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
                    rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
                    rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

                    //ws.Cell(rows + 2, 1).Value = "Grand Total";

                    //ws.Cell(rows + 2, cols).FormulaA1 = "=SUM(I4:I" + (rows + 1) + ")";
                    //ws.Range(rows + 2, 1, rows + 2, cols).Style.Font.Bold = true;

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
                    strFileName = "Posting_Status_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "Posting_Status_" + assign.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("MJEAMReport()")]
        ////[Route("api/[controller]/MJEAMReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult MJEAMReport(string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtMJAM = new DataTable();
        //        dtMJAM = (DataTable)beforepostccRepository.MJEAMReport(assign); ;
        //        var result = dtMJAM.AsEnumerable().Select(row =>
        //                            new MJEAMReport
        //                            {
        //                                yymm = ((string)row["yymm"]),
        //                                assign = ((string)row["assign"]),
        //                                projno = ((string)row["projno"]),
        //                                projname = ((string)row["projname"]),
        //                                activity = ((string)row["activity"]),
        //                                empno = ((string)row["empno"]),
        //                                empname = ((string)row["employee"]),
        //                                nhrs = ((decimal)row["nhrs"]),
        //                                ohrs = ((decimal)row["ohrs"])

        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/MJEAMRptDownload")]
        public async Task<ActionResult> MJEAMRptDownload(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtMJAM = new DataTable();
                dtMJAM = (DataTable)beforepostccRepository.MJEAMReport(yymm, assign);

                if (dtMJAM.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtMJAM.Columns.Count;
                    Int32 rows = dtMJAM.Rows.Count;

                    ws.Range(1, 1, 1, 9).Merge();
                    ws.Range(1, 1, 1, 9).Value = "STA6 Before Posting";
                    ws.Range(1, 1, 1, 9).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 9).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 9).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 9).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 9).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtMJAM);

                    ws.Cell(rows + 4, 1).Value = "Total";
                    ws.Cell(rows + 5, 1).Value = "Grand Total";
                    ws.Cell(rows + 4, cols - 1).FormulaA1 = "=SUM(H3:H" + (rows + 3) + ")";
                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(I3:I" + (rows + 3) + ")";
                    ws.Cell(rows + 5, cols).FormulaA1 = "=SUM(H3:I" + (rows + 3) + ")";

                    ws.Range(rows + 4, 1, rows + 5, cols).Style.Font.Bold = true;
                    ws.Range(rows + 4, 1, rows + 5, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

                    var rngTable = ws.Range("A3:I" + (rows + 5));
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
                    strFileName = "Job_Activity_Employee_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "Job_Activity_Employee_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("MHrsExceedReport(Assign={assign})")]
        ////[Route("api/[controller]/MHrsExceedReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult MHrsExceedReport([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtBooking = new DataTable();
        //        dtBooking = (DataTable)beforepostccRepository.MHrsExceedReport(assign);

        //        var result = dtBooking.AsEnumerable().Select(row =>
        //                            new MHrsExceedReport
        //                            {
        //                                Yymm = ((string)row["yymm"]),
        //                                Empno = ((string)row["empno"]),
        //                                Name = ((string)row["name"]),
        //                                Assign = ((string)row["assign"]),
        //                                Projno = ((string)row["projno"]),
        //                                Actual = ((decimal)row["actual"]),
        //                                OtHours = ((decimal)row["othours"]),
        //                                Tot = ((decimal)row["tot"])
        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/MHrsExceedRptDownload")]
        public async Task<ActionResult> MHrsExceedRptDownload(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtMHrsExceed = new DataTable();
                dtMHrsExceed = (DataTable)beforepostccRepository.MHrsExceedReport(yymm, assign);

                if (dtMHrsExceed.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtMHrsExceed.Columns.Count;
                    Int32 rows = dtMHrsExceed.Rows.Count;

                    ws.Range(1, 1, 1, 8).Merge();
                    ws.Range(1, 1, 1, 8).Value = "Manhour Booked on Sickness/Vacation";
                    ws.Range(1, 1, 1, 8).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 8).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 8).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 8).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 8).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtMHrsExceed);

                    var rngTable = ws.Range("A3:H" + (rows + 3));
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
                    strFileName = "MHRSEXCEED_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                    "MHRSEXCEED_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("LeaveReport(Assign={assign})")]
        ////[Route("api/[controller]/LeaveReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult LeaveReport([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtLeave = new DataTable();
        //        dtLeave = (DataTable)beforepostccRepository.LeaveReport(assign);

        //        var result = dtLeave.AsEnumerable().Select(row =>
        //                            new LeaveReport
        //                            {
        //                                Yymm = ((string)row["yymm"]),
        //                                Empno = ((string)row["empno"]),
        //                                Name = ((string)row["name"]),
        //                                Assign = ((string)row["assign"]),
        //                                Projno = ((string)row["projno"]),
        //                                D1 = !Convert.IsDBNull(row["d1"]) ? (Single?)row["d1"] : null,
        //                                D2 = !Convert.IsDBNull(row["d2"]) ? (Single?)row["d2"] : null,
        //                                D3 = !Convert.IsDBNull(row["d3"]) ? (Single?)row["d3"] : null,
        //                                D4 = !Convert.IsDBNull(row["d4"]) ? (Single?)row["d4"] : null,
        //                                D5 = !Convert.IsDBNull(row["d5"]) ? (Single?)row["d5"] : null,
        //                                D6 = !Convert.IsDBNull(row["d6"]) ? (Single?)row["d6"] : null,
        //                                D7 = !Convert.IsDBNull(row["d7"]) ? (Single?)row["d7"] : null,
        //                                D8 = !Convert.IsDBNull(row["d8"]) ? (Single?)row["d8"] : null,
        //                                D9 = !Convert.IsDBNull(row["d9"]) ? (Single?)row["d9"] : null,
        //                                D10 = !Convert.IsDBNull(row["d10"]) ? (Single?)row["d10"] : null,
        //                                D11 = !Convert.IsDBNull(row["d11"]) ? (Single?)row["d11"] : null,
        //                                D12 = !Convert.IsDBNull(row["d12"]) ? (Single?)row["d12"] : null,
        //                                D13 = !Convert.IsDBNull(row["d13"]) ? (Single?)row["d13"] : null,
        //                                D14 = !Convert.IsDBNull(row["d14"]) ? (Single?)row["d14"] : null,
        //                                D15 = !Convert.IsDBNull(row["d15"]) ? (Single?)row["d15"] : null,
        //                                D16 = !Convert.IsDBNull(row["d16"]) ? (Single?)row["d16"] : null,
        //                                D17 = !Convert.IsDBNull(row["d17"]) ? (Single?)row["d17"] : null,
        //                                D18 = !Convert.IsDBNull(row["d18"]) ? (Single?)row["d18"] : null,
        //                                D19 = !Convert.IsDBNull(row["d19"]) ? (Single?)row["d19"] : null,
        //                                D20 = !Convert.IsDBNull(row["d20"]) ? (Single?)row["d20"] : null,
        //                                D21 = !Convert.IsDBNull(row["d21"]) ? (Single?)row["d21"] : null,
        //                                D22 = !Convert.IsDBNull(row["d22"]) ? (Single?)row["d22"] : null,
        //                                D23 = !Convert.IsDBNull(row["d23"]) ? (Single?)row["d23"] : null,
        //                                D24 = !Convert.IsDBNull(row["d24"]) ? (Single?)row["d24"] : null,
        //                                D25 = !Convert.IsDBNull(row["d25"]) ? (Single?)row["d25"] : null,
        //                                D26 = !Convert.IsDBNull(row["d26"]) ? (Single?)row["d26"] : null,
        //                                D27 = !Convert.IsDBNull(row["d27"]) ? (Single?)row["d27"] : null,
        //                                D28 = !Convert.IsDBNull(row["d28"]) ? (Single?)row["d28"] : null,
        //                                D29 = !Convert.IsDBNull(row["d29"]) ? (Single?)row["d29"] : null,
        //                                D30 = !Convert.IsDBNull(row["d30"]) ? (Single?)row["d30"] : null,
        //                                D31 = !Convert.IsDBNull(row["d31"]) ? (Single?)row["d31"] : null
        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/LeaveRptDownload")]
        public async Task<ActionResult> LeaveRptDownload(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtLeave = new DataTable();
                dtLeave = (DataTable)beforepostccRepository.LeaveReport(yymm, assign);

                if (dtLeave.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dtLeave.Columns.Count;
                    Int32 rows = dtLeave.Rows.Count;

                    ws.Range(1, 1, 1, 39).Merge();
                    ws.Range(1, 1, 1, 39).Value = "Leave Report";
                    ws.Range(1, 1, 1, 39).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 39).Style.Font.FontColor = XLColor.White;
                    ws.Range(1, 1, 1, 39).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 39).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 36).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 39).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 39).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtLeave);
                    // ws.Cell(rows + 2, 1).Value = "Grand Total";
                    //for (int i = 6; i < 37; i++)
                    //{
                    //    ws.Cell(rows + 2, i).FormulaA1 = "=SUM(F2:AJ" + (rows + 1) + ")";
                    //}
                    ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;

                    var rngTable = ws.Range("A3:AJ" + (rows + 4));
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
                    strFileName = "LeaveReport_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                 "LeaveReport_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("OddTimesheetReport(Assign={assign})")]
        ////[Route("api/[controller]/OddTimesheetReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult OddTimesheetReport([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtOddTimesheet = new DataTable();
        //        dtOddTimesheet = (DataTable)beforepostccRepository.OddTimesheetReport(assign);

        //        var result = dtOddTimesheet.AsEnumerable().Select(row =>
        //                            new OddTimesheetReport
        //                            {
        //                                Parent = ((string)row["parent"]),
        //                                Yymm = ((string)row["yymm"]),
        //                                Empno = ((string)row["empno"]),
        //                                Name = ((string)row["name"]),
        //                                Assign = ((string)row["assign"]),
        //                                Projno = ((string)row["projno"]),
        //                                Wpcode = ((string)row["wpcode"]),
        //                                Activity = ((string)row["activity"]),
        //                                Total = !Convert.IsDBNull(row["total"]) ? (Single?)row["total"] : null
        //                            }).ToList();
        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/OddTimesheetRptDownload")]
        public async Task<ActionResult> OddTimesheetRptDownload(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtOddTimesheet = new DataTable();
                dtOddTimesheet = (DataTable)beforepostccRepository.OddTimesheetReport(yymm, assign);

                if (dtOddTimesheet.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }

                //object sumTotal;
                //sumTotal = dtOddTimesheet.Compute("Sum(Total)", string.Empty);

                //(from x in dtOddTimesheet.AsEnumerable()
                // group x by x.Field<string>("Parent") into grp
                // select new
                // {
                //     Key = grp.Key,
                //     Sum = grp.Sum(S => S.Field<Single>("Total"))
                // }).ToList().ForEach(T => dtOddTimesheet.Rows.Add(T.Key, "", "", "", "", "", "", "", T.Sum));

                //dtOddTimesheet = dtOddTimesheet.AsEnumerable().OrderBy(O => O.Field<string>("parent")).CopyToDataTable();

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("OddTimesheetReport");
                    Int32 cols = dtOddTimesheet.Columns.Count;
                    Int32 rows = dtOddTimesheet.Rows.Count;

                    ws.Range(1, 1, 1, 9).Merge();
                    ws.Range(1, 1, 1, 9).Value = "Monthly Odd Timesheet";
                    ws.Range(1, 1, 1, 9).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 9).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 9).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 9).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 9).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtOddTimesheet);

                    //ws.Cell(rows + 4, 1).Value = "Grand Total";
                    //ws.Cell(rows + 4, cols).FormulaA1 = sumTotal.ToString();// "=SUM(I2:I" + (rows + 3) + ")";
                    //ws.Range(rows + 4, 1, rows + 4, cols).Style.Font.Bold = true;
                    //ws.Range(rows + 4, 1, rows + 4, cols).Style.Fill.BackgroundColor = XLColor.LightYellow;

                    var rngTable = ws.Range("A3:I" + (rows + 4));
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
                    strFileName = "Od_Timesheet_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
          "Od_Timesheet_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("NotPostedTimesheetReport(Assign={assign})")]
        ////[Route("api/[controller]/NotPostedTimesheetReport")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public IActionResult NotPostedTimesheetReport([FromODataUri] string assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }
        //        DataTable dtNotPostedTimesheet = new DataTable();
        //        dtNotPostedTimesheet = (DataTable)beforepostccRepository.NotPostedTimesheetReport(assign);

        // var result = dtNotPostedTimesheet.AsEnumerable().Select(row => new
        // NotPostedTimesheetReport { Yymm = ((string)row["yymm"]), Empno = ((string)row["empno"]),
        // Name = ((string)row["name"]), Parent = ((string)row["parent"]), Assign =
        // ((string)row["assign"]), Locked = ((string)row["locked"]), Posted =
        // ((string)row["posted"]), Company = ((string)row["company"]), Remarks =
        // ((string)row["remark"]), Hrs = ((Single)row["tot_nhr"]), OTHrs = ((Single)row["tot_ohr"]) }).ToList();

        //        if (result == null)
        //        {
        //            return NotFound();
        //        }
        //        return Ok(result.AsEnumerable());
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/NotPostedTimesheetRptDownload")]
        public async Task<ActionResult> NotPostedTimesheetRptDownload(string yymm, string assign)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(assign) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtNotPostedTimesheet = new DataTable();
                dtNotPostedTimesheet = (DataTable)beforepostccRepository.NotPostedTimesheetReport(yymm, assign);

                if (dtNotPostedTimesheet.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for assign : {assign} , yymm : {yymm}");
                }

                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("NotPostedTimesheetReport");
                    Int32 cols = dtNotPostedTimesheet.Columns.Count;
                    Int32 rows = dtNotPostedTimesheet.Rows.Count;

                    ws.Range(1, 1, 1, 12).Merge();
                    ws.Range(1, 1, 1, 12).Value = "Monthly Not Posted Timesheet";
                    ws.Range(1, 1, 1, 12).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 12).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 12).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 12).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 12).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtNotPostedTimesheet);

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
                    strFileName = "Not_Posted_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
      "Not_Posted_" + yymm.ToString() + "_" + assign.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        //[HttpGet]
        //[Route("ClosedTestReport()")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public async Task<ActionResult> ClosedTestReport()
        //{
        //    string inputFile = @"C:\\RAPReporting\\OfficeTemplate.xlsx";
        //    try
        //    {
        //        byte[] m_Bytes = null;
        //        using (var template = new XLTemplate(inputFile))
        //        {
        //            DataTable dtAuditor = new DataTable();
        //            dtAuditor = (DataTable)beforepostccRepository.AuditorReport();
        //            List<AuditorItem> auditoritems = new List<AuditorItem>();
        //            foreach (DataRow rr in dtAuditor.Rows)
        //            {
        //                auditoritems.Add(new AuditorItem(
        //                                Convert.ToInt32(dtAuditor.Rows.IndexOf(rr)) + 1,
        //                                rr["Company"].ToString(),
        //                                rr["Tmagrp"].ToString(),
        //                                rr["Emptype"].ToString(),
        //                                rr["Location"].ToString(),
        //                                rr["Yymm"].ToString(),
        //                                rr["Costcode"].ToString(),
        //                                rr["Projno"].ToString(),
        //                                rr["Name"].ToString(),
        //                                Convert.ToDecimal(rr["Hours"]),
        //                                Convert.ToDecimal(rr["Othours"]),
        //                                Convert.ToDecimal(rr["Tothours"])
        //                            ));
        //            }

        // template.AddVariable(new AuditorItemReport("X123445", auditoritems)); template.Generate();

        // using (var ms = new MemoryStream()) { template.SaveAs(ms); byte[] buffer =
        // ms.GetBuffer(); long length = ms.Length; m_Bytes = ms.ToArray(); }

        // var t = Task.Run(() => { string strFileName = string.Empty; strFileName =
        // "ClosedTestReport.xlsx"; return this.File(
        // fileContents: m_Bytes,
        // contentType: oAppSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        // fileDownloadName: strFileName ); }); return await t; } } catch (Exception e) { throw e; }

        //}

        //[HttpGet]
        //[Route("SoldItemReport()")]
        //[EnableQuery(AllowedQueryOptions = AllowedQueryOptions.All)]
        //public async Task<ActionResult> SoldItemReport()
        //{
        //    string inputFile = @"C:\\RAPReporting\\report_template_sold_items.xlsx";
        //    try
        //    {
        //        byte[] m_Bytes = null;
        //        using (var template = new XLTemplate(inputFile))
        //        {
        //            string fromDateStr = DateTime.Now.AddYears(-2).ToString("yyyy-MM-dd");

        // template.AddVariable(new SoldItemReport("Greatest Company on Earth", "Booming Branch",
        // "+1-239-234-969", fromDateStr, DateTime.Now.ToString("yyyy-MM-dd"), GetDummyItems()));

        // template.Generate(); using (var ms = new MemoryStream()) { template.SaveAs(ms); byte[]
        // buffer = ms.GetBuffer(); long length = ms.Length; m_Bytes = ms.ToArray(); }

        //            var t = Task.Run(() =>
        //            {
        //                string strFileName = string.Empty;
        //                strFileName = "SoldItemReport.xlsx";
        //                return this.File(
        //                               fileContents: m_Bytes,
        //                               contentType: oAppSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        //                               fileDownloadName: strFileName
        //                           );
        //            });
        //            return await t;
        //        }
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        //private Random _orderCountRandomizer = new Random();
        //private Random _priceRandomizer = new Random();

        //private List<SoldItem> GetDummyItems()
        //{
        //    List<SoldItem> list = new List<SoldItem>();
        //    for (int i = 1; i < 51; i++)
        //        list.Add(new SoldItem(
        //            i,
        //            "Item " + i,
        //            (_orderCountRandomizer.Next() * i) % (100 * i),
        //            _priceRandomizer.Next()));
        //    return list;
        //}

        [HttpGet]
        [Route("api/rap/rpt/MJM_All_RptDownload")]
        public async Task<ActionResult> MJM_All_RptDownload(string yymm, string assign)
        {
            DataTable tb = new DataTable();
            DataTable tb_mjem = new DataTable();
            DataTable tb_mjam = new DataTable();

            try
            {
                if (assign.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\BeforePost\Mjm.xlsx");

                tb = (DataTable)beforepostccRepository.MJM_All_RptDownload(yymm, assign);

                tb_mjem = tb.Copy();
                tb_mjam = tb.Copy();

                //tb_mjem.Columns.Remove("assign_name");
                //tb_mjem.Columns.Remove("assign_detail");
                //tb_mjem.Columns.Remove("project_name");
                //tb_mjem.Columns.Remove("employee_detail");
                //tb_mjem.Columns.Remove("activity_name");
                //tb_mjem.Columns.Remove("activity_details");
                //tb_mjem.Columns.Remove("wpcode");
                tb_mjem.AcceptChanges();
                tb_mjam.AcceptChanges();
                //DataWorksheet
                var wb = template.Workbook;                //var ws = wb.Worksheet("DataWorksheet");

                //ws.Cell("M2").Value = DateTime.Now.ToString("dd-MMM-yyyy");

                //ws.Cell("M4").Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                //ws.Cell("E6").Value = "'" + assign;

                //DataWorksheet
                template.AddVariable("mjm_datatable", tb);
                template.AddVariable("mjem_datatable", tb_mjem);
                template.AddVariable("mjam_datatable", tb_mjam);

                template.Generate();

                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                string strFileName = string.Empty;
                strFileName = "Mjm_CostCode_" + assign.Trim() + "_YYmm_" + yymm.Trim().Substring(2) + ".xlsx";
                var t = Task.Run(() =>
                {
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", strFileName);
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                tb.Dispose();
            }
        }
    }
}