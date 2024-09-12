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
    public class MasterController : ControllerBase
    {
        private IOptions<AppSettings> appSettings;
        private IMasterRepository MasterRepositorym;
        private XLColor customColor = XLColor.FromArgb(r: 79, g: 129, b: 189);

        public MasterController(IMasterRepository _MasterRepositorym, IOptions<AppSettings> _settings)
        {
            appSettings = _settings;
            MasterRepositorym = _MasterRepositorym;
        }

        [HttpGet]
        [Route("api/rap/rpt/Master/LISTACT")]
        public async Task<ActionResult> LISTACT(string CostCode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(CostCode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                CostCode = CostCode.Trim();

                if (CostCode.Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Master\LISTACT.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)MasterRepositorym.LISTACT(CostCode); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} ");
                }

                string Title = "Activity Master";

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
                Response.Headers.Add("xl_file_name",
                            Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Master/LISTEMP")]
        public async Task<ActionResult> LISTEMP(string CostCode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(CostCode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                CostCode = CostCode.Trim();

                if (CostCode.Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Master\LISTEMP.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)MasterRepositorym.LISTEMP(CostCode); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} ");
                }

                string Title = "Emplyee Master";

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
                Response.Headers.Add("xl_file_name",
                            Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Master/LISTEMP_Parent")]
        public async Task<ActionResult> LISTEMP_Parent(string CostCode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(CostCode))
                {
                    throw new RAPInvalidParameter("Parameter value is invalid, please check");
                }

                byte[] m_Bytes = null;
                DataTable dt = new DataTable();

                dt = (DataTable)(DataTable)MasterRepositorym.LISTEMP_Parent(CostCode); //Get DataTable;

                if (dt.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for  Parent : {CostCode}");
                }
                using (XLWorkbook wb = new XLWorkbook())
                {
                    IXLWorksheet ws = wb.Worksheets.Add("Report");
                    Int32 cols = dt.Columns.Count;
                    Int32 rows = dt.Rows.Count;

                    ws.Range(1, 1, 1, 8).Merge();
                    ws.Range(1, 1, 1, 8).Value = "Employee List Parent Report";
                    ws.Range(1, 1, 1, 8).Style.Font.FontSize = 14;
                    ws.Range(1, 1, 1, 8).Style.Font.Bold = true;
                    ws.Range(1, 1, 1, 8).Style.Font.FontColor = XLColor.White;
                    ws.Range(1, 1, 1, 8).Style.Fill.BackgroundColor = customColor;
                    ws.Range(1, 1, 1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    ws.Cell(3, 1).InsertTable(dt);

                    //ws.Cell(rows + 4, 1).Value = "Grand Total";
                    //ws.Cell(rows + 4, cols).FormulaA1 = "=SUM(N2:N" + (rows + 3) + ")";
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
                    strFileName = "EmpListParentReport_" + CostCode.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", "EmpListParentReport_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Master/PROJACT")]
        public async Task<ActionResult> PROJACT(string CostCode)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(CostCode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                CostCode = CostCode.Trim();

                if (CostCode.Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Master\PROJACT.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)MasterRepositorym.PROJACT(CostCode); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for CostCode : {CostCode} ");
                }

                string Title = "Project Activity";

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

                Response.Headers.Add("xl_file_name",
                           Title + "_" + CostCode.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Master/ListActProj")]
        public async Task<ActionResult> ListActProj(string Projno)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(Projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                Projno = Projno.Trim();

                if (Projno.Length != 5 && Projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Master\ListActProj.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)MasterRepositorym.ListActProj(Projno); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for Projno : {Projno} ");
                }

                string Title = "Project Activity";

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
                    strFileName = Title + "_" + Projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });

                Response.Headers.Add("xl_file_name",
                           Title + "_" + Projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Master/TLP_Codes_Master")]
        public async Task<ActionResult> TLP_Codes_Master()
        {
            try
            {
                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Master\TLP_Codes_Master.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)MasterRepositorym.TLP_Codes_Master(); //Get DataTable

                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists ");
                }

                string Title = "TLP Codes Master";

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
                    strFileName = Title + "_" + ".xlsx";
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
    }
}