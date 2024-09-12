using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using RapReportingApi.Exceptions;
using RapReportingApi.Middleware;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using static RapReportingApi.Controllers.Rpt.ExcelHelper;
using Path = System.IO.Path;

namespace RapReportingApi.Controllers.Rpt
{
    [Authorize]
    public class Cha1Sta6Tm02Controller : ControllerBase
    {
        private readonly string moduleid = "M07";
        private ICha1Sta6Tm02Repository _cha1Sta6Tm02Repository;
        private IOptions<AppSettings> appSettings;
        private readonly ILogger<ExceptionHandlingMiddleWare> _log;

        public Cha1Sta6Tm02Controller(ICha1Sta6Tm02Repository _cha1Sta6Tm02Repository, IOptions<AppSettings> _appSettings, ILogger<ExceptionHandlingMiddleWare> log)
        {
            this._cha1Sta6Tm02Repository = _cha1Sta6Tm02Repository;
            this.appSettings = _appSettings;
            _log = log;
        }

        //CHA1STA6TM02 - Cost Code
        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/GetCha1Sta6Tm02")]
        public async Task<ActionResult> Cha1Sta6Tm02(string costcode, string yymm, string yearmode, string reportMode)
        {
            DataSet ds = new DataSet();
            DataSet dsSta6Tm02Act01 = new DataSet();

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
                else if (yearmode.Trim() != "J" && yearmode.Trim() != "A")
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Cmplx\Cc\CHA1STA6TM02.xlsx";                
                Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition = new();
                Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition = new();

                int startColProjects;
                int startRowProjects;
                int endColProjects;
                int endRowProjects;                

                IList<Rpt.ExcelHelper.WorkbookCharts> workbookCharts = new List<Rpt.ExcelHelper.WorkbookCharts>();

                dsSta6Tm02Act01 = (DataSet)_cha1Sta6Tm02Repository.sta6tm02act01(costcode, yymm, yearmode, reportMode, Request.Headers["activeYear"].ToString());
                //ds = (DataSet)_cha1Sta6Tm02Repository.CHA01EData(costcode, yymm, yearmode, reportMode, Request.Headers["activeYear"].ToString());
                string strFileName = string.Empty;
                strFileName = costcode.Trim() + yymm.Trim().Substring(2) + ".xlsx";
                //string strFilePathName = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value),appSettings.Value.RAPAppSettings.RAPTempRepository, strFileName);
                string strFilePathName = Path.Combine(Common.CustomFunctions.GetTempRepository(appSettings.Value), strFileName);

                string worksheetName = "CHA1E";
                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    var ws = wb.Worksheet(worksheetName);

                    ds = (DataSet)_cha1Sta6Tm02Repository.CHA01EData(costcode, yymm, yearmode, reportMode, Request.Headers["activeYear"].ToString());

                    #region CHA1E

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
                    
                    tmlt.AddVariable("Cha1e_Project", ds.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e_Future", ds.Tables["futureTable"]);
                    tmlt.AddVariable("Cha1e_Subcontract", ds.Tables["subcontractTable"]);                   
                    
                    #endregion

                    #region STA6

                    tmlt.AddVariable("STA6_Data", dsSta6Tm02Act01.Tables["STA6_Data"]);

                    string notSubmitted = string.Empty;
                    string dummyString = string.Empty;
                    if (dsSta6Tm02Act01.Tables["STA6_NotSub_Data"].Rows.Count > 0)
                    {
                        for (int i = 0; i < 145; i++)
                        {
                            dummyString = dummyString + " ";
                        }
                        notSubmitted = "List of Employees who have not sumbitted their timesheets" + dummyString;                        
                    }
                    else
                    {
                        DataRow STA6_NotSub_Data_DataRow = dsSta6Tm02Act01.Tables["STA6_NotSub_Data"].NewRow();
                        STA6_NotSub_Data_DataRow["srno"] = null;
                        STA6_NotSub_Data_DataRow["empno"] = null;
                        STA6_NotSub_Data_DataRow["name"] = null;
                        dsSta6Tm02Act01.Tables["STA6_NotSub_Data"].Rows.Add(STA6_NotSub_Data_DataRow);
                    }
                    tmlt.AddVariable("notSubmitted", notSubmitted);
                    tmlt.AddVariable("STA6_NotSub_Data", dsSta6Tm02Act01.Tables["STA6_NotSub_Data"]);

                    string oddTimesheet = string.Empty;
                    if (dsSta6Tm02Act01.Tables["STA6_Odd_Data"].Rows.Count > 0)
                    {
                        dummyString = string.Empty;
                        for (int i = 0; i < 180; i++)
                        {
                            dummyString = dummyString + " ";
                        }
                        oddTimesheet = "Timesheets filled in other Cost Centre" + dummyString;
                    }
                    tmlt.AddVariable("oddTimesheet", oddTimesheet);
                    tmlt.AddVariable("STA6_Odd_Data", dsSta6Tm02Act01.Tables["STA6_Odd_Data"]);

                    #endregion

                    #region STA6_1

                    tmlt.AddVariable("STA6_1_Data", dsSta6Tm02Act01.Tables["STA6_1_Data"]);

                    #endregion

                    #region STA6_2

                    tmlt.AddVariable("STA6_2_Data", dsSta6Tm02Act01.Tables["STA6_2_Data"]);

                    #endregion

                    #region TM02

                    tmlt.AddVariable("TM02_Heading", dsSta6Tm02Act01.Tables["TM02_Heading"]);
                    if (dsSta6Tm02Act01.Tables["TM02_EmpType_Hrs_Data"].Rows.Count > 0)
                    {
                        tmlt.AddVariable("ManhoursSpentBy", "Manhours spent by");
                        if (dsSta6Tm02Act01.Tables["TM02_EmpType_Hrs_Data"].Rows.Count == 1)
                        {
                            DataRow TM02_EmpType_Hrs_DataRow = dsSta6Tm02Act01.Tables["TM02_EmpType_Hrs_Data"].NewRow();
                            TM02_EmpType_Hrs_DataRow["emptype"] = null;
                            TM02_EmpType_Hrs_DataRow["tothrs"] = 0;
                            dsSta6Tm02Act01.Tables["TM02_EmpType_Hrs_Data"].Rows.Add(TM02_EmpType_Hrs_DataRow);
                        }
                    }
                    else
                    {
                        tmlt.AddVariable("ManhoursSpentBy", "");
                    }
                    tmlt.AddVariable("TM02_EmpType_Hrs_Data", dsSta6Tm02Act01.Tables["TM02_EmpType_Hrs_Data"]);
                    tmlt.AddVariable("TM02_Data", dsSta6Tm02Act01.Tables["TM02_Data"]);

                    #endregion

                    #region TM02_1

                    tmlt.AddVariable("TM02_1_Heading", dsSta6Tm02Act01.Tables["TM02_Heading"]);
                    if (dsSta6Tm02Act01.Tables["TM02_1_EmpType_Hrs_Data"].Rows.Count > 0)
                    {
                        tmlt.AddVariable("ManhoursSpentBy_1", "Manhours spent by");
                        if (dsSta6Tm02Act01.Tables["TM02_1_EmpType_Hrs_Data"].Rows.Count == 1)
                        {
                            DataRow TM02_1_EmpType_Hrs_Data = dsSta6Tm02Act01.Tables["TM02_1_EmpType_Hrs_Data"].NewRow();
                            TM02_1_EmpType_Hrs_Data["emptype"] = null;
                            TM02_1_EmpType_Hrs_Data["tothrs"] = 0;
                            dsSta6Tm02Act01.Tables["TM02_1_EmpType_Hrs_Data"].Rows.Add(TM02_1_EmpType_Hrs_Data);
                        }
                    }
                    else
                    {
                        tmlt.AddVariable("ManhoursSpentBy_1", "");
                    }
                    tmlt.AddVariable("TM02_1_EmpType_Hrs_Data", dsSta6Tm02Act01.Tables["TM02_1_EmpType_Hrs_Data"]);
                    DataRow[] rows = dsSta6Tm02Act01.Tables["TM02_Data"].Select("tcm_jobs = 1", "tma_grp, newcostcode_desc, projno");
                    tmlt.AddVariable("TM02_1_Data", rows);

                    #endregion

                    #region ACT01

                    tmlt.AddVariable("ACT01_Heading", dsSta6Tm02Act01.Tables["ACT01_Heading"]);
                    tmlt.AddVariable("ACT01_Data", dsSta6Tm02Act01.Tables["ACT01_Data"]);

                    #endregion

                    tmlt.Generate();

                    #region CHA1E manipulation
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

                    //wb.SaveAs(strFilePathName);


                    #endregion

                    #region TM02 & TM02_1 - Delete B & C columns and color

                    //TM02 sheet
                    bool colourTM02 = true;
                    var wsTM02 = wb.Worksheet("TM02");

                    //Delete B & C columns
                    int counterTM02 = 14;
                    while (wsTM02.Cell(counterTM02, 4).Value.ToString() != "")
                    {
                        counterTM02 = counterTM02 + 1;
                    }
                    counterTM02 = counterTM02 - 1;
                    wsTM02.Range("B14", "C" + counterTM02).Delete(XLShiftDeletedCells.ShiftCellsLeft);
                    counterTM02 = counterTM02 + 1;
                    wsTM02.Range("D" + counterTM02, "E" + counterTM02).Delete(XLShiftDeletedCells.ShiftCellsLeft);

                    //Colour Pink & Blue
                    counterTM02 = 0;
                    while (colourTM02)
                    {
                        counterTM02 = counterTM02 + 1;
                        var c = wsTM02.Cell(counterTM02, 3).Value.ToString();
                        if (wsTM02.Cell(counterTM02, 3).Value.ToString() == "Total Manhours")
                        {
                            colourTM02 = false;
                            break;
                        }
                        else
                        {
                            if (wsTM02.Cell(counterTM02, 28).Value.ToString() == "PINK")
                            {
                                wsTM02.Range("B" + counterTM02, "Z" + counterTM02).Style.Font.FontColor = XLColor.FromArgb(255, 51, 153);
                                wsTM02.Range("B" + counterTM02, "Z" + counterTM02).Style.Font.Bold = true;
                            }
                            else if (wsTM02.Cell(counterTM02, 28).Value.ToString() == "BLUE")
                            {
                                wsTM02.Range("B" + counterTM02, "Z" + counterTM02).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                                wsTM02.Range("B" + counterTM02, "Z" + counterTM02).Style.Font.Bold = true;
                            }

                        }
                    }

                    //TM02_1 sheet
                    bool colourTM02_1 = true;
                    var wsTM02_1 = wb.Worksheet("TM02_1");

                    //Delete B & C columns
                    int counterTM02_1 = 14;
                    while (wsTM02_1.Cell(counterTM02_1, 4).Value.ToString() != "")
                    {
                        counterTM02_1 = counterTM02_1 + 1;
                    }
                    counterTM02_1 = counterTM02_1 - 1;
                    wsTM02_1.Range("B14", "C" + counterTM02_1).Delete(XLShiftDeletedCells.ShiftCellsLeft);
                    counterTM02_1 = counterTM02_1 + 1;
                    wsTM02_1.Range("D" + counterTM02_1, "E" + counterTM02_1).Delete(XLShiftDeletedCells.ShiftCellsLeft);

                    //Colour Pink & Blue
                    counterTM02_1 = 0;
                    while (colourTM02_1)
                    {
                        counterTM02_1 = counterTM02_1 + 1;
                        var c = wsTM02_1.Cell(counterTM02_1, 3).Value.ToString();
                        if (wsTM02_1.Cell(counterTM02_1, 3).Value.ToString() == "Total Manhours")
                        {
                            colourTM02_1 = false;
                            break;
                        }
                        else
                        {
                            if (wsTM02_1.Cell(counterTM02_1, 28).Value.ToString() == "PINK")
                            {
                                wsTM02_1.Range("B" + counterTM02_1, "Z" + counterTM02_1).Style.Font.FontColor = XLColor.FromArgb(255, 51, 153);
                                wsTM02_1.Range("B" + counterTM02_1, "Z" + counterTM02_1).Style.Font.Bold = true;
                            }
                            else if (wsTM02_1.Cell(counterTM02_1, 28).Value.ToString() == "BLUE")
                            {
                                wsTM02_1.Range("B" + counterTM02_1, "Z" + counterTM02_1).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                                wsTM02_1.Range("B" + counterTM02_1, "Z" + counterTM02_1).Style.Font.Bold = true;
                            }
                        }
                    }

                    #endregion

                    wb.SaveAs(strFilePathName);                    

                    //using (MemoryStream ms = new MemoryStream())
                    //{
                    //    wb.SaveAs(ms);
                    //    byte[] buffer = ms.GetBuffer();
                    //    long length = ms.Length;
                    //    m_Bytes = ms.ToArray();
                    //}
                }
                Rpt.ExcelHelper.PositionCharts(strFilePathName, workbookCharts);

                var t = Task.Run(() =>
                {
                    //return this.File(
                    //               fileContents: m_Bytes,
                    //               contentType: _appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                    //               fileDownloadName: strFileName
                    //           );
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
            finally
            {
                dsSta6Tm02Act01.Dispose();
                ds.Dispose();
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/getRptCostcodes")]
        public ActionResult GetRptCostcodes()
        {
            try
            {
                var result = _cha1Sta6Tm02Repository.getRptCostcodes();
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
        [Route("api/rap/rpt/cmplx/cc/updateRptProcess")]
        public string UpdateRptProcess(string keyid, string user, string yyyy, string yymm, string yearmode, string category, string reporttype, string simul, string reportid, string runmode)
        {
            try
            {
                if (string.IsNullOrEmpty(keyid))
                {
                    keyid = getUniqueID();
                }
                if (string.IsNullOrWhiteSpace(reportid) || string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(yyyy) || string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yearmode.Trim() != "J" && yearmode.Trim() != "A")
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yyyy.Trim().Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var result = _cha1Sta6Tm02Repository.insertRptProcess(keyid, user, yyyy, yymm, yearmode, category, reporttype, simul, reportid);
                if (result.ToString().Trim() != "Done")
                {
                    throw new RAPDBException(result.ToString());
                }

                //if (runmode == "B")
                //{
                //    TriggerRptDownload(keyid.ToString(), user.ToString(), yyyy.ToString(), yymm.ToString(), yearmode.ToString(), reportid.ToString());
                //}
                return result.ToString();
            }
            catch (Exception)
            {
                throw;
            }
        }

        protected void TriggerRptDownload(string keyid, string user, string yyyy, string yymm, string yearmode, string reportid)
        {
            //string strConsoleAppPath = string.Empty;
            //strConsoleAppPath = _appSettings.Value.RAPAppSettings.ConsoleRepository;
            //ProcessStartInfo psi = new ProcessStartInfo();
            //psi.FileName = Path.GetFileName(strConsoleAppPath);
            //psi.WorkingDirectory = Path.GetDirectoryName(strConsoleAppPath);
            //psi.Arguments = keyid.ToString() + " " + user.ToString() + " " + yyyy.ToString() + " " + yymm.ToString() + " " + yearmode.ToString() + " " + reportid.ToString();
            //Process.Start(psi);

            System.Diagnostics.Process psi = new System.Diagnostics.Process();
            psi.StartInfo.FileName = appSettings.Value.RAPAppSettings.ConsoleRepository;
            psi.StartInfo.Arguments = keyid.ToString() + " " + user.ToString() + " " + yyyy.ToString() + " " + yymm.ToString() + " " + yearmode.ToString() + " " + reportid.ToString();
            psi.Start();
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

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/reportProcessStatus")]
        public string ReportProcessStatus(string reportid, string user, string yyyy, string yymm, string yearmode, string category, string reporttype)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(reportid) || string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(yyyy) ||
                    string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yearmode.Trim() != "J" && yearmode.Trim() != "A")
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yyyy.Trim().Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var result = _cha1Sta6Tm02Repository.reportProcessStatus(reportid, user, yyyy, yymm, yearmode, category, reporttype);

                return result.ToString();
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/reportProcessKeyid")]
        public string ReportProcessKeyid(string reportid, string user, string yyyy, string yymm, string yearmode, string category, string reporttype)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(reportid) || string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(yyyy) ||
                    string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yearmode.Trim() != "J" && yearmode.Trim() != "A")
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yyyy.Trim().Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var result = _cha1Sta6Tm02Repository.reportProcessKeyid(reportid, user, yyyy, yymm, yearmode, category, reporttype);

                return result.ToString();
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/getRptMailDetails")]
        public ActionResult GetRptMailDetails(string keyid, string status)
        {
            try
            {
                var result = _cha1Sta6Tm02Repository.getRptMailDetails(keyid, status);
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
        [Route("api/rap/rpt/cmplx/cc/getRptProcesslist")]
        public ActionResult GetRptProcessList(string user, string yyyy, string yymm, string yearmode, string reportid)
        {
            try
            {
                var result = _cha1Sta6Tm02Repository.getRptProcessList(user, yyyy, yymm, yearmode, reportid);
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
        [Route("api/rap/rpt/cmplx/cc/downloadZip")]
        public async Task<IActionResult> reportDownload(string keyid)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(keyid))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                //string path = _appSettings.Value.RAPAppSettings.ApplicationRepository.ToString() + @"\Download\" + reportid.Trim();
                string fname = keyid.Trim() + ".zip";
                //string fname = "0210E1903.xlsx";

                //string path = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString(), "Download", fname);
                //string folderPath = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString(), "Download", keyid.Trim());

                string path = Path.Combine(Common.CustomFunctions.GetRAPDownloadRepository(appSettings.Value).ToString(), fname);
                string folderPath = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString(), keyid.Trim());

                byte[] m_Bytes = null;

                using (MemoryStream ms = new MemoryStream())
                {
                    using (FileStream file = new FileStream(path, FileMode.Open, FileAccess.Read))
                    {
                        m_Bytes = new byte[file.Length];
                        await file.ReadAsync(m_Bytes, 0, (int)file.Length);
                        //ms.Write(m_Bytes, 0, (int)file.Length);
                        //ms.Position = 0;
                    };
                }
                return File(m_Bytes, appSettings.Value.RAPAppSettings.ZipContentType, keyid.Trim() + ".zip");
                //    return await t;
                //}
                //var t = Task.Run(() =>
                //{
                //    //ms.Position = 0;
                //    return File(, "application/zip", keyid.Trim() + ".zip");

                //});
                //return await t;
                //}
                //var t = Task.Run(() =>
                //{
                //    return File(path, "application/zip", keyid.Trim() + ".zip");

                //});
                //return await t;

                //const string contentType = ;

                //FileStream filestream = new FileStream(path, System.IO.FileMode.Open);
                //filestream.Position = 0;

                //    var t = Task.Run(() =>
                //{
                //application/x-zip-compressed

                //var result = new FileContentResult(System.IO.File.ReadAllBytes(@path), "application/zip")
                //{
                //    FileDownloadName = fname
                //};
                //return result;

                //==========

                //return System.IO.File.ReadAllBytes(@path);

                //byte[] zipFile;
                //using (var ms = new MemoryStream())
                //{
                ////    //using (var zipArchive = new ZipArchive(ms, ZipArchiveMode.Create, true))
                ////    //{
                ////    //    //var fileFullPath = "C:\\temp\\a.pdf";

                ////    //    zipArchive.CreateEntryFromFile(@path, fname, CompressionLevel.Fastest);

                ////    //    ms.Position = 0;
                ////    //    zipFile = ms.ToArray();
                ////    //}
                // Int32 cnt = 0; using (ZipArchive newFile = new ZipArchive(ms,
                // ZipArchiveMode.Create, true)) { foreach (string file in
                // Directory.GetFiles(folderPath)) { newFile.CreateEntryFromFile(file,
                // System.IO.Path.GetFileName(file)); cnt += 1; }

                //        ms.Position = 0;
                //        zipFile = ms.ToArray();
                //    }
                //}

                //System.IO.File.WriteAllBytes("C:\\RAPRepository\\test.zip", zipFile);

                //return File(zipFile, MediaTypeNames.Application.Zip, "test.zip");

                //byte[] zipFile = null;
                //var result = new FileContentResult(zipFile, "application/zip")
                //{
                //    FileDownloadName = "xxx.zip"
                //};
                //return result;

                //============

                //Int32 cnt = 0;
                //Stream msZip = new MemoryStream();
                //using (ZipArchive archive = new ZipArchive(msZip, ZipArchiveMode.Create, true))
                //{
                //    foreach (string file in Directory.GetFiles(folderPath))
                //    {
                //        var archiveEntry = archive.CreateEntry(file, CompressionLevel.Fastest);
                //        using (var zipStream = archiveEntry.Open())
                //        {
                //            msZip.CopyTo(zipStream);
                //        }
                //        cnt += 1;
                //    }
                //}
                //msZip.Position = 0;
                //return File(msZip, MediaTypeNames.Application.Zip, "testnew.zip");

                //});

                //return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/discardZip")]
        public IActionResult reportDiscard(string keyid, string user)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(keyid) && string.IsNullOrWhiteSpace(user))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var result = _cha1Sta6Tm02Repository.discardRptProcess(keyid, user);
                if (result.ToString().Trim() != "Done")
                {
                    throw new RAPDBException(result.ToString());
                }

                string fname = keyid.Trim() + ".zip";
                //string path = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString(), "Download", fname);
                //string folderPath = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString(), "Download", keyid.Trim());

                string path = Path.Combine(Common.CustomFunctions.GetRAPDownloadRepository(appSettings.Value).ToString(), fname);
                string folderPath = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString(), keyid.Trim());


                if (System.IO.File.Exists(path))
                {
                    System.IO.File.Delete(path);
                }

                return Ok(result.ToString());
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/getList4WorkerProcess")]
        public ActionResult getList4WorkerProcess()
        {
            try
            {
                var result = _cha1Sta6Tm02Repository.getList4WorkerProcess();
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
        [Route("api/rap/rpt/cmplx/cc/addProcessQueue")]
        public string addProcessQueue(string empno, string yearmode, string yymm, string processid, string processdesc)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(processid) || string.IsNullOrWhiteSpace(processdesc) || string.IsNullOrWhiteSpace(empno) || string.IsNullOrWhiteSpace(Request.Headers["activeYear"].ToString()) || string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yearmode.Trim() != "J" && yearmode.Trim() != "A")
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (Request.Headers["activeYear"].ToString().Trim().Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                string parameterFilter;
                parameterFilter = JsonConvert.SerializeObject(new
                {
                    Yyyy = Request.Headers["activeYear"].ToString(),
                    YearMode = yearmode,
                    Yymm = yymm
                });

                var result = _cha1Sta6Tm02Repository.addProcessQueue(empno, moduleid, processid, processdesc, parameterFilter);
                if (result.ToString().Trim().Substring(0, 2) == "KO")
                {
                    throw new RAPDBException(result.ToString());
                }
                return result.ToString();
            }
            catch (Exception)
            {
                throw;
            }
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