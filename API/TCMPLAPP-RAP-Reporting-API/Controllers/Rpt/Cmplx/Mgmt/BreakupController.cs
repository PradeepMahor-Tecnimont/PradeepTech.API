using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.Mgmt;
using RapReportingApi.Repositories.Interfaces.User;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt.Cmplx.Mgmt
{
    [Authorize]
    public class BreakupController : ControllerBase
    {
        private IBreakupRepository breakupRepository;
        private IUserRepository userRepository;
        private IOptions<AppSettings> appSettings;

        public BreakupController(IBreakupRepository _breakupRepository, IOptions<AppSettings> _appSettings, IUserRepository _userRepository)
        {
            breakupRepository = _breakupRepository;
            appSettings = _appSettings;
            userRepository = _userRepository;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetBreakupData")]
        public async Task<ActionResult> GetBreakupData(string yymm, string category, string yearmode)
        {
            if (string.IsNullOrWhiteSpace(yymm))
            {
                throw new RAPInvalidParameter("Parameter values are invalid, please check");
            }
            else if (yymm.Trim().Length != 6)
            {
                throw new RAPInvalidParameter("Parameter values are invalid, please check");
            }

            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                                    "\\Cmplx\\mgmt\\BREAKUP.xlsx";

            string strCategory = string.Empty;
            string strTitle = string.Empty;

            switch (category)
            {
                case "E":
                    strCategory = "_Engg";
                    strTitle = "ENGG BREAKUP";
                    break;

                case "N":
                    strCategory = "_NonEngg";
                    strTitle = "NON-ENGG BREAKUP";
                    break;

                case "B":
                    strCategory = "_All";
                    strTitle = "COMPLETE BREAKUP";
                    break;
            }

            try
            {
                string startMonth = string.Empty;
                startMonth = userRepository.getStartMonth(yearmode).ToString();
                DateTime currDate = DateTime.Now;

                byte[] m_Bytes = null;
                DataSet dsCC = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    DataSet dsData = new DataSet();

                    dsData = (DataSet)breakupRepository.GetBreakupData(yymm, category, yearmode);

                    // ======== Breakup for Month ==============================
                    var ws_mnth = wb.Worksheet("Breakup_Month");

                    ws_mnth.Cell(1, 10).Value = strTitle;
                    ws_mnth.Cell(2, 10).Value = "'" + currDate.ToString("dd-MMM-yyyy");
                    ws_mnth.Cell(2, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    ws_mnth.Cell(3, 10).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    ws_mnth.Cell(3, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    Int32 intRowMnth = dsData.Tables["mnthTable"].Columns.Count;
                    if (intRowMnth > 5)
                    {
                        Int32 balRowMnth = dsData.Tables["mnthTable"].Rows.Count - 5;
                        ws_mnth.Range(10, 1, 10, 12).InsertRowsBelow(balRowMnth);
                    }

                    Int32 intColMnth = dsData.Tables["colsMnthTable"].Columns.Count;
                    if (intColMnth > 6)
                    {
                        Int32 balColMnth = dsData.Tables["colsMnthTable"].Columns.Count - 6;
                        ws_mnth.Range(1, 7, dsData.Tables["mnthTable"].Rows.Count + 11, 7).InsertColumnsBefore(balColMnth);
                    }

                    foreach (DataColumn ccMnth in dsData.Tables["colsMnthTable"].Columns)
                    {
                        Int32 colccMnth = dsData.Tables["colsMnthTable"].Columns.IndexOf(ccMnth);
                        ws_mnth.Cell(6, colccMnth + 4).Value = "'" + dsData.Tables["colsMnthTable"].Rows[0][ccMnth.ColumnName.ToString()].ToString();
                        ws_mnth.Cell(6, colccMnth + 4).DataType = XLDataType.Text;
                    }

                    foreach (DataRow rrMnth in dsData.Tables["mnthTable"].Rows)
                    {
                        Int32 rowrrMnth = dsData.Tables["mnthTable"].Rows.IndexOf(rrMnth);
                        ws_mnth.Cell(9 + rowrrMnth, 1).Value = rowrrMnth + 1;
                        foreach (DataColumn colrrMnth in dsData.Tables["mnthTable"].Columns)
                        {
                            Int32 cMnth = dsData.Tables["mnthTable"].Columns.IndexOf(colrrMnth);
                            if (cMnth < 2)
                            {
                                ws_mnth.Cell(9 + rowrrMnth, cMnth + 2).Value = "'" + rrMnth[colrrMnth.ColumnName.ToString()].ToString(); ;
                                ws_mnth.Cell(9 + rowrrMnth, cMnth + 2).DataType = XLDataType.Text;
                            }
                            else
                            {
                                ws_mnth.Cell(9 + rowrrMnth, cMnth + 2).Value = rrMnth[colrrMnth.ColumnName.ToString()];
                                ws_mnth.Cell(9 + rowrrMnth, cMnth + 2).DataType = XLDataType.Number;
                            }
                        }
                    }

                    // Formula
                    if (dsData.Tables["mnthTable"].Rows.Count <= 6)
                    {
                        for (int mmCol = 1; mmCol < dsData.Tables["mnthTable"].Columns.Count; mmCol++)
                        {
                            var rngMnthData = ws_mnth.Range(9, mmCol + 3, 15, mmCol + 3);
                            ws_mnth.Cell(15, mmCol + 3).FormulaA1 = "=sum(" + rngMnthData.RangeAddress + ")";
                            ws_mnth.Evaluate("=sum(" + rngMnthData.RangeAddress + ")");
                        }
                    }
                    else
                    {
                        for (int mmCol = 1; mmCol < dsData.Tables["mnthTable"].Columns.Count; mmCol++)
                        {
                            var rngMnthData = ws_mnth.Range(9, mmCol + 3, dsData.Tables["mnthTable"].Rows.Count + 9, mmCol + 3);
                            ws_mnth.Cell(dsData.Tables["mnthTable"].Rows.Count + 10, mmCol + 3).FormulaA1 = "=sum(" + rngMnthData.RangeAddress + ")";
                            ws_mnth.Evaluate("=sum(" + rngMnthData.RangeAddress + ")");
                        }
                    }

                    // Formula
                    if (dsData.Tables["mnthTable"].Columns.Count <= 6)
                    {
                        for (int ppRow = 1; ppRow < dsData.Tables["mnthTable"].Rows.Count; ppRow++)
                        {
                            var rngMnth = ws_mnth.Range(ppRow + 3, 4, ppRow + 3, 9);
                            ws_mnth.Cell(ppRow + 3, 10).FormulaA1 = "=sum(" + rngMnth.RangeAddress + ")";
                            ws_mnth.Evaluate("=sum(" + rngMnth.RangeAddress + ")");
                        }
                    }
                    else
                    {
                        for (int ppRow = 1; ppRow < dsData.Tables["mnthTable"].Rows.Count; ppRow++)
                        {
                            var rngMnth = ws_mnth.Range(ppRow + 8, 4, ppRow + 8, dsData.Tables["mnthTable"].Columns.Count + 1);
                            ws_mnth.Cell(ppRow + 8, dsData.Tables["mnthTable"].Columns.Count + 2).FormulaA1 = "=sum(" + rngMnth.RangeAddress + ")";
                            ws_mnth.Evaluate("=sum(" + rngMnth.RangeAddress + ")");
                        }
                    }

                    // ======== Breakup for Period ==============================

                    var ws_period = wb.Worksheet("Breakup_Period");
                    ws_period.Cell(1, 10).Value = strTitle;
                    ws_period.Cell(2, 10).Value = "'" + currDate.ToString("dd-MMM-yyyy");
                    ws_period.Cell(2, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    ws_period.Cell(3, 10).Value = "'" + startMonth.Substring(0, 4) + "/" + startMonth.Substring(4, 2) + " to " + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    ws_period.Cell(3, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    Int32 intRowPeriod = dsData.Tables["periodTable"].Columns.Count;
                    if (intRowPeriod > 5)
                    {
                        Int32 balRowPeriod = dsData.Tables["periodTable"].Rows.Count - 5;
                        ws_period.Range(10, 1, 10, 12).InsertRowsBelow(balRowPeriod);
                    }

                    Int32 intColPeriod = dsData.Tables["colsPeriodTable"].Columns.Count;
                    if (intColPeriod > 6)
                    {
                        Int32 balColPeriod = dsData.Tables["colsPeriodTable"].Columns.Count - 6;
                        ws_period.Range(1, 7, dsData.Tables["periodTable"].Rows.Count + 11, 7).InsertColumnsBefore(balColPeriod);
                    }

                    foreach (DataColumn ccPeriod in dsData.Tables["colsPeriodTable"].Columns)
                    {
                        Int32 colccPeriod = dsData.Tables["colsPeriodTable"].Columns.IndexOf(ccPeriod);
                        ws_period.Cell(6, colccPeriod + 4).Value = "'" + dsData.Tables["colsPeriodTable"].Rows[0][ccPeriod.ColumnName.ToString()].ToString();
                        ws_period.Cell(6, colccPeriod + 4).DataType = XLDataType.Text;
                    }

                    foreach (DataRow rrPeriod in dsData.Tables["periodTable"].Rows)
                    {
                        Int32 rowrrPeriod = dsData.Tables["periodTable"].Rows.IndexOf(rrPeriod);
                        ws_period.Cell(9 + rowrrPeriod, 1).Value = rowrrPeriod + 1;
                        foreach (DataColumn colrrPeriod in dsData.Tables["periodTable"].Columns)
                        {
                            Int32 cPeriod = dsData.Tables["periodTable"].Columns.IndexOf(colrrPeriod);
                            if (cPeriod < 2)
                            {
                                ws_period.Cell(9 + rowrrPeriod, cPeriod + 2).Value = "'" + rrPeriod[colrrPeriod.ColumnName.ToString()].ToString(); ;
                                ws_period.Cell(9 + rowrrPeriod, cPeriod + 2).DataType = XLDataType.Text;
                            }
                            else
                            {
                                ws_period.Cell(9 + rowrrPeriod, cPeriod + 2).Value = rrPeriod[colrrPeriod.ColumnName.ToString()];
                                ws_period.Cell(9 + rowrrPeriod, cPeriod + 2).DataType = XLDataType.Number;
                            }
                        }
                    }

                    // Formula
                    if (dsData.Tables["periodTable"].Rows.Count <= 6)
                    {
                        for (int ppCol = 1; ppCol < dsData.Tables["periodTable"].Columns.Count; ppCol++)
                        {
                            var rngPeriodData = ws_period.Range(9, ppCol + 3, 15, ppCol + 3);
                            ws_period.Cell(15, ppCol + 3).FormulaA1 = "=sum(" + rngPeriodData.RangeAddress + ")";
                            ws_period.Evaluate("=sum(" + rngPeriodData.RangeAddress + ")");
                        }
                    }
                    else
                    {
                        for (int ppCol = 1; ppCol < dsData.Tables["periodTable"].Columns.Count; ppCol++)
                        {
                            var rngPeriodData = ws_period.Range(9, ppCol + 3, dsData.Tables["periodTable"].Rows.Count + 9, ppCol + 3);
                            ws_period.Cell(dsData.Tables["periodTable"].Rows.Count + 10, ppCol + 3).FormulaA1 = "=sum(" + rngPeriodData.RangeAddress + ")";
                            ws_period.Evaluate("=sum(" + rngPeriodData.RangeAddress + ")");
                        }
                    }

                    // Formula
                    if (dsData.Tables["periodTable"].Columns.Count <= 6)
                    {
                        for (int ppRow = 1; ppRow < dsData.Tables["periodTable"].Rows.Count; ppRow++)
                        {
                            var rngPeriod = ws_period.Range(ppRow + 3, 4, ppRow + 3, 9);
                            ws_period.Cell(ppRow + 3, 10).FormulaA1 = "=sum(" + rngPeriod.RangeAddress + ")";
                            ws_period.Evaluate("=sum(" + rngPeriod.RangeAddress + ")");
                        }
                    }
                    else
                    {
                        for (int ppRow = 1; ppRow < dsData.Tables["periodTable"].Rows.Count; ppRow++)
                        {
                            var rngPeriod = ws_period.Range(ppRow + 8, 4, ppRow + 8, dsData.Tables["periodTable"].Columns.Count + 1);
                            ws_period.Cell(ppRow + 8, dsData.Tables["periodTable"].Columns.Count + 2).FormulaA1 = "=sum(" + rngPeriod.RangeAddress + ")";
                            ws_period.Evaluate("=sum(" + rngPeriod.RangeAddress + ")");
                        }
                    }

                    // ======== Breakup for TMAGroup ==============================

                    var ws_tmagroup = wb.Worksheet("TMAGROUP");
                    DataSet dsTMA = new DataSet();

                    dsTMA = (DataSet)breakupRepository.GetTMAGroup();

                    foreach (DataRow tmaRow in dsTMA.Tables["tmagroupTable"].Rows)
                    {
                        Int32 indxTMA = dsTMA.Tables["tmagroupTable"].Rows.IndexOf(tmaRow);
                        ws_tmagroup.Cell((2 + indxTMA), 1).Value = tmaRow["tmagroup"].ToString();
                        ws_tmagroup.Cell((2 + indxTMA), 2).Value = tmaRow["tmagroupdesc"].ToString();
                        ws_tmagroup.Cell((2 + indxTMA), 3).Value = tmaRow["subgroup"].ToString();
                    }

                    tmlt.Generate();

                    dsCC.Dispose();
                    dsData.Dispose();
                    dsTMA.Dispose();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "Breakup_" + yymm.Trim().Substring(2, 4).ToString() + strCategory + ".xlsx";

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
        [Route("api/rap/rpt/cmplx/mgmt/GetPlantEnggData")]
        public async Task<ActionResult> GetPlantEnggData(string yymm)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\mgmt\\plantengg.xlsm";
            DataSet dsCC = new DataSet();

            try
            {
                byte[] m_Bytes = null;

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    var ws = wb.Worksheet("Engg");
                    Int32 printHeader;
                    Int32 startRange;
                    Int32 pasteRange;

                    printHeader = 0;
                    startRange = 10;
                    pasteRange = 10;
                    dsCC = (DataSet)breakupRepository.GetPlantEnggCostcodeList(yymm);

                    ws.Cell(2, 19).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                    ws.Cell(3, 19).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);

                    // Exyract Costcode for the selected sheet
                    foreach (DataRow rr in dsCC.Tables["costcodeTable"].Rows)
                    {
                        string strCostcode = rr["costcode"].ToString();
                        DataSet dsData = new DataSet();

                        try
                        {
                            dsData = (DataSet)breakupRepository.GetPlantEnggData(strCostcode, yymm);
                            startRange = pasteRange;

                            // Column Headings
                            if (printHeader == 0)
                            {
                                foreach (DataColumn cc in dsData.Tables["colsTable"].Columns)
                                {
                                    Int32 col = dsData.Tables["colsTable"].Columns.IndexOf(cc);
                                    string strVal = dsData.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                                    ws.Cell(5, col + 6).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                                    ws.Cell(5, col + 6).DataType = XLDataType.Text;
                                }
                            }

                            printHeader = printHeader + 1;
                            pasteRange = startRange + 3;

                            // Copy Template cells
                            var rngTemplate = ws.Range(startRange, 1, startRange + 3, 20);
                            ws.Cell(pasteRange, 1).Value = rngTemplate;

                            ws.Cell(startRange, 1).Value = printHeader;
                            ws.Cell(startRange, 2).Value = rr["costcode"].ToString();
                            ws.Cell(startRange, 3).Value = rr["name"].ToString();

                            // Costcode Data
                            foreach (DataRow rrdata in dsData.Tables["dataTable"].Rows)
                            {
                                Int32 ddrow = dsData.Tables["dataTable"].Rows.IndexOf(rrdata);

                                foreach (DataColumn ccdata in dsData.Tables["dataTable"].Columns)
                                {
                                    Int32 ddcol = dsData.Tables["dataTable"].Columns.IndexOf(ccdata);
                                    if (ddcol > 0)
                                    {
                                        string rowFldValue = (rrdata[ccdata.ColumnName.ToString()].ToString() == "") ? "0" : rrdata[ccdata.ColumnName.ToString()].ToString();

                                        if (rrdata[ccdata.ColumnName.ToString()] != null)
                                        {
                                            ws.Cell(startRange + ddrow, ddcol + 5).Value = Convert.ToDecimal(rowFldValue);
                                            ws.Cell(startRange + ddrow, ddcol + 5).DataType = XLDataType.Number;
                                        }
                                    }
                                }
                            }
                        }
                        catch (Exception)
                        {
                            throw;
                        }
                        finally
                        {
                            dsData.Dispose();
                        }
                    }

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = "PlantEngg_" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";

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
            finally
            {
                dsCC.Dispose();
            }
        }
    }
}