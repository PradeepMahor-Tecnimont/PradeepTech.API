using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
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
    public class AfterPostCCController : ControllerBase
    {
        private IOptions<AppSettings> appSettings;
        private IAfterPostCostRepository afterPostCostRepository;
        private XLColor customColor = XLColor.FromArgb(r: 79, g: 129, b: 189);

        public AfterPostCCController(IAfterPostCostRepository _IAfterPostCostRepository, IOptions<AppSettings> _settings)
        {
            appSettings = _settings;
            afterPostCostRepository = _IAfterPostCostRepository;
        }

        [HttpGet]
        [Route("api/rap/rpt/CostCentre_PlanRep1_Download")]
        public async Task<ActionResult> CostCentre_PlanRep1_Download(string CostCode, string yymm)
        {
            try
            {
                CostCode = CostCode.Trim();
                yymm = yymm.Trim();

                if (string.IsNullOrWhiteSpace(CostCode) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (CostCode.Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostCC\CostCentre_PlanRep1.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostCostRepository.CostCentre_PlanRep1(CostCode, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} , yymm : {yymm}");
                }

                string Title = "Project - Hours Costcode & Activity  Wise";

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
                    strFileName = Title + "_" + CostCode.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/CostCentre_PlanRep2_Download")]
        public async Task<ActionResult> Cost_PlanRep2_Download(string CostCode, string yymm)
        {
            try
            {
                CostCode = CostCode.Trim();
                yymm = yymm.Trim();

                if (string.IsNullOrWhiteSpace(CostCode) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (CostCode.Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostCC\CostCentre_PlanRep2.xlsx";

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostCostRepository.CostCentre_PlanRep2(CostCode, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} , yymm : {yymm}");
                }

                string Title = "Projectwise Costcode Activity wise hours for the various Period";

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
                    strFileName = Title + "_" + CostCode.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/CostCentre_Combine_Download")]
        public async Task<ActionResult> CostCentre_Combine_Download(string CostCode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(CostCode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostCostRepository.CostCentre_Cost_combine(CostCode); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} ");
                }

                string Title = "Project Costcode Wise Manhours from begining of project ";

                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostCC\CostCentre_Cost_combine.xlsx";

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
                    strFileName = Title + "_" + CostCode.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: "application/vnd.closedxmlformats-officedocument.spreadsheetml.sheet",
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + CostCode.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/CostCentre_CostOT_Combine_Download")]
        public async Task<ActionResult> CostCentre_CostOT_Combine_Download(string CostCode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(CostCode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostCostRepository.CostCentre_CostOT_combine(CostCode); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} ");
                }

                string Title = "Project Costcode Wise Manhours from begining of project (OT) ";

                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostCC\CostCentre_CostOT_combine.xlsx";

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
                    strFileName = Title + "_" + CostCode.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: "application/vnd.closedxmlformats-officedocument.spreadsheetml.sheet",
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/CostCentre_hrs_OtBreak_Download")]
        public async Task<ActionResult> CostCentre_hrs_OtBreak_Download(string CostCode, string yymm)
        {
            try
            {
                CostCode = CostCode.Trim();
                yymm = yymm.Trim();

                if (string.IsNullOrWhiteSpace(CostCode) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (CostCode.Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostCC\CostCentre_Projhrs_OtBreak.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostCostRepository.CostCentre_hrs_OtBreak(CostCode, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} , yymm : {yymm}");
                }

                string Title = "Project Costcode Employee Manhours with Overtime Breakup";

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
                    strFileName = Title + "_" + CostCode.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                    contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/CostCentre_hrs_OtCrossTab_Download")]
        public async Task<ActionResult> CostCentre_hrs_OtCrossTab_Download(string CostCode, string yymm)
        {
            try
            {
                CostCode = CostCode.Trim();
                yymm = yymm.Trim();

                if (string.IsNullOrWhiteSpace(CostCode) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (CostCode.Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostCostRepository.CostCentre_hrs_OtCrossTab(CostCode, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} , yymm : {yymm}");
                }

                string Title = "Project Costcode Employee Wise Manhours with Overtime BreakUp (Cross Tab)";

                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostCC\CostCentre_Projhrs_OtCrossTab.xlsx";

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
                    strFileName = Title + "_" + CostCode.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                    contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Project_Manhours_Download")]
        public async Task<ActionResult> Project_Manhours_Download(string yymm, string projno, string costcode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(costcode))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (projno.Trim().Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }
                else if (costcode.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dtAuditor = new DataTable();
                dtAuditor = (DataTable)afterPostCostRepository.ProjectwiseManhoursList(yymm, projno, costcode);
                if (dtAuditor.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for  Project : {projno}");
                }
                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet wsReport = wb.Worksheets.Add("Report");

                    IXLWorksheet ws = wb.Worksheets.Add("Data");
                    Int32 cols = dtAuditor.Columns.Count;
                    Int32 rows = dtAuditor.Rows.Count;

                    ws.Range(1, 1, 1, 11).Merge();
                    ws.Range(1, 1, 1, 11).Value = "Projectwise Employeewise Manhours Report";
                    ws.Range(1, 1, 1, 11).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 11).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 11).Style.Font.FontColor = XLColor.White;
                    //ws.Range(1, 1, 1, 11).Style.Fill.BackgroundColor = XLColor.CornflowerBlue;
                    ws.Range(1, 1, 1, 11).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dtAuditor);
                    //var cells = ws.Range(2, cols, rows + 1, cols).Cells().ToList();
                    //var sum = cells.Sum(xlCell => (double)xlCell.Value);
                    //ws.Cell(rows + 2, cols).Value = sum;
                    ws.Cell(rows + 4, 1).Value = "Grand Total";
                    ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(K2:K" + (rows + 3) + ")";
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

                    IXLPivotTable xlPvTable = wsReport.PivotTables.Add("PivotTable", wsReport.Cell(1, 1), ws.Table("Table1"));

                    xlPvTable.RowLabels.Add("PROJNO");
                    xlPvTable.RowLabels.Add("EMPNO").SortType = XLPivotSortType.Ascending;
                    xlPvTable.RowLabels.Add("WPCODE");
                    xlPvTable.ColumnLabels.Add("YYMM");
                    xlPvTable.Values.Add("TOTALHRS");
                    xlPvTable.ClassicPivotTableLayout = true;

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
                    strFileName = "ProjectwiseEmpwiseManhours_" + yymm.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "ProjectwiseEmpwiseManhours_" + projno.ToString() + "_" + yymm.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}