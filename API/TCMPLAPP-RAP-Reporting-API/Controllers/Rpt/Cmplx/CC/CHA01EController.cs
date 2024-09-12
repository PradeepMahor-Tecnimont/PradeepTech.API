using ClosedXML.Excel;
using ClosedXML.Report;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC;
using RapReportingApi.Repositories.Rpt.Cmplx.CC;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;
using static RapReportingApi.Controllers.Rpt.ExcelHelper;
using Path = System.IO.Path;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace RapReportingApi.Controllers.Rpt.Cmplx.CC
{
    [Authorize]
    public class CHA01EController : ControllerBase
    {
        private ICHA01ERepository _cha01eRepository;
        private IOptions<AppSettings> appSettings;

        //private string strConsoleAppPath = @"C:\tfs\RAPReportingConsole\RAPReportingConsole\bin\Release\RAPReportingConsole.exe";
        private string strConsoleAppPath = @"C:\Program Files (x86)\RAPReportingConsole\RAPReportingConsole.exe";

        public CHA01EController(ICHA01ERepository _cha01eRepository, IOptions<AppSettings> _appSettings)
        {
            this._cha01eRepository = _cha01eRepository;
            this.appSettings = _appSettings;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/GetCHA01EDataOld")]
        public async Task<ActionResult> GetCHA01EDataOld(string costcode, string yymm, string yearmode, string reportMode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                        "\\Cmplx\\cc\\CHA1E.xlsm";

            try
            {
                if (string.IsNullOrWhiteSpace(costcode) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (costcode.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    var ws = wb.Worksheet("CHA1E");

                    ds = (DataSet)_cha01eRepository.CHA01EData(costcode, yymm, yearmode, reportMode, Request.Headers["activeYear"].ToString());

                    foreach (DataRow rr in ds.Tables["genTable"].Rows)
                    {
                        ws.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr["changed_nemps"].ToString()) == 0)
                        {
                            ws.Cell(7, 5).Value = Convert.ToInt32("0" + rr["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws.Cell(7, 5).Value = Convert.ToInt32("0" + rr["changed_nemps"].ToString());     // E7
                        }
                        ws.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(8, 5).Value = Convert.ToInt32("0" + rr["noofemps"].ToString());         // E8
                        ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr["noofcons"].ToString()) > 0)
                        {
                            ws.Cell(8, 7).Value = "Includes " + rr["noofcons"].ToString() + " Consultants ";
                            ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws.Cell(6, 18).Value = rr["abbr"].ToString().ToString();                        // R6
                        ws.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(7, 18).Value = rr["name"].ToString().ToString();                        // R7
                        ws.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(2, 22).Value = "'" + rr["pdate"].ToString();                            // U2
                        ws.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata = ws.Cell(9, 4).InsertTable(ds.Tables["alldataTable"].AsEnumerable());
                    tAlldata.Theme = XLTableTheme.None;
                    tAlldata.ShowHeaderRow = false;
                    tAlldata.ShowAutoFilter = false;

                    var rangeClear = ws.Range(9, 4, 16, 4);
                    rangeClear.Clear();
                    rangeClear.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata = ws.Range(9, 5, 16, 23);
                    rngdata.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata.Style.NumberFormat.Format = "0";
                    rngdata.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader = ws.Range(9, 4, 9, 23);
                    rngheader.Style.Font.Bold = true;
                    rngheader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc in ds.Tables["colsTable"].Columns)
                    {
                        Int32 col = ds.Tables["colsTable"].Columns.IndexOf(cc);
                        string strVal = ds.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                        ws.Cell(9, col + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws.Cell(9, col + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project", ds.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future", ds.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract", ds.Tables["subcontractTable"]);
                    tmlt.Generate();

                    Int32 colProject = ds.Tables["projectTable"].Rows.Count;
                    Int32 colFuture = ds.Tables["futureTable"].Rows.Count;
                    Int32 colSubcontract = ds.Tables["subcontractTable"].Rows.Count;

                    var rngproject = ws.Range(23, 1, (colProject + 23), 22);
                    rngproject.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture = ws.Range((colProject + 38), 1, (colFuture + colProject + 38), 22);
                    rngfuture.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    wb.Worksheet("CHA1_SimA").Delete();
                    wb.Worksheet("CHA1_SimB").Delete();
                    wb.Worksheet("CHA1_SimC").Delete();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";
                    var t = Task.Run(() =>
                    {
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    Response.Headers.Add("xl_file_name", strFileName);
                    return await t;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/GetCHA01EData")]
        public async Task<ActionResult> GetCHA01EData(string costcode, string yymm, string yearmode, string reportMode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                        "\\Cmplx\\cc\\CHA1E.xlsx";

            Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition = new();
            Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition = new();

            int startColProjects;
            int startRowProjects;
            int endColProjects;
            int endRowProjects;

            //Rpt.ExcelHelper.ExcelCoOrdinate startPositionProjects = new();
            //Rpt.ExcelHelper.ExcelCoOrdinate endPositionProjects = new();

            IList<Rpt.ExcelHelper.WorkbookCharts> workbookCharts = new List<Rpt.ExcelHelper.WorkbookCharts>();

            try
            {
                if (string.IsNullOrWhiteSpace(costcode) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (costcode.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                //byte[] m_Bytes = null;
                DataSet ds = new DataSet();
                string strFileName = string.Empty;
                strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                //string strFilePathName = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value), appSettings.Value.RAPAppSettings.RAPTempRepository, strFileName);
                string strFilePathName = Path.Combine(Common.CustomFunctions.GetTempRepository(appSettings.Value), strFileName);
                string worksheetName = "CHA1E";
                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    var ws = wb.Worksheet(worksheetName);

                    ds = (DataSet)_cha01eRepository.CHA01EData(costcode, yymm, yearmode, reportMode, Request.Headers["activeYear"].ToString());

                    foreach (DataRow rr in ds.Tables["genTable"].Rows)
                    {
                        ws.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr["changed_nemps"].ToString()) == 0)
                        {
                            ws.Cell(7, 5).Value = Convert.ToInt32("0" + rr["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws.Cell(7, 5).Value = Convert.ToInt32("0" + rr["changed_nemps"].ToString());     // E7
                        }
                        ws.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(8, 5).Value = Convert.ToInt32("0" + rr["noofemps"].ToString());         // E8
                        ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr["noofcons"].ToString()) > 0)
                        {
                            ws.Cell(8, 7).Value = "Includes " + rr["noofcons"].ToString() + " Consultants ";
                            ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws.Cell(6, 18).Value = rr["abbr"].ToString().ToString();                        // R6
                        ws.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(7, 18).Value = rr["name"].ToString().ToString();                        // R7
                        ws.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(2, 22).Value = "'" + rr["pdate"].ToString();                            // U2
                        ws.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    if (reportMode == "COMBINED")
                    {
                        ws.Cell(3, 10).Value = "M + D";
                        foreach (DataRow rr_a in ds.Tables["genOtherTable"].Rows)
                        {
                            ws.Cell(6, 5).Value = ws.Cell(6, 5).Value + " + " + rr_a["costcode"];                                // E6
                            ws.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_a["changed_nemps"].ToString()) == 0)
                            {
                                ws.Cell(7, 9).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());     // E7
                            }
                            else
                            {
                                ws.Cell(7, 9).Value = Convert.ToInt32("0" + rr_a["changed_nemps"].ToString());     // E7
                            }
                            ws.Cell(7, 7).Value = "Delhi Office Emps";
                            ws.Cell(7, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(8, 7).Value = "Delhi Office Emps";
                            ws.Cell(8, 9).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());         // E8
                            ws.Cell(8, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_a["noofcons"].ToString()) > 0)
                            {
                                ws.Cell(8, 10).Value = "Includes " + rr_a["noofcons"].ToString() + " Consultants ";
                                ws.Cell(8, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            }
                        }
                    }

                    var tAlldata = ws.Cell(10, 4).InsertData(ds.Tables["alldataTable"].AsEnumerable());
                    //tAlldata.Theme = XLTableTheme.None;
                    //tAlldata.ShowHeaderRow = false;
                    //tAlldata.ShowAutoFilter = false;

                    var rangeClear = ws.Range(9, 4, 16, 4);
                    rangeClear.Clear();
                    rangeClear.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata = ws.Range(9, 5, 16, 23);
                    rngdata.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata.Style.NumberFormat.Format = "0";
                    rngdata.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader = ws.Range(9, 4, 9, 23);
                    rngheader.Style.Font.Bold = true;
                    rngheader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc in ds.Tables["colsTable"].Columns)
                    {
                        Int32 col = ds.Tables["colsTable"].Columns.IndexOf(cc);
                        string strVal = ds.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                        ws.Cell(9, col + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws.Cell(9, col + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project", ds.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future", ds.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract", ds.Tables["subcontractTable"]);
                    tmlt.Generate();

                    Int32 colProject = ds.Tables["projectTable"].Rows.Count;
                    Int32 colFuture = ds.Tables["futureTable"].Rows.Count;
                    Int32 colSubcontract = ds.Tables["subcontractTable"].Rows.Count;

                    var rngproject = ws.Range(23, 1, (colProject + 23), 22);
                    rngproject.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture = ws.Range((colProject + 38), 1, (colFuture + colProject + 38), 22);
                    rngfuture.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    // Color active and future projects seperately

                    startColProjects = ws.NamedRange("Cha1e_Future_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetColumn().ColumnNumber();
                    startRowProjects = ws.NamedRange("Cha1e_Future_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();

                    endColProjects = ws.NamedRange("Cha1e_Future_tpl").Ranges.FirstOrDefault().LastCell().WorksheetColumn().ColumnNumber();
                    endRowProjects = ws.NamedRange("Cha1e_Future_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();

                    int counterRow = startRowProjects - 1;
                    //bool colourText = true;
                    //while (colourText)
                    //{
                    //    counterRow++;
                    //    if (ws.Cell(counterRow, endColProjects).Value.ToString() == "0")
                    //    {
                    //        colourText = false;
                    //        break;
                    //    }                        
                    //}

                    //if(counterRow > startRowProjects)
                    //{
                    //    counterRow--;
                    //    ws.Range("A" + startRowProjects, "W" + counterRow).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);                       
                    //}

                    int rowCount = counterRow;
                    while (rowCount <= endRowProjects)
                    {
                        counterRow++;

                        if (ws.Cell(counterRow, endColProjects).Value.ToString() == "1")
                        {
                            ws.Range("A" + counterRow, "W" + counterRow).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                        }
                        rowCount++;
                    }


                    var rng_active_project_total = ws.NamedRange("cha1e_active_project_total").Ranges.FirstOrDefault();
                    rng_active_project_total.Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);

                    // Set bottom bordes for header

                    var rngheader_project = ws.NamedRange("cha1e_projects_header").Ranges.FirstOrDefault();
                    rngheader_project.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    var rngheader_exptproject = ws.NamedRange("cha1e_exptproject_header").Ranges.FirstOrDefault();
                    rngheader_exptproject.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    var rngheader_cost = ws.NamedRange("cha1e_cost_header").Ranges.FirstOrDefault();
                    rngheader_cost.Style.Border.BottomBorder = XLBorderStyleValues.Medium;

                    var rngheader_costcenter = ws.NamedRange("cha1e_costcenter_header").Ranges.FirstOrDefault();
                    rngheader_costcenter.Style.Border.BottomBorder = XLBorderStyleValues.Medium;

                    // Delete unused sheets

                    wb.Worksheet("CHA1_SimA").Delete();
                    wb.Worksheet("CHA1_SimB").Delete();
                    wb.Worksheet("CHA1_SimC").Delete();

                    wb.Worksheet("Help").Select();                    

                    // Remove unused named ranges
                    foreach (var rng in wb.NamedRanges)
                    {
                        if (!rng.IsValid)
                            wb.NamedRanges.Delete(rng.Name);
                    }

                    // Chart plotting
                    chartFromPosition = GetChartPositionCoOrdinates(ws, "Cha1e_chart_location_start");
                    chartFromPosition.Col = chartFromPosition.Col > 0 ? chartFromPosition.Col - 1 : chartFromPosition.Col;
                    chartFromPosition.Row = chartFromPosition.Row > 0 ? chartFromPosition.Row - 1 : chartFromPosition.Row;
                    chartToPosition = GetChartPositionCoOrdinates(ws, "Cha1e_chart_location_end");
                    workbookCharts.Add(new ExcelHelper.WorkbookCharts { SheetName = worksheetName, FromPosition = chartFromPosition, ToPosition = chartToPosition });

                    wb.SaveAs(strFilePathName);
                }
                Rpt.ExcelHelper.PositionCharts(strFilePathName,workbookCharts);

                var t = Task.Run(() =>
                {
                    return this.File(fileContents: System.IO.File.ReadAllBytes(strFilePathName),
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
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/GetCHA01ESimDataOld")]
        public async Task<ActionResult> GetCHA01ESimDataOld(string costcode, string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                        "\\Cmplx\\cc\\CHA1E.xlsm";

            try
            {
                if (string.IsNullOrWhiteSpace(costcode) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (costcode.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataSet ds_a = new DataSet();
                DataSet ds_b = new DataSet();
                DataSet ds_c = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    // ====================== Simulation A =======================================================

                    var ws_a = wb.Worksheet("CHA1_SimA");

                    ds_a = (DataSet)_cha01eRepository.CHA01ESimData(costcode, yymm, yearmode, "A", null, Request.Headers["activeYear"].ToString());

                    foreach (DataRow rr_a in ds_a.Tables["genTable"].Rows)
                    {
                        ws_a.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws_a.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_a["changed_nemps"].ToString()) == 0)
                        {
                            ws_a.Cell(7, 5).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_a.Cell(7, 5).Value = Convert.ToInt32("0" + rr_a["changed_nemps"].ToString());     // E7
                        }
                        ws_a.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(8, 5).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());         // E8
                        ws_a.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_a["noofcons"].ToString()) > 0)
                        {
                            ws_a.Cell(8, 7).Value = "Includes " + rr_a["noofcons"].ToString() + " Consultants ";
                            ws_a.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_a.Cell(6, 18).Value = rr_a["abbr"].ToString().ToString();                        // R6
                        ws_a.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(7, 18).Value = rr_a["name"].ToString().ToString();                        // R7
                        ws_a.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(2, 22).Value = "'" + rr_a["pdate"].ToString();                            // U2
                        ws_a.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_a.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_a.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_a.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_a.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata_a = ws_a.Cell(9, 4).InsertTable(ds_a.Tables["alldataTable"].AsEnumerable());
                    tAlldata_a.Theme = XLTableTheme.None;
                    tAlldata_a.ShowHeaderRow = false;
                    tAlldata_a.ShowAutoFilter = false;

                    var rangeClear_a = ws_a.Range(9, 4, 16, 4);
                    rangeClear_a.Clear();
                    rangeClear_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata_a = ws_a.Range(9, 5, 16, 23);
                    rngdata_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata_a.Style.NumberFormat.Format = "0";
                    rngdata_a.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader_a = ws_a.Range(9, 4, 9, 23);
                    rngheader_a.Style.Font.Bold = true;
                    rngheader_a.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader_a.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_a.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc_a in ds_a.Tables["colsTable"].Columns)
                    {
                        Int32 col_a = ds_a.Tables["colsTable"].Columns.IndexOf(cc_a);
                        string strVal_a = ds_a.Tables["colsTable"].Rows[0][cc_a.ColumnName.ToString()].ToString();
                        ws_a.Cell(9, col_a + 5).Value = "'" + strVal_a.Substring(0, 4) + "/" + strVal_a.Substring(4, 2);
                        ws_a.Cell(9, col_a + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds_a.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project_a", ds_a.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future_a", ds_a.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract_a", ds_a.Tables["subcontractTable"]);

                    Int32 colProject_a = ds_a.Tables["projectTable"].Rows.Count;
                    Int32 colFuture_a = ds_a.Tables["futureTable"].Rows.Count;
                    var rngproject_a = ws_a.Range(23, 1, (colProject_a + 23), 22);
                    rngproject_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture_a = ws_a.Range((colProject_a + 38), 1, (colFuture_a + colProject_a + 38), 22);
                    rngfuture_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    // ====================== Simulation B =======================================================

                    var ws_b = wb.Worksheet("CHA1_SimB");

                    ds_b = (DataSet)_cha01eRepository.CHA01ESimData(costcode, yymm, yearmode, "B", null, Request.Headers["activeYear"].ToString());

                    foreach (DataRow rr_b in ds_b.Tables["genTable"].Rows)
                    {
                        ws_b.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws_b.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_b["changed_nemps"].ToString()) == 0)
                        {
                            ws_b.Cell(7, 5).Value = Convert.ToInt32("0" + rr_b["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_b.Cell(7, 5).Value = Convert.ToInt32("0" + rr_b["changed_nemps"].ToString());     // E7
                        }
                        ws_b.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(8, 5).Value = Convert.ToInt32("0" + rr_b["noofemps"].ToString());         // E8
                        ws_b.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_b["noofcons"].ToString()) > 0)
                        {
                            ws_b.Cell(8, 7).Value = "Includes " + rr_b["noofcons"].ToString() + " Consultants ";
                            ws_b.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_b.Cell(6, 18).Value = rr_b["abbr"].ToString().ToString();                        // R6
                        ws_b.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(7, 18).Value = rr_b["name"].ToString().ToString();                        // R7
                        ws_b.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(2, 22).Value = "'" + rr_b["pdate"].ToString();                            // U2
                        ws_b.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_b.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_b.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_b.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_b.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata_b = ws_b.Cell(9, 4).InsertTable(ds_b.Tables["alldataTable"].AsEnumerable());
                    tAlldata_b.Theme = XLTableTheme.None;
                    tAlldata_b.ShowHeaderRow = false;
                    tAlldata_b.ShowAutoFilter = false;

                    var rangeClear_b = ws_b.Range(9, 4, 16, 4);
                    rangeClear_b.Clear();
                    rangeClear_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata_b = ws_b.Range(9, 5, 16, 23);
                    rngdata_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata_b.Style.NumberFormat.Format = "0";
                    rngdata_b.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader_b = ws_b.Range(9, 4, 9, 23);
                    rngheader_b.Style.Font.Bold = true;
                    rngheader_b.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader_b.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_b.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc_b in ds_b.Tables["colsTable"].Columns)
                    {
                        Int32 col_b = ds_b.Tables["colsTable"].Columns.IndexOf(cc_b);
                        string strVal_b = ds_b.Tables["colsTable"].Rows[0][cc_b.ColumnName.ToString()].ToString();
                        ws_b.Cell(9, col_b + 5).Value = "'" + strVal_b.Substring(0, 4) + "/" + strVal_b.Substring(4, 2);
                        ws_b.Cell(9, col_b + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds_b.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project_b", ds_b.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future_b", ds_b.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract_b", ds_b.Tables["subcontractTable"]);

                    Int32 colProject_b = ds_b.Tables["projectTable"].Rows.Count;
                    Int32 colFuture_b = ds_b.Tables["futureTable"].Rows.Count;
                    var rngproject_b = ws_b.Range(23, 1, (colProject_b + 23), 22);
                    rngproject_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture_b = ws_b.Range((colProject_b + 38), 1, (colFuture_b + colProject_b + 38), 22);
                    rngfuture_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    // ====================== Simulation C =======================================================
                    var ws_c = wb.Worksheet("CHA1_SimC");

                    ds_c = (DataSet)_cha01eRepository.CHA01ESimData(costcode, yymm, yearmode, "C", null, Request.Headers["activeYear"].ToString());

                    foreach (DataRow rr_c in ds_c.Tables["genTable"].Rows)
                    {
                        ws_c.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws_c.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_c["changed_nemps"].ToString()) == 0)
                        {
                            ws_c.Cell(7, 5).Value = Convert.ToInt32("0" + rr_c["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_c.Cell(7, 5).Value = Convert.ToInt32("0" + rr_c["changed_nemps"].ToString());     // E7
                        }
                        ws_c.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(8, 5).Value = Convert.ToInt32("0" + rr_c["noofemps"].ToString());         // E8
                        ws_c.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_c["noofcons"].ToString()) > 0)
                        {
                            ws_c.Cell(8, 7).Value = "Includes " + rr_c["noofcons"].ToString() + " Consultants ";
                            ws_c.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_c.Cell(6, 18).Value = rr_c["abbr"].ToString().ToString();                        // R6
                        ws_c.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(7, 18).Value = rr_c["name"].ToString().ToString();                        // R7
                        ws_c.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(2, 22).Value = "'" + rr_c["pdate"].ToString();                            // U2
                        ws_c.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_c.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_c.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_c.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_c.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata_c = ws_c.Cell(9, 4).InsertTable(ds_c.Tables["alldataTable"].AsEnumerable());
                    tAlldata_c.Theme = XLTableTheme.None;
                    tAlldata_c.ShowHeaderRow = false;
                    tAlldata_c.ShowAutoFilter = false;

                    var rangeClear_c = ws_c.Range(9, 4, 16, 4);
                    rangeClear_c.Clear();
                    rangeClear_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata_c = ws_c.Range(9, 5, 16, 23);
                    rngdata_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata_c.Style.NumberFormat.Format = "0";
                    rngdata_c.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader_c = ws_c.Range(9, 4, 9, 23);
                    rngheader_c.Style.Font.Bold = true;
                    rngheader_c.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader_c.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_c.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc_c in ds_c.Tables["colsTable"].Columns)
                    {
                        Int32 col_c = ds_c.Tables["colsTable"].Columns.IndexOf(cc_c);
                        string strVal_c = ds_c.Tables["colsTable"].Rows[0][cc_c.ColumnName.ToString()].ToString();
                        ws_c.Cell(9, col_c + 5).Value = "'" + strVal_c.Substring(0, 4) + "/" + strVal_c.Substring(4, 2);
                        ws_c.Cell(9, col_c + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds_c.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project_c", ds_c.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future_c", ds_c.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract_c", ds_c.Tables["subcontractTable"]);
                    tmlt.Generate();

                    Int32 colProject_c = ds_c.Tables["projectTable"].Rows.Count;
                    Int32 colFuture_c = ds_c.Tables["futureTable"].Rows.Count;
                    var rngproject_c = ws_c.Range(23, 1, (colProject_c + 23), 22);
                    rngproject_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture_c = ws_c.Range((colProject_c + 38), 1, (colFuture_c + colProject_c + 38), 22);
                    rngfuture_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    wb.Worksheet("CHA1E").Delete();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + "_SIM" + ".xlsm";
                    var t = Task.Run(() =>
                    {
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    Response.Headers.Add("xl_file_name", strFileName);
                    return await t;
                }
                
                
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/GetCHA01ESimData")]
        public async Task<ActionResult> GetCHA01ESimData(string costcode, string yymm, string yearmode, string reportMode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                        "\\Cmplx\\cc\\CHA1E.xlsx";
                        
            int startRowProjects_a;
            int endColProjects_a;
            int endRowProjects_a;
            
            int startRowProjects_b;
            int endColProjects_b;
            int endRowProjects_b;
           
            int startRowProjects_c;
            int endColProjects_c;
            int endRowProjects_c;

            Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition_a = new();
            Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition_b = new();
            Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition_c = new();

            Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition_a = new();            
            Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition_b = new();            
            Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition_c = new();

            IList<Rpt.ExcelHelper.WorkbookCharts> workbookCharts = new List<Rpt.ExcelHelper.WorkbookCharts>();            

            try
            {
                if (string.IsNullOrWhiteSpace(costcode) || string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode) || string.IsNullOrWhiteSpace(Request.Headers["activeYear"].ToString()))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (costcode.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                //byte[] m_Bytes = null;
                DataSet ds_a = new DataSet();
                DataSet ds_b = new DataSet();
                DataSet ds_c = new DataSet();

                string strFileName = string.Empty;
                strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + "_SIM" + ".xlsx";
                //string strFilePathName = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value),appSettings.Value.RAPAppSettings.RAPTempRepository, strFileName);
                string strFilePathName = Path.Combine(Common.CustomFunctions.GetTempRepository(appSettings.Value), strFileName);

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    // ====================== Simulation A =======================================================

                    var ws_a = wb.Worksheet("CHA1_SimA");

                    ds_a = (DataSet)_cha01eRepository.CHA01ESimData(costcode, yymm, yearmode, "A", reportMode, Request.Headers["activeYear"].ToString());

                    foreach (DataRow rr_a in ds_a.Tables["genTable"].Rows)
                    {
                        ws_a.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws_a.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_a["changed_nemps"].ToString()) == 0)
                        {
                            ws_a.Cell(7, 5).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_a.Cell(7, 5).Value = Convert.ToInt32("0" + rr_a["changed_nemps"].ToString());     // E7
                        }
                        ws_a.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(8, 5).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());         // E8
                        ws_a.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_a["noofcons"].ToString()) > 0)
                        {
                            ws_a.Cell(8, 6).Value = "Includes " + rr_a["noofcons"].ToString() + " Consultants ";
                            ws_a.Cell(8, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_a.Cell(6, 18).Value = rr_a["abbr"].ToString().ToString();                        // R6
                        ws_a.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(7, 18).Value = rr_a["name"].ToString().ToString();                        // R7
                        ws_a.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(2, 22).Value = "'" + rr_a["pdate"].ToString();                            // U2
                        ws_a.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_a.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_a.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_a.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_a.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_a.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    if (reportMode == "COMBINED")
                    {
                        ws_a.Cell(3, 11).Value = "M + D";
                        foreach (DataRow rr_a in ds_a.Tables["genOtherTable"].Rows)
                        {
                            ws_a.Cell(6, 5).Value = ws_a.Cell(6, 5).Value + " + " + rr_a["costcode"];                                // E6
                            ws_a.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_a["changed_nemps"].ToString()) == 0)
                            {
                                ws_a.Cell(7, 9).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());     // E7
                            }
                            else
                            {
                                ws_a.Cell(7, 9).Value = Convert.ToInt32("0" + rr_a["changed_nemps"].ToString());     // E7
                            }
                            ws_a.Cell(7, 7).Value = "Delhi Office Emps";
                            ws_a.Cell(7, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws_a.Cell(8, 7).Value = "Delhi Office Emps";
                            ws_a.Cell(8, 9).Value = Convert.ToInt32("0" + rr_a["noofemps"].ToString());         // E8
                            ws_a.Cell(8, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_a["noofcons"].ToString()) > 0)
                            {
                                ws_a.Cell(8, 10).Value = "Includes " + rr_a["noofcons"].ToString() + " Consultants ";
                                ws_a.Cell(8, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            }
                        }
                    }

                    var tAlldata_a = ws_a.Cell(9, 4).InsertTable(ds_a.Tables["alldataTable"].AsEnumerable());
                    tAlldata_a.Theme = XLTableTheme.None;
                    tAlldata_a.ShowHeaderRow = false;
                    tAlldata_a.ShowAutoFilter = false;

                    var rangeClear_a = ws_a.Range(9, 4, 16, 4);
                    rangeClear_a.Clear();
                    rangeClear_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata_a = ws_a.Range(9, 5, 16, 23);
                    rngdata_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata_a.Style.NumberFormat.Format = "0";
                    rngdata_a.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader_a = ws_a.Range(9, 4, 9, 23);
                    rngheader_a.Style.Font.Bold = true;
                    rngheader_a.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader_a.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_a.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc_a in ds_a.Tables["colsTable"].Columns)
                    {
                        Int32 col_a = ds_a.Tables["colsTable"].Columns.IndexOf(cc_a);
                        string strVal_a = ds_a.Tables["colsTable"].Rows[0][cc_a.ColumnName.ToString()].ToString();
                        ws_a.Cell(9, col_a + 5).Value = "'" + strVal_a.Substring(0, 4) + "/" + strVal_a.Substring(4, 2);
                        ws_a.Cell(9, col_a + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds_a.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project_a", ds_a.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future_a", ds_a.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract_a", ds_a.Tables["subcontractTable"]);

                    Int32 colProject_a = ds_a.Tables["projectTable"].Rows.Count;
                    Int32 colFuture_a = ds_a.Tables["futureTable"].Rows.Count;
                    var rngproject_a = ws_a.Range(23, 1, (colProject_a + 23), 22);
                    rngproject_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture_a = ws_a.Range((colProject_a + 38), 1, (colFuture_a + colProject_a + 38), 22);
                    rngfuture_a.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    // ====================== Simulation B =======================================================

                    var ws_b = wb.Worksheet("CHA1_SimB");

                    ds_b = (DataSet)_cha01eRepository.CHA01ESimData(costcode, yymm, yearmode, "B", reportMode, Request.Headers["activeYear"].ToString());
                    
                    foreach (DataRow rr_b in ds_b.Tables["genTable"].Rows)
                    {
                        ws_b.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws_b.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_b["changed_nemps"].ToString()) == 0)
                        {
                            ws_b.Cell(7, 5).Value = Convert.ToInt32("0" + rr_b["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_b.Cell(7, 5).Value = Convert.ToInt32("0" + rr_b["changed_nemps"].ToString());     // E7
                        }
                        ws_b.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(8, 5).Value = Convert.ToInt32("0" + rr_b["noofemps"].ToString());         // E8
                        ws_b.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_b["noofcons"].ToString()) > 0)
                        {
                            ws_b.Cell(8, 7).Value = "Includes " + rr_b["noofcons"].ToString() + " Consultants ";
                            ws_b.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_b.Cell(6, 18).Value = rr_b["abbr"].ToString().ToString();                        // R6
                        ws_b.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(7, 18).Value = rr_b["name"].ToString().ToString();                        // R7
                        ws_b.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(2, 22).Value = "'" + rr_b["pdate"].ToString();                            // U2
                        ws_b.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_b.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_b.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_b.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_b.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_b.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    if (reportMode == "COMBINED")
                    {
                        ws_b.Cell(3, 11).Value = "M + D";
                        foreach (DataRow rr_b in ds_b.Tables["genOtherTable"].Rows)
                        {
                            ws_b.Cell(6, 5).Value = ws_b.Cell(6, 5).Value + " + " + rr_b["costcode"];                                // E6
                            ws_b.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_b["changed_nemps"].ToString()) == 0)
                            {
                                ws_b.Cell(7, 9).Value = Convert.ToInt32("0" + rr_b["noofemps"].ToString());     // E7
                            }
                            else
                            {
                                ws_b.Cell(7, 9).Value = Convert.ToInt32("0" + rr_b["changed_nemps"].ToString());     // E7
                            }
                            ws_b.Cell(7, 7).Value = "Delhi Office Emps";
                            ws_b.Cell(7, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws_b.Cell(8, 7).Value = "Delhi Office Emps";
                            ws_b.Cell(8, 9).Value = Convert.ToInt32("0" + rr_b["noofemps"].ToString());         // E8
                            ws_b.Cell(8, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_b["noofcons"].ToString()) > 0)
                            {
                                ws_b.Cell(8, 10).Value = "Includes " + rr_b["noofcons"].ToString() + " Consultants ";
                                ws_b.Cell(8, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            }
                        }
                    }

                    var tAlldata_b = ws_b.Cell(9, 4).InsertTable(ds_b.Tables["alldataTable"].AsEnumerable());
                    tAlldata_b.Theme = XLTableTheme.None;
                    tAlldata_b.ShowHeaderRow = false;
                    tAlldata_b.ShowAutoFilter = false;

                    var rangeClear_b = ws_b.Range(9, 4, 16, 4);
                    rangeClear_b.Clear();
                    rangeClear_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata_b = ws_b.Range(9, 5, 16, 23);
                    rngdata_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata_b.Style.NumberFormat.Format = "0";
                    rngdata_b.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader_b = ws_b.Range(9, 4, 9, 23);
                    rngheader_b.Style.Font.Bold = true;
                    rngheader_b.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader_b.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_b.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc_b in ds_b.Tables["colsTable"].Columns)
                    {
                        Int32 col_b = ds_b.Tables["colsTable"].Columns.IndexOf(cc_b);
                        string strVal_b = ds_b.Tables["colsTable"].Rows[0][cc_b.ColumnName.ToString()].ToString();
                        ws_b.Cell(9, col_b + 5).Value = "'" + strVal_b.Substring(0, 4) + "/" + strVal_b.Substring(4, 2);
                        ws_b.Cell(9, col_b + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds_b.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project_b", ds_b.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future_b", ds_b.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract_b", ds_b.Tables["subcontractTable"]);

                    Int32 colProject_b = ds_b.Tables["projectTable"].Rows.Count;
                    Int32 colFuture_b = ds_b.Tables["futureTable"].Rows.Count;
                    var rngproject_b = ws_b.Range(23, 1, (colProject_b + 23), 22);
                    rngproject_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture_b = ws_b.Range((colProject_b + 38), 1, (colFuture_b + colProject_b + 38), 22);
                    rngfuture_b.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    // ====================== Simulation C =======================================================
                    var ws_c = wb.Worksheet("CHA1_SimC");

                    ds_c = (DataSet)_cha01eRepository.CHA01ESimData(costcode, yymm, yearmode, "C", reportMode, Request.Headers["activeYear"].ToString());                    
                    foreach (DataRow rr_c in ds_c.Tables["genTable"].Rows)
                    {
                        ws_c.Cell(6, 5).Value = "'" + costcode.ToString();                                // E6
                        ws_c.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_c["changed_nemps"].ToString()) == 0)
                        {
                            ws_c.Cell(7, 5).Value = Convert.ToInt32("0" + rr_c["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_c.Cell(7, 5).Value = Convert.ToInt32("0" + rr_c["changed_nemps"].ToString());     // E7
                        }
                        ws_c.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(8, 5).Value = Convert.ToInt32("0" + rr_c["noofemps"].ToString());         // E8
                        ws_c.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + rr_c["noofcons"].ToString()) > 0)
                        {
                            ws_c.Cell(8, 7).Value = "Includes " + rr_c["noofcons"].ToString() + " Consultants ";
                            ws_c.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_c.Cell(6, 18).Value = rr_c["abbr"].ToString().ToString();                        // R6
                        ws_c.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(7, 18).Value = rr_c["name"].ToString().ToString();                        // R7
                        ws_c.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(2, 22).Value = "'" + rr_c["pdate"].ToString();                            // U2
                        ws_c.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_c.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_c.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_c.Cell(4, 21).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_c.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_c.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    if (reportMode == "COMBINED")
                    {
                        ws_c.Cell(3, 11).Value = "M + D";
                        foreach (DataRow rr_c in ds_c.Tables["genOtherTable"].Rows)
                        {
                            ws_c.Cell(6, 5).Value = ws_c.Cell(6, 5).Value + " + " + rr_c["costcode"];                                // E6
                            ws_c.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_c["changed_nemps"].ToString()) == 0)
                            {
                                ws_c.Cell(7, 9).Value = Convert.ToInt32("0" + rr_c["noofemps"].ToString());     // E7
                            }
                            else
                            {
                                ws_c.Cell(7, 9).Value = Convert.ToInt32("0" + rr_c["changed_nemps"].ToString());     // E7
                            }
                            ws_c.Cell(7, 7).Value = "Delhi Office Emps";
                            ws_c.Cell(7, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws_c.Cell(8, 7).Value = "Delhi Office Emps";
                            ws_c.Cell(8, 9).Value = Convert.ToInt32("0" + rr_c["noofemps"].ToString());         // E8
                            ws_c.Cell(8, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + rr_c["noofcons"].ToString()) > 0)
                            {
                                ws_c.Cell(8, 10).Value = "Includes " + rr_c["noofcons"].ToString() + " Consultants ";
                                ws_c.Cell(8, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            }
                        }
                    }

                    var tAlldata_c = ws_c.Cell(9, 4).InsertTable(ds_c.Tables["alldataTable"].AsEnumerable());
                    tAlldata_c.Theme = XLTableTheme.None;
                    tAlldata_c.ShowHeaderRow = false;
                    tAlldata_c.ShowAutoFilter = false;

                    var rangeClear_c = ws_c.Range(9, 4, 16, 4);
                    rangeClear_c.Clear();
                    rangeClear_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata_c = ws_c.Range(9, 5, 16, 23);
                    rngdata_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata_c.Style.NumberFormat.Format = "0";
                    rngdata_c.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader_c = ws_c.Range(9, 4, 9, 23);
                    rngheader_c.Style.Font.Bold = true;
                    rngheader_c.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader_c.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_c.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc_c in ds_c.Tables["colsTable"].Columns)
                    {
                        Int32 col_c = ds_c.Tables["colsTable"].Columns.IndexOf(cc_c);
                        string strVal_c = ds_c.Tables["colsTable"].Rows[0][cc_c.ColumnName.ToString()].ToString();
                        ws_c.Cell(9, col_c + 5).Value = "'" + strVal_c.Substring(0, 4) + "/" + strVal_c.Substring(4, 2);
                        ws_c.Cell(9, col_c + 5).DataType = XLDataType.Text;
                    }

                    //tmlt.AddVariable("Cha1e_ot", ds_c.Tables["otTable"]);
                    tmlt.AddVariable("Cha1e_Project_c", ds_c.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future_c", ds_c.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract_c", ds_c.Tables["subcontractTable"]);
                    tmlt.Generate();

                    Int32 colProject_c = ds_c.Tables["projectTable"].Rows.Count;
                    Int32 colFuture_c = ds_c.Tables["futureTable"].Rows.Count;
                    var rngproject_c = ws_c.Range(23, 1, (colProject_c + 23), 22);
                    rngproject_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    var rngfuture_c = ws_c.Range((colProject_c + 38), 1, (colFuture_c + colProject_c + 38), 22);
                    rngfuture_c.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    // Color active and future projects seperately
                    //---------- CHA1_SimA
                    startRowProjects_a = ws_a.NamedRange("Cha1e_Future_a_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();

                    endColProjects_a = ws_a.NamedRange("Cha1e_Future_a_tpl").Ranges.FirstOrDefault().LastCell().WorksheetColumn().ColumnNumber();
                    endRowProjects_a = ws_a.NamedRange("Cha1e_Future_a_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();

                    int counterRow_a = startRowProjects_a - 1;
                    //bool colourText_a = true;
                    //while (colourText_a)
                    //{
                    //    counterRow_a++;
                    //    if (ws_a.Cell(counterRow_a, endColProjects_a).Value.ToString() == "0")
                    //    {
                    //        colourText_a = false;
                    //        break;
                    //    }
                    //}

                    //if (counterRow_a > startRowProjects_a)
                    //{
                    //    counterRow_a--;
                    //    ws_a.Range("A" + startRowProjects_a, "W" + counterRow_a).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                    //}

                    int rowCount_a = counterRow_a;                    
                    while (rowCount_a <= endRowProjects_a)
                    {                        
                        counterRow_a++;

                        if (ws_a.Cell(counterRow_a, endColProjects_a).Value.ToString() == "1")
                        {  
                            ws_a.Range("A" + counterRow_a, "W" + counterRow_a).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);                            
                        }
                        rowCount_a++;
                    }

                    var rng_active_project_total_a = ws_a.NamedRange("cha1e_active_project_total_a").Ranges.FirstOrDefault();
                    rng_active_project_total_a.Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);

                    //---------- CHA1_SimB
                    startRowProjects_b = ws_b.NamedRange("Cha1e_Future_b_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();

                    endColProjects_b = ws_b.NamedRange("Cha1e_Future_b_tpl").Ranges.FirstOrDefault().LastCell().WorksheetColumn().ColumnNumber();
                    endRowProjects_b = ws_b.NamedRange("Cha1e_Future_b_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();

                    int counterRow_b = startRowProjects_b - 1;
                    //bool colourText_b = true;
                    //while (colourText_b)
                    //{
                    //    counterRow_b++;
                    //    if (ws_b.Cell(counterRow_b, endColProjects_b).Value.ToString() == "0")
                    //    {
                    //        colourText_b = false;
                    //        break;
                    //    }
                    //}

                    //if (counterRow_b > startRowProjects_b)
                    //{
                    //    counterRow_b--;
                    //    ws_b.Range("A" + startRowProjects_b, "W" + counterRow_b).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                    //}

                    int rowCount_b = counterRow_b;
                    while (rowCount_b <= endRowProjects_b)
                    {
                        counterRow_b++;

                        if (ws_b.Cell(counterRow_b, endColProjects_b).Value.ToString() == "1")
                        {
                            ws_b.Range("A" + counterRow_b, "W" + counterRow_b).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                        }
                        rowCount_b++;
                    }

                    var rng_bctive_project_total_b = ws_b.NamedRange("cha1e_active_project_total_b").Ranges.FirstOrDefault();
                    rng_bctive_project_total_b.Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);

                    //---------- CHA1_SimC
                    startRowProjects_c = ws_c.NamedRange("Cha1e_Future_c_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();
                    endColProjects_c = ws_c.NamedRange("Cha1e_Future_c_tpl").Ranges.FirstOrDefault().LastCell().WorksheetColumn().ColumnNumber();
                    endRowProjects_c = ws_c.NamedRange("Cha1e_Future_c_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();

                    int counterRow_c = startRowProjects_c - 1;
                    //bool colourText_c = true;
                    //while (colourText_c)
                    //{
                    //    counterRow_c++;
                    //    if (ws_c.Cell(counterRow_c, endColProjects_c).Value.ToString() == "0")
                    //    {
                    //        colourText_c = false;
                    //        break;
                    //    }
                    //}

                    //if (counterRow_c > startRowProjects_c)
                    //{
                    //    counterRow_c--;
                    //    ws_c.Range("A" + startRowProjects_c, "W" + counterRow_c).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                    //}

                    int rowCount_c = counterRow_c;
                    while (rowCount_c <= endRowProjects_c)
                    {
                        counterRow_c++;

                        if (ws_c.Cell(counterRow_c, endColProjects_c).Value.ToString() == "1")
                        {
                            ws_c.Range("A" + counterRow_c, "W" + counterRow_c).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                        }
                        rowCount_c++;
                    }

                    var rng_cctive_project_total_c = ws_c.NamedRange("cha1e_active_project_total_c").Ranges.FirstOrDefault();
                    rng_cctive_project_total_c.Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);

                    // Set bottom bordes for header

                    //---------- CHA1_SimA
                    var rngheader_project_a = ws_a.NamedRange("cha1e_projects_header_a").Ranges.FirstOrDefault();
                    rngheader_project_a.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_exptproject_a = ws_a.NamedRange("cha1e_exptproject_header_a").Ranges.FirstOrDefault();
                    rngheader_exptproject_a.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_cost_a = ws_a.NamedRange("cha1e_cost_header_a").Ranges.FirstOrDefault();
                    rngheader_cost_a.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    var rngheader_costcenter_a = ws_a.NamedRange("cha1e_costcenter_header_a").Ranges.FirstOrDefault();
                    rngheader_costcenter_a.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    
                    //---------- CHA1_SimB
                    var rngheader_project_b = ws_b.NamedRange("cha1e_projects_header_b").Ranges.FirstOrDefault();
                    rngheader_project_b.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_exptproject_b = ws_b.NamedRange("cha1e_exptproject_header_b").Ranges.FirstOrDefault();
                    rngheader_exptproject_b.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_cost_b = ws_b.NamedRange("cha1e_cost_header_b").Ranges.FirstOrDefault();
                    rngheader_cost_b.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    var rngheader_costcenter_b = ws_b.NamedRange("cha1e_costcenter_header_b").Ranges.FirstOrDefault();
                    rngheader_costcenter_b.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                   
                    //---------- CHA1_SimC
                    var rngheader_project_c = ws_c.NamedRange("cha1e_projects_header_c").Ranges.FirstOrDefault();
                    rngheader_project_c.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_exptproject_c = ws_c.NamedRange("cha1e_exptproject_header_c").Ranges.FirstOrDefault();
                    rngheader_exptproject_c.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_cost_c = ws_c.NamedRange("cha1e_cost_header_c").Ranges.FirstOrDefault();
                    rngheader_cost_c.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    var rngheader_costcenter_c = ws_c.NamedRange("cha1e_costcenter_header_c").Ranges.FirstOrDefault();
                    rngheader_costcenter_c.Style.Border.BottomBorder = XLBorderStyleValues.Medium;

                    // Chart plotting

                    //---------- CHA1_SimA
                    chartFromPosition_a = GetChartPositionCoOrdinates(ws_a, "Cha1e_chart_location_sim_a_start");
                    chartFromPosition_a.Col = chartFromPosition_a.Col > 0 ? chartFromPosition_a.Col - 1 : chartFromPosition_a.Col;
                    chartFromPosition_a.Row = chartFromPosition_a.Row > 0 ? chartFromPosition_a.Row - 1 : chartFromPosition_a.Row;
                    chartToPosition_a = GetChartPositionCoOrdinates(ws_a, "Cha1e_chart_location_sim_a_end");
                    workbookCharts.Add(new ExcelHelper.WorkbookCharts { SheetName = ws_a.Name, FromPosition = chartFromPosition_a, ToPosition = chartToPosition_a });
                   
                    //---------- CHA1_SimB
                    chartFromPosition_b = GetChartPositionCoOrdinates(ws_b, "Cha1e_chart_location_sim_b_start");
                    chartFromPosition_b.Col = chartFromPosition_b.Col > 0 ? chartFromPosition_b.Col - 1 : chartFromPosition_b.Col;
                    chartFromPosition_b.Row = chartFromPosition_b.Row > 0 ? chartFromPosition_b.Row - 1 : chartFromPosition_b.Row;
                    chartToPosition_b = GetChartPositionCoOrdinates(ws_b, "Cha1e_chart_location_sim_b_end");
                    workbookCharts.Add(new ExcelHelper.WorkbookCharts { SheetName = "CHA1_SimB", FromPosition = chartFromPosition_b, ToPosition = chartToPosition_b });
                    
                    //---------- CHA1_SimC
                    chartFromPosition_c = GetChartPositionCoOrdinates(ws_c, "Cha1e_chart_location_sim_c_start");
                    chartFromPosition_c.Col = chartFromPosition_c.Col > 0 ? chartFromPosition_c.Col - 1 : chartFromPosition_c.Col;
                    chartFromPosition_c.Row = chartFromPosition_c.Row > 0 ? chartFromPosition_c.Row - 1 : chartFromPosition_c.Row;
                    chartToPosition_c = GetChartPositionCoOrdinates(ws_c, "Cha1e_chart_location_sim_c_end");
                    workbookCharts.Add(new ExcelHelper.WorkbookCharts { SheetName = "CHA1_SimC", FromPosition = chartFromPosition_c, ToPosition = chartToPosition_c });                                      

                    // Delete unused sheet
                    wb.Worksheet("CHA1E").Delete();
                    wb.Worksheet("Help").Select();

                    // Remove unused named ranges
                    foreach (var rng in wb.NamedRanges)
                    {
                        if (!rng.IsValid)
                            wb.NamedRanges.Delete(rng.Name);
                    }

                    wb.SaveAs(strFilePathName);
                }

                Rpt.ExcelHelper.PositionCharts(strFilePathName, workbookCharts);

                var t = Task.Run(() =>
                    {
                        return this.File(fileContents: System.IO.File.ReadAllBytes(strFilePathName),
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
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/getCha1Costcodes")]
        public ActionResult GetCha1Costcodes()
        {
            try
            {
                var result = _cha01eRepository.getCha1Costcodes();
                if (result == null)
                {
                    return NotFound();
                }
                return new JsonResult(Ok(result));
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/updateCha1Process")]
        public string UpdateCha1Process(string keyid, string user, string yyyy, string yymm, string yearmode)
        {
            try
            {
                if (string.IsNullOrEmpty(keyid))
                {
                    keyid = getUniqueID();
                }
                if (string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(yyyy) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yyyy.Trim().Length != 4)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                //string user = string.Empty;
                //user = Request.Headers["x-UserIdentityName"].ToString();
                //string userid = user.ToUpper().Substring(user.Trim().IndexOf("\\") + 1).ToString();
                var result = _cha01eRepository.insertCha1Process(keyid, user, yyyy, yymm);
                if (result.ToString().Trim() != "Done")
                {
                    throw new RAPDBException(result.ToString());
                }
                // Trigger Cha1 Download
                TriggerCha1Download(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString());
                return result.ToString();
            }
            catch (Exception)
            {
                throw;
            }
        }

        protected void TriggerCha1Download(string keyid, string user, string yyyy, string yymm, string yearmode)
        {
            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = Path.GetFileName(strConsoleAppPath);
            psi.WorkingDirectory = Path.GetDirectoryName(strConsoleAppPath);
            psi.Arguments = keyid.ToString() + " " + user.ToString() + " " + yyyy.ToString() + " " + yymm.ToString() + " " + yearmode.ToString();
            Process.Start(psi);
        }

        public string getUniqueID()
        {
            var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var stringChars = new char[8];
            var random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            return Convert.ToString(new String(stringChars)) + DateTime.Now.ToString("ss");
        }

        protected Rpt.ExcelHelper.ExcelCoOrdinate GetChartPositionCoOrdinates(ClosedXML.Excel.IXLWorksheet WorkSheet, string RangeName)
        {
            Rpt.ExcelHelper.ExcelCoOrdinate excelCoOrdinate = new Rpt.ExcelHelper.ExcelCoOrdinate();
            excelCoOrdinate.Col = WorkSheet.NamedRange(RangeName).Ranges.FirstOrDefault().FirstCell().WorksheetColumn().ColumnNumber();
            excelCoOrdinate.Row = WorkSheet.NamedRange(RangeName).Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();
            return excelCoOrdinate;
        }

    }
}