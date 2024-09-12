using ClosedXML.Excel;
using ClosedXML.Report;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.Mgmt;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Library.Excel.Charts;
using TCMPLApp.Library.Excel.Charts.Models;
using static RapReportingApi.Controllers.Rpt.ExcelHelper;

namespace RapReportingApi.Controllers.Rpt.Cmplx.Mgmt
{
    [Authorize]
    public class CHA1EGRPController : ControllerBase
    {
        private ICHA1EGRPRepository cha1egrpRepository;
        private IOptions<AppSettings> appSettings;

        public CHA1EGRPController(ICHA1EGRPRepository _cha1egrpRepository, IOptions<AppSettings> _appSettings)
        {
            cha1egrpRepository = _cha1egrpRepository;
            this.appSettings = _appSettings;
        }

        #region old_code

        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1EnggOld")]
        public async Task<ActionResult> GetCHA1EnggOld(string yymm, string category, string simul, string yearmode)
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
                                                    "\\Cmplx\\mgmt\\CHA1EGRP.xlsm";

            try
            {
                byte[] m_Bytes = null;
                DataSet dsCC = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    //===== CH1E Group  =======================================================================================
                    var ws_cha1e = wb.Worksheet("CHA1E");
                    DataSet dsData = new DataSet();

                    dsData = (DataSet)cha1egrpRepository.GetCha1EGrpData(yymm, category, simul, 18, Request.Headers["activeYear"].ToString());
                    foreach (DataRow gg1 in dsData.Tables["genTable"].Rows)
                    {
                        string strTitle = string.Empty;
                        switch (category)
                        {
                            case "E":
                                strTitle = "Engg CostCodes";
                                break;

                            case "N":
                                strTitle = "NonEngg CostCodes";
                                break;

                            case "B":
                                strTitle = "Engg and NonEngg CostCodes";
                                break;
                        }

                        ws_cha1e.Cell(6, 5).Value = strTitle;                                                   // E6
                        ws_cha1e.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg1["changed_nemps"].ToString()) == 0)
                        {
                            ws_cha1e.Cell(7, 5).Value = Convert.ToInt32("0" + gg1["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_cha1e.Cell(7, 5).Value = Convert.ToInt32("0" + gg1["changed_nemps"].ToString());     // E7
                        }
                        ws_cha1e.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e.Cell(8, 5).Value = Convert.ToInt32("0" + gg1["noofemps"].ToString());         // E8
                        ws_cha1e.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg1["noofcons"].ToString()) > 0)
                        {
                            ws_cha1e.Cell(8, 7).Value = "Includes " + gg1["noofcons"].ToString() + " Consultants ";
                            ws_cha1e.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_cha1e.Cell(2, 22).Value = "'" + gg1["pdate"].ToString();                            // U2
                        ws_cha1e.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);  // U3
                        ws_cha1e.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_cha1e.Cell(4, 21).Value = "Jan - Dec";                                          // U4
                        }
                        else
                        {
                            ws_cha1e.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_cha1e.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata = ws_cha1e.Cell(9, 4).InsertTable(dsData.Tables["alldataTable"].AsEnumerable());
                    tAlldata.Theme = XLTableTheme.None;
                    tAlldata.ShowHeaderRow = false;
                    tAlldata.ShowAutoFilter = false;

                    var rangeClear = ws_cha1e.Range(9, 4, 16, 4);
                    rangeClear.Clear();
                    rangeClear.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata = ws_cha1e.Range(9, 5, 16, 23);
                    rngdata.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata.Style.NumberFormat.Format = "0";
                    rngdata.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader = ws_cha1e.Range(9, 4, 9, 23);
                    rngheader.Style.Font.Bold = true;
                    rngheader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc2 in dsData.Tables["colsTable"].Columns)
                    {
                        Int32 col = dsData.Tables["colsTable"].Columns.IndexOf(cc2);
                        string strVal = dsData.Tables["colsTable"].Rows[0][cc2.ColumnName.ToString()].ToString();
                        ws_cha1e.Cell(9, col + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws_cha1e.Cell(9, col + 5).DataType = XLDataType.Text;
                    }

                    tmlt.AddVariable("Cha1eSub", dsData.Tables["subcontractTable"]);
                    tmlt.AddVariable("Cha1eProj", dsData.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1eFur", dsData.Tables["futureTable"]);

                    Int32 colProject = dsData.Tables["projectTable"].Rows.Count;
                    Int32 colFuture = dsData.Tables["futureTable"].Rows.Count;

                    //var rngSub = ws_cha1e.Range(52, 5, 52, 23);
                    //rngSub.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngproject = ws_cha1e.Range(23, 1, (colProject + 23), 23);
                    //rngproject.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngfuture = ws_cha1e.Range((colProject + 38), 1, (colFuture + colProject + 38), 23);
                    //rngfuture.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //===== CH1E Group 24 months  =============================================================================
                    var ws_cha1e24 = wb.Worksheet("CHA1E_24");
                    DataSet dsData24 = new DataSet();

                    dsData24 = (DataSet)cha1egrpRepository.GetCha1EGrpData(yymm, category, simul, 24, Request.Headers["activeYear"].ToString());
                    foreach (DataRow gg2 in dsData24.Tables["genTable"].Rows)
                    {
                        string strTitle24 = string.Empty;
                        switch (category)
                        {
                            case "E":
                                strTitle24 = "Engg CostCodes";
                                break;

                            case "N":
                                strTitle24 = "NonEngg CostCodes";
                                break;

                            case "B":
                                strTitle24 = "Engg and NonEngg CostCodes";
                                break;
                        }

                        ws_cha1e.Cell(6, 5).Value = strTitle24;                                                  // E6
                        ws_cha1e24.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg2["changed_nemps"].ToString()) == 0)
                        {
                            ws_cha1e24.Cell(7, 5).Value = Convert.ToInt32("0" + gg2["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_cha1e24.Cell(7, 5).Value = Convert.ToInt32("0" + gg2["changed_nemps"].ToString());     // E7
                        }
                        ws_cha1e24.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e24.Cell(8, 5).Value = Convert.ToInt32("0" + gg2["noofemps"].ToString());         // E8
                        ws_cha1e24.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg2["noofcons"].ToString()) > 0)
                        {
                            ws_cha1e24.Cell(8, 7).Value = "Includes " + gg2["noofcons"].ToString() + " Consultants ";
                            ws_cha1e24.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_cha1e24.Cell(2, 22).Value = "'" + gg2["pdate"].ToString();                            // U2
                        ws_cha1e24.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e24.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_cha1e24.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_cha1e24.Cell(4, 22).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_cha1e24.Cell(4, 22).Value = "Apr - Mar";                                         // U4
                        }
                        ws_cha1e24.Cell(4, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata24 = ws_cha1e24.Cell(9, 4).InsertTable(dsData24.Tables["alldataTable"].AsEnumerable());
                    tAlldata24.Theme = XLTableTheme.None;
                    tAlldata24.ShowHeaderRow = false;
                    tAlldata24.ShowAutoFilter = false;

                    var rangeClear24 = ws_cha1e24.Range(9, 4, 16, 4);
                    rangeClear24.Clear();
                    rangeClear24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata24 = ws_cha1e24.Range(9, 5, 16, 29);
                    rngdata24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata24.Style.NumberFormat.Format = "0";
                    rngdata24.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader24 = ws_cha1e24.Range(9, 4, 9, 29);
                    rngheader24.Style.Font.Bold = true;
                    rngheader24.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader24.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader24.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc2 in dsData24.Tables["colsTable"].Columns)
                    {
                        Int32 col24 = dsData24.Tables["colsTable"].Columns.IndexOf(cc2);
                        string strVal24 = dsData24.Tables["colsTable"].Rows[0][cc2.ColumnName.ToString()].ToString();
                        ws_cha1e24.Cell(9, col24 + 5).Value = "'" + strVal24.Substring(0, 4) + "/" + strVal24.Substring(4, 2);
                        ws_cha1e24.Cell(9, col24 + 5).DataType = XLDataType.Text;
                    }

                    tmlt.AddVariable("Cha1e24Sub", dsData24.Tables["subcontractTable"]);
                    tmlt.AddVariable("Cha1e24Proj", dsData24.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e24Fur", dsData24.Tables["futureTable"]);

                    Int32 colProject24 = dsData24.Tables["projectTable"].Rows.Count;
                    Int32 colFuture24 = dsData24.Tables["futureTable"].Rows.Count;

                    ////var rngSub24 = ws_cha1e24.Range(52, 5, 52, 29);
                    ////rngSub24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngproject24 = ws_cha1e24.Range(23, 1, (colProject24 + 23), 30);
                    //rngproject24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngfuture24 = ws_cha1e24.Range((23 + colProject24 + 9), 1, (23 + colProject24 + 38 + colFuture24), 30);
                    //rngfuture24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    ////var rngfuture24 = ws_cha1e24.Range((colProject24 + 38), 1, (colFuture24 + colProject24 + 38), 29);
                    ////rngfuture24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //===== Costcode sheets ===================================================================================
                    dsCC = (DataSet)cha1egrpRepository.GetCostcodeList(category);

                    foreach (DataRow rowCC in dsCC.Tables["costcodeTable"].Rows)
                    {
                        Int32 inPos = dsCC.Tables["costcodeTable"].Rows.IndexOf(rowCC) + 4;
                        string strCostcode = rowCC["costcode"].ToString();
                        string strCCName = rowCC["name"].ToString();

                        var ws_sheet = wb.Worksheet("Sheet1");
                        ws_sheet.CopyTo(strCostcode, inPos);

                        var ws = wb.Worksheet(strCostcode);

                        ws.ShowGridLines = false;

                        DataSet dsDataCC = new DataSet();

                        dsDataCC = (DataSet)cha1egrpRepository.GetCha1ECostcodeData(yymm, strCostcode.ToString(), simul, Request.Headers["activeYear"].ToString(),"");

                        foreach (DataRow gg3 in dsDataCC.Tables["genTable"].Rows)
                        {
                            ws.Cell(6, 5).Value = "'" + strCostcode.ToString();                             // E6
                            ws.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + gg3["changed_nemps"].ToString()) == 0)
                            {
                                ws.Cell(7, 5).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());     // E7
                            }
                            else
                            {
                                ws.Cell(7, 5).Value = Convert.ToInt32("0" + gg3["changed_nemps"].ToString());     // E7
                            }
                            ws.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(8, 5).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());         // E8
                            ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + gg3["noofcons"].ToString()) > 0)
                            {
                                ws.Cell(8, 7).Value = "Includes " + gg3["noofcons"].ToString() + " Consultants ";
                                ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            }
                            ws.Cell(6, 18).Value = gg3["abbr"].ToString().ToString();                        // R6
                            ws.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(7, 18).Value = gg3["name"].ToString().ToString();                        // R7
                            ws.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(2, 22).Value = "'" + gg3["pdate"].ToString();                            // U2
                            ws.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                            ws.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (yearmode == "J")
                            {
                                ws.Cell(4, 22).Value = "Jan - Dec";                                         // U4
                            }
                            else
                            {
                                ws.Cell(4, 22).Value = "Apr - Mar";                                         // U4
                            }
                            ws.Cell(4, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }

                        var tAlldataCC = ws.Cell(9, 4).InsertTable(dsDataCC.Tables["alldataTable"].AsEnumerable());
                        tAlldataCC.Theme = XLTableTheme.None;
                        tAlldataCC.ShowHeaderRow = false;
                        tAlldataCC.ShowAutoFilter = false;

                        var rangeClearCC = ws.Range(9, 4, 16, 4);
                        rangeClearCC.Clear();
                        rangeClearCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                        var rngdataCC = ws.Range(9, 5, 16, 23);
                        rngdataCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                        rngdataCC.Style.NumberFormat.Format = "0";
                        rngdataCC.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                        var rngheaderCC = ws.Range(9, 4, 9, 23);
                        rngheaderCC.Style.Font.Bold = true;
                        rngheaderCC.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                        rngheaderCC.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                        rngheaderCC.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                        foreach (DataColumn cc3 in dsDataCC.Tables["colsTable"].Columns)
                        {
                            Int32 colCC = dsDataCC.Tables["colsTable"].Columns.IndexOf(cc3);
                            string strVal = dsDataCC.Tables["colsTable"].Rows[0][cc3.ColumnName.ToString()].ToString();
                            ws.Cell(9, colCC + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                            ws.Cell(9, colCC + 5).DataType = XLDataType.Text;
                        }

                        Int32 iNamedRng = inPos + 1;

                        ws.Range(52, 5, 52, 24).AddToNamed("Cha1eSub" + strCostcode, XLScope.Workbook);
                        ws.Range(23, 1, 24, 24).AddToNamed("Cha1eProj" + strCostcode, XLScope.Workbook);
                        ws.Range(32, 1, 33, 24).AddToNamed("Cha1eFur" + strCostcode, XLScope.Workbook);

                        tmlt.AddVariable("Cha1eSub" + strCostcode, dsDataCC.Tables["subcontractTable"]);
                        tmlt.AddVariable("Cha1eProj" + strCostcode, dsDataCC.Tables["projectTable"]);
                        tmlt.AddVariable("Cha1eFur" + strCostcode, dsDataCC.Tables["futureTable"]);

                        Int32 colProjectCC = dsDataCC.Tables["projectTable"].Rows.Count;
                        Int32 colFutureCC = dsDataCC.Tables["futureTable"].Rows.Count;

                        //var rngSubCC = ws.Range(52, 5, 52, 23);
                        //rngSubCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                        //var rngprojectCC = ws.Range(23, 1, (colProjectCC + 23), 23);
                        //rngprojectCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                        //var rngfutureCC = ws.Range(Convert.ToInt32(colProjectCC + 38), 1, Convert.ToInt32(colFutureCC + colProjectCC + 39), 23);
                        //rngfutureCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    }

                    //var ws_xxx = wb.Worksheet("Sheet1");
                    //ws_xxx.CopyTo("Sample");
                    wb.Worksheet("Sheet1").Delete();

                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    switch (category)
                    {
                        case "E":
                            strFileName = "CHA1EGrp";
                            break;

                        case "N":
                            strFileName = "CHA1NEGrp";
                            break;

                        case "B":
                            strFileName = "CHA1EGrp_All";
                            break;
                    }
                    string strSimulation = string.Empty;
                    switch (simul)
                    {
                        case "A":
                            strSimulation = "_SimA";
                            break;

                        case "B":
                            strSimulation = "_SimB";
                            break;

                        case "C":
                            strSimulation = "_SimC";
                            break;

                        default:
                            strSimulation = string.Empty;
                            break;
                    }
                    strFileName = strFileName + yymm.Trim().Substring(2, 4).ToString() + strSimulation + ".xlsm";

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
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1NonEnggOld")]
        public async Task<ActionResult> GetCHA1NonEnggOld(string costcode, string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                                    "\\Cmplx\\cc\\CHA1E.xlsx";

            try
            {
                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

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
                        strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    return await t;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1MgmtOld")]
        public async Task<ActionResult> GetCHA1MgmtOld(string costcode, string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                                    "\\Cmplx\\cc\\CHA1E.xlsx";

            try
            {
                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

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
                        strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    return await t;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region current_code

        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1Engg")]
        public async Task<ActionResult> GetCHA1Engg(string yymm, string category, string simul, string yearmode, string reportMode)
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
                                                    "\\Cmplx\\mgmt\\CHA1EGRP.xlsx";

            int startRowProjects_cha1e;
            int endColProjects_cha1e;
            int endRowProjects_cha1e;

            int startRowProjects_cha1e24;
            int endColProjects_cha1e24;
            int endRowProjects_cha1e24;                       

            Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition_cha1e = new();
            Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition_cha1e24 = new();            

            Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition_cha1e = new();
            Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition_cha1e24 = new();            

            try
            {
                //byte[] m_Bytes = null;
                DataSet dsCC = new DataSet();

                string strFileName = string.Empty;
                switch (category)
                {
                    case "E":
                    case "EM":
                    case "ED":
                        strFileName = "CHA1EGrp";
                        break;                    

                    case "N" :
                    case "NM" :
                    case "ND" :
                        strFileName = "CHA1NEGrp";
                        break;                    

                    case "B":
                    case "BM":
                    case "BD":
                        strFileName = "CHA1EGrp_All";
                        break;

                    case "PROCUREMENT":
                    case "PROCUREMENT_MUMBAI":
                    case "PROCUREMENT_DELHI":
                        strFileName = "CHA1EGrp Procurement";
                        break;

                    case "PROCO":
                    case "PROCO_MUMBAI":
                    case "PROCO_DELHI":
                        strFileName = "CHA1EGrp Proco";
                        break;
                }
                string strSimulation = string.Empty;
                switch (simul)
                {
                    case "A":
                        strSimulation = "_SimA";
                        break;

                    case "B":
                        strSimulation = "_SimB";
                        break;

                    case "C":
                        strSimulation = "_SimC";
                        break;

                    default:
                        strSimulation = string.Empty;
                        break;
                }
                strFileName = strFileName + yymm.Trim().Substring(2, 4).ToString() + strSimulation + ".xlsx";

                //string strFilePathName = Path.Combine(Common.CustomFunctions.GetRAPRepository(appSettings.Value),appSettings.Value.RAPAppSettings.RAPTempRepository, strFileName);
                string strFilePathName = Path.Combine(Common.CustomFunctions.GetTempRepository(appSettings.Value), strFileName);

                IList<Rpt.ExcelHelper.WorkbookCharts> workbookCharts = new List<Rpt.ExcelHelper.WorkbookCharts>();

                IList<WSLineChartNew> workbookChartsMetadata = new List<WSLineChartNew>();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    // Get data

                    #region Cha1e

                    var ws_cha1e = wb.Worksheet("CHA1E");
                    DataSet dsData = new DataSet();                    


                    dsData = (DataSet)cha1egrpRepository.GetCha1EGrpData(yymm, category, simul, 18, Request.Headers["activeYear"].ToString());
                    foreach (DataRow gg1 in dsData.Tables["genTable"].Rows)
                    {
                        string strTitle = string.Empty;
                        switch (category)
                        {
                            case "E":
                            case "EM":
                            case "ED":
                                strTitle = "Engg CostCodes";
                                break;

                            case "N":
                            case "NM":
                            case "ND":
                                strTitle = "NonEngg CostCodes";
                                break;

                            case "B":
                            case "BM":
                            case "BD":
                                strTitle = "Engg and NonEngg CostCodes";
                                break;

                            case "PROCUREMENT":
                            case "PROCUREMENT_MUMBAI":
                            case "PROCUREMENT_DELHI":
                                strTitle = "Procurement CostCodes";
                                break;

                            case "PROCO":
                            case "PROCO_MUMBAI":
                            case "PROCO_DELHI":
                                strTitle = "Proco CostCodes";
                                break;
                        }

                        if (reportMode == "COMBINED")
                            ws_cha1e.Cell(3, 9).Value = "M + D";

                            ws_cha1e.Cell(6, 5).Value = strTitle;                                                   // E6
                        ws_cha1e.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg1["changed_nemps"].ToString()) == 0)
                        {
                            ws_cha1e.Cell(7, 5).Value = Convert.ToInt32("0" + gg1["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_cha1e.Cell(7, 5).Value = Convert.ToInt32("0" + gg1["changed_nemps"].ToString());     // E7
                        }
                        ws_cha1e.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e.Cell(8, 5).Value = Convert.ToInt32("0" + gg1["noofemps"].ToString());         // E8
                        ws_cha1e.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg1["noofcons"].ToString()) > 0)
                        {
                            ws_cha1e.Cell(8, 7).Value = "Includes " + gg1["noofcons"].ToString() + " Consultants ";
                            ws_cha1e.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_cha1e.Cell(2, 22).Value = "'" + gg1["pdate"].ToString();                            // U2
                        ws_cha1e.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);  // U3
                        ws_cha1e.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_cha1e.Cell(4, 21).Value = "Jan - Dec";                                          // U4
                        }
                        else
                        {
                            ws_cha1e.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_cha1e.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata = ws_cha1e.Cell(9, 4).InsertTable(dsData.Tables["alldataTable"].AsEnumerable());
                    tAlldata.Theme = XLTableTheme.None;
                    tAlldata.ShowHeaderRow = false;
                    tAlldata.ShowAutoFilter = false;

                    var rangeClear = ws_cha1e.Range(9, 4, 16, 4);
                    rangeClear.Clear();
                    rangeClear.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata = ws_cha1e.Range(9, 5, 16, 23);
                    rngdata.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata.Style.NumberFormat.Format = "0";
                    rngdata.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader = ws_cha1e.Range(9, 4, 9, 23);
                    rngheader.Style.Font.Bold = true;
                    rngheader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc2 in dsData.Tables["colsTable"].Columns)
                    {
                        Int32 col = dsData.Tables["colsTable"].Columns.IndexOf(cc2);
                        string strVal = dsData.Tables["colsTable"].Rows[0][cc2.ColumnName.ToString()].ToString();
                        ws_cha1e.Cell(9, col + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws_cha1e.Cell(9, col + 5).DataType = XLDataType.Text;
                    }

                    tmlt.AddVariable("Cha1eSub", dsData.Tables["subcontractTable"]);
                    tmlt.AddVariable("Cha1eProj", dsData.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1eFur", dsData.Tables["futureTable"]);

                    Int32 colProject = dsData.Tables["projectTable"].Rows.Count;
                    Int32 colFuture = dsData.Tables["futureTable"].Rows.Count;

                    //var rngproject = ws_cha1e.Range(23, 1, (colProject + 23), 22);
                    //rngproject.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    //var rngfuture = ws_cha1e.Range((colProject + 38), 1, (colFuture + colProject + 38), 22);
                    //rngfuture.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                                        
                    ws_cha1e.Range(22, 1, 22, 24).AddToNamed("ProjectHeader", XLScope.Worksheet);
                    ws_cha1e.Range(31, 1, 31, 24).AddToNamed("ExptProjectHeader", XLScope.Worksheet);
                    ws_cha1e.Range(32, 1, 33, 24).AddToNamed("Future_tpl", XLScope.Worksheet);
                    ws_cha1e.Range(38, 1, 38, 24).AddToNamed("ActiveProjectTotal", XLScope.Worksheet);
                    ws_cha1e.Range(41, 1, 41, 24).AddToNamed("CostHeader", XLScope.Worksheet);
                    ws_cha1e.Range(57, 1, 57, 24).AddToNamed("CostcenterHeader", XLScope.Worksheet);
                    
                    ws_cha1e.Cell(65, 1).AddToNamed("ChartLocationStart", XLScope.Worksheet);
                    ws_cha1e.Cell(107, 24).AddToNamed("ChartLocationEnd", XLScope.Worksheet);
                    
                    #endregion

                    #region Cha1e_24

                    var ws_cha1e24 = wb.Worksheet("CHA1E_24");
                    DataSet dsData24 = new DataSet();

                    dsData24 = (DataSet)cha1egrpRepository.GetCha1EGrpData(yymm, category, simul, 24, Request.Headers["activeYear"].ToString());
                    foreach (DataRow gg2 in dsData24.Tables["genTable"].Rows)
                    {
                        string strTitle24 = string.Empty;
                        switch (category)
                        {
                            case "E":
                            case "EM":
                            case "ED":
                                strTitle24 = "Engg CostCodes";
                                break;

                            case "N":
                            case "NM":
                            case "ND":
                                strTitle24 = "NonEngg CostCodes";
                                break;

                            case "B":
                            case "BM":
                            case "BD":
                                strTitle24 = "Engg and NonEngg CostCodes";
                                break;

                            case "PROCUREMENT":
                            case "PROCUREMENT_MUMBAI":
                            case "PROCUREMENT_DELHI":
                                strTitle24 = "Procurement CostCodes";
                                break;

                            case "PROCO":
                            case "PROCO_MUMBAI":
                            case "PROCO_DELHI":
                                strTitle24 = "Proco CostCodes";
                                break;
                        }

                        if (reportMode == "COMBINED")
                            ws_cha1e24.Cell(3, 9).Value = "M + D";

                        ws_cha1e24.Cell(6, 5).Value = strTitle24;                                                  // E6
                        ws_cha1e24.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg2["changed_nemps"].ToString()) == 0)
                        {
                            ws_cha1e24.Cell(7, 5).Value = Convert.ToInt32("0" + gg2["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_cha1e24.Cell(7, 5).Value = Convert.ToInt32("0" + gg2["changed_nemps"].ToString());     // E7
                        }
                        ws_cha1e24.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e24.Cell(8, 5).Value = Convert.ToInt32("0" + gg2["noofemps"].ToString());         // E8
                        ws_cha1e24.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg2["noofcons"].ToString()) > 0)
                        {
                            ws_cha1e24.Cell(8, 7).Value = "Includes " + gg2["noofcons"].ToString() + " Consultants ";
                            ws_cha1e24.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_cha1e24.Cell(2, 22).Value = "'" + gg2["pdate"].ToString();                            // U2
                        ws_cha1e24.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e24.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_cha1e24.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_cha1e24.Cell(4, 22).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_cha1e24.Cell(4, 22).Value = "Apr - Mar";                                         // U4
                        }
                        ws_cha1e24.Cell(4, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata24 = ws_cha1e24.Cell(9, 4).InsertTable(dsData24.Tables["alldataTable"].AsEnumerable());
                    tAlldata24.Theme = XLTableTheme.None;
                    tAlldata24.ShowHeaderRow = false;
                    tAlldata24.ShowAutoFilter = false;

                    var rangeClear24 = ws_cha1e24.Range(9, 4, 16, 4);
                    rangeClear24.Clear();
                    rangeClear24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata24 = ws_cha1e24.Range(9, 5, 16, 29);
                    rngdata24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata24.Style.NumberFormat.Format = "0";
                    rngdata24.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader24 = ws_cha1e24.Range(9, 4, 9, 29);
                    rngheader24.Style.Font.Bold = true;
                    rngheader24.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader24.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader24.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc2 in dsData24.Tables["colsTable"].Columns)
                    {
                        Int32 col24 = dsData24.Tables["colsTable"].Columns.IndexOf(cc2);
                        string strVal24 = dsData24.Tables["colsTable"].Rows[0][cc2.ColumnName.ToString()].ToString();
                        ws_cha1e24.Cell(9, col24 + 5).Value = "'" + strVal24.Substring(0, 4) + "/" + strVal24.Substring(4, 2);
                        ws_cha1e24.Cell(9, col24 + 5).DataType = XLDataType.Text;
                    }

                    tmlt.AddVariable("Cha1e24Sub", dsData24.Tables["subcontractTable"]);
                    tmlt.AddVariable("Cha1e24Proj", dsData24.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e24Fur", dsData24.Tables["futureTable"]);

                    Int32 colProject24 = dsData24.Tables["projectTable"].Rows.Count;
                    Int32 colFuture24 = dsData24.Tables["futureTable"].Rows.Count;

                    ws_cha1e24.Range(22, 1, 22, 30).AddToNamed("ProjectHeader24", XLScope.Worksheet);
                    ws_cha1e24.Range(31, 1, 31, 30).AddToNamed("ExptProjectHeader24", XLScope.Worksheet);
                    ws_cha1e24.Range(32, 1, 33, 30).AddToNamed("Future24_tpl", XLScope.Worksheet);
                    ws_cha1e24.Range(38, 1, 38, 30).AddToNamed("ActiveProjectTotal24", XLScope.Worksheet);
                    ws_cha1e24.Range(41, 1, 41, 30).AddToNamed("CostHeader24", XLScope.Worksheet);
                    ws_cha1e24.Range(57, 1, 57, 30).AddToNamed("CostcenterHeader24", XLScope.Worksheet);

                    ws_cha1e24.Cell(65, 1).AddToNamed("ChartLocationStart24", XLScope.Worksheet);
                    ws_cha1e24.Cell(107, 30).AddToNamed("ChartLocationEnd24", XLScope.Worksheet);

                    #endregion

                    #region costcode sheets

                    if (reportMode == "COMBINED" && (category == "E" || category == "N" || category == "B"))
                        category = category + "M";

                    dsCC = (DataSet)cha1egrpRepository.GetCostcodeList(category);

                    foreach (DataRow rowCC in dsCC.Tables["costcodeTable"].Rows)
                    {
                        Int32 inPos = dsCC.Tables["costcodeTable"].Rows.IndexOf(rowCC) + 4;
                        string strCostcode = rowCC["costcode"].ToString();
                        string strCCName = rowCC["name"].ToString();

                        var ws_sheet = wb.Worksheet("Sheet1");
                        ws_sheet.CopyTo(strCostcode, inPos);

                        var ws = wb.Worksheet(strCostcode);

                        ws.ShowGridLines = false;

                        DataSet dsDataCC = new DataSet();

                        dsDataCC = (DataSet)cha1egrpRepository.GetCha1ECostcodeData(yymm, strCostcode.ToString(), simul, Request.Headers["activeYear"].ToString(), reportMode);
                        var noofcons = 0;
                        foreach (DataRow gg3 in dsDataCC.Tables["genTable"].Rows)
                        {
                            ws.Cell(6, 5).Value = "'" + strCostcode.ToString();                             // E6
                            ws.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + gg3["changed_nemps"].ToString()) == 0)
                            {
                                ws.Cell(7, 5).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());     // E7
                            }
                            else
                            {
                                ws.Cell(7, 5).Value = Convert.ToInt32("0" + gg3["changed_nemps"].ToString());     // E7
                            }
                            ws.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(8, 5).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());         // E8
                            ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + gg3["noofcons"].ToString()) > 0)
                            {
                                ws.Cell(8, 10).Value = "Includes " + gg3["noofcons"].ToString() + " Consultants ";
                                ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                                noofcons = Convert.ToInt32("0" + gg3["noofcons"].ToString());
                            }
                            ws.Cell(6, 18).Value = gg3["abbr"].ToString().ToString();                        // R6
                            ws.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(7, 18).Value = gg3["name"].ToString().ToString();                        // R7
                            ws.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(2, 22).Value = "'" + gg3["pdate"].ToString();                            // U2
                            ws.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                            ws.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (yearmode == "J")
                            {
                                ws.Cell(4, 22).Value = "Jan - Dec";                                         // U4
                            }
                            else
                            {
                                ws.Cell(4, 22).Value = "Apr - Mar";                                         // U4
                            }
                            ws.Cell(4, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }

                        if (reportMode == "COMBINED")
                        {
                            ws.Cell(3, 9).Value = "M + D";
                            foreach (DataRow gg3 in dsDataCC.Tables["genOtherTable"].Rows)
                            {
                                if (ws.Cell(6, 5).Value.ToString() != gg3["costcode"].ToString())
                                {
                                    ws.Cell(6, 5).Value = ws.Cell(6, 5).Value + " + " + gg3["costcode"];
                                    if (Convert.ToInt32("0" + gg3["changed_nemps"].ToString()) == 0)
                                        ws.Cell(7, 5).Value = Convert.ToInt32(ws.Cell(7, 5).Value.ToString()) + Convert.ToInt32("0" + gg3["noofemps"].ToString());     // E7                            
                                    else
                                        ws.Cell(7, 5).Value = Convert.ToInt32(ws.Cell(7, 5).Value.ToString()) + Convert.ToInt32("0" + gg3["changed_nemps"].ToString());     // E7

                                    ws.Cell(8, 5).Value = Convert.ToInt32(ws.Cell(8, 5).Value.ToString()) + Convert.ToInt32("0" + gg3["noofemps"].ToString());     // E7

                                    ws.Cell(7, 7).Value = "Delhi Office Emps";
                                    if (Convert.ToInt32("0" + gg3["changed_nemps"].ToString()) == 0)
                                        ws.Cell(7, 9).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());     // E7                                
                                    else
                                        ws.Cell(7, 9).Value = Convert.ToInt32("0" + gg3["changed_nemps"].ToString());     // E7

                                    ws.Cell(7, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                                    ws.Cell(8, 7).Value = "Delhi Office Emps";
                                    ws.Cell(8, 9).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());         // E8
                                    ws.Cell(8, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;


                                    if (Convert.ToInt32("0" + gg3["noofcons"].ToString()) > 0)
                                    {
                                        ws.Cell(8, 10).Value = "Includes " + noofcons + Convert.ToInt32(gg3["noofcons"].ToString()) + " Consultants ";
                                    }
                                }
                            }
                        }

                        var tAlldataCC = ws.Cell(9, 4).InsertTable(dsDataCC.Tables["alldataTable"].AsEnumerable());
                        tAlldataCC.Theme = XLTableTheme.None;
                        tAlldataCC.ShowHeaderRow = false;
                        tAlldataCC.ShowAutoFilter = false;

                        var rangeClearCC = ws.Range(9, 4, 16, 4);
                        rangeClearCC.Clear();
                        rangeClearCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                        var rngdataCC = ws.Range(9, 5, 16, 23);
                        rngdataCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                        rngdataCC.Style.NumberFormat.Format = "0";
                        rngdataCC.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                        var rngheaderCC = ws.Range(9, 4, 9, 23);
                        rngheaderCC.Style.Font.Bold = true;
                        rngheaderCC.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                        rngheaderCC.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                        rngheaderCC.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                        foreach (DataColumn cc3 in dsDataCC.Tables["colsTable"].Columns)
                        {
                            Int32 colCC = dsDataCC.Tables["colsTable"].Columns.IndexOf(cc3);
                            string strVal = dsDataCC.Tables["colsTable"].Rows[0][cc3.ColumnName.ToString()].ToString();
                            ws.Cell(9, colCC + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                            ws.Cell(9, colCC + 5).DataType = XLDataType.Text;
                        }

                        Int32 colProjectCC = dsDataCC.Tables["projectTable"].Rows.Count;
                        Int32 colFutureCC = dsDataCC.Tables["futureTable"].Rows.Count;

                        Int32 iNamedRng = inPos + 1;

                        ws.Range(52, 5, 52, 24).AddToNamed("Cha1eSub" + strCostcode, XLScope.Workbook);
                        ws.Range(23, 1, 24, 24).AddToNamed("Cha1eProj" + strCostcode, XLScope.Workbook);
                        ws.Range(32, 1, 33, 24).AddToNamed("Cha1eFur" + strCostcode, XLScope.Workbook);

                        tmlt.AddVariable("Cha1eSub" + strCostcode, dsDataCC.Tables["subcontractTable"]);
                        tmlt.AddVariable("Cha1eProj" + strCostcode, dsDataCC.Tables["projectTable"]);
                        tmlt.AddVariable("Cha1eFur" + strCostcode, dsDataCC.Tables["futureTable"]);
                        
                        ws.Range(22, 1, 22, 24).AddToNamed("ProjectHeader" + strCostcode, XLScope.Worksheet);
                        ws.Range(31, 1, 31, 24).AddToNamed("ExptProjectHeader" + strCostcode, XLScope.Worksheet);
                        ws.Range(32, 1, 33, 24).AddToNamed("Future" + strCostcode + "_tpl", XLScope.Worksheet);
                        ws.Range(38, 1, 38, 24).AddToNamed("ActiveProjectTotal" + strCostcode, XLScope.Worksheet);
                        ws.Range(41, 1, 41, 24).AddToNamed("CostHeader" + strCostcode, XLScope.Worksheet);
                        ws.Range(57, 1, 57, 24).AddToNamed("CostcenterHeader" + strCostcode, XLScope.Worksheet); 
                        
                        ws.Cell(65, 1).AddToNamed("ChartLocationStart" + strCostcode, XLScope.Worksheet);
                        ws.Cell(107, 24).AddToNamed("ChartLocationEnd" + strCostcode, XLScope.Worksheet);                        
                    }

                    #endregion 

                    tmlt.Generate();

                    // Manipuation for color active & future projects seperately / graphs 

                    #region Cha1e manipulation

                    startRowProjects_cha1e = ws_cha1e.NamedRange("Future_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();
                    endColProjects_cha1e = ws_cha1e.NamedRange("Future_tpl").Ranges.FirstOrDefault().LastCell().WorksheetColumn().ColumnNumber();
                    endRowProjects_cha1e = ws_cha1e.NamedRange("Future_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();

                    int counterRow_cha1e = startRowProjects_cha1e - 1;                    

                    int rowCount_cha1e = counterRow_cha1e;
                    while (rowCount_cha1e <= endRowProjects_cha1e)
                    {
                        counterRow_cha1e++;

                        if (ws_cha1e.Cell(counterRow_cha1e, endColProjects_cha1e).Value.ToString() == "1")
                        {
                            ws_cha1e.Range("A" + counterRow_cha1e, "W" + counterRow_cha1e).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                        }
                        rowCount_cha1e++;
                    }

                    var rng_active_project_total_cha1e = ws_cha1e.NamedRange("ActiveProjectTotal").Ranges.FirstOrDefault();
                    rng_active_project_total_cha1e.Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);

                    var rngheader_project_cha1e = ws_cha1e.NamedRange("ProjectHeader").Ranges.FirstOrDefault();
                    rngheader_project_cha1e.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_project_cha1e.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_exptproject_cha1e = ws_cha1e.NamedRange("ExptProjectHeader").Ranges.FirstOrDefault();
                    rngheader_exptproject_cha1e.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_exptproject_cha1e.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_cost_cha1e = ws_cha1e.NamedRange("CostHeader").Ranges.FirstOrDefault();
                    rngheader_cost_cha1e.Style.Border.TopBorder = XLBorderStyleValues.Medium;
                    rngheader_cost_cha1e.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    var rngheader_costcenter_cha1e = ws_cha1e.NamedRange("CostcenterHeader").Ranges.FirstOrDefault();
                    rngheader_costcenter_cha1e.Style.Border.TopBorder = XLBorderStyleValues.Medium;
                    rngheader_costcenter_cha1e.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    
                    chartFromPosition_cha1e = GetChartPositionCoOrdinates(ws_cha1e, "ChartLocationStart");
                    chartFromPosition_cha1e.Col = chartFromPosition_cha1e.Col > 0 ? chartFromPosition_cha1e.Col - 1 : chartFromPosition_cha1e.Col;
                    chartFromPosition_cha1e.Row = chartFromPosition_cha1e.Row > 0 ? chartFromPosition_cha1e.Row - 1 : chartFromPosition_cha1e.Row;
                    chartToPosition_cha1e = GetChartPositionCoOrdinates(ws_cha1e, "ChartLocationEnd");
                    workbookCharts.Add(new ExcelHelper.WorkbookCharts { SheetName = ws_cha1e.Name, FromPosition = chartFromPosition_cha1e, ToPosition = chartToPosition_cha1e });

                    int lastRowFutureProjectws_cha1e = ws_cha1e.NamedRange("Future_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();
                    var chartMetadataws_cha1e = Rpt.ExcelChartHelper.GetChartMetaData(ws_cha1e.Name, lastRowFutureProjectws_cha1e);
                    workbookChartsMetadata.Add(chartMetadataws_cha1e);

                    #endregion

                    #region Cha1e_24 manipulation

                    startRowProjects_cha1e24 = ws_cha1e24.NamedRange("Future24_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();

                    endColProjects_cha1e24 = ws_cha1e24.NamedRange("Future24_tpl").Ranges.FirstOrDefault().LastCell().WorksheetColumn().ColumnNumber();
                    endRowProjects_cha1e24 = ws_cha1e24.NamedRange("Future24_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();

                    int counterRow_cha1e24 = startRowProjects_cha1e24 - 1;

                    int rowCount_cha1e24 = counterRow_cha1e24;
                    while (rowCount_cha1e24 <= endRowProjects_cha1e24)
                    {
                        counterRow_cha1e24++;

                        if (ws_cha1e24.Cell(counterRow_cha1e24, endColProjects_cha1e24).Value.ToString() == "1")
                        {
                            ws_cha1e24.Range("A" + counterRow_cha1e24, "W" + counterRow_cha1e24).Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);
                        }
                        rowCount_cha1e24++;
                    }

                    var rng_active_project_total_cha1e24 = ws_cha1e24.NamedRange("ActiveProjectTotal24").Ranges.FirstOrDefault();
                    rng_active_project_total_cha1e24.Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);

                    var rngheader_project_cha1e24 = ws_cha1e24.NamedRange("ProjectHeader24").Ranges.FirstOrDefault();
                    rngheader_project_cha1e24.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_project_cha1e24.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_exptproject_cha1e24 = ws_cha1e24.NamedRange("ExptProjectHeader24").Ranges.FirstOrDefault();
                    rngheader_exptproject_cha1e24.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader_exptproject_cha1e24.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                    var rngheader_cost_cha1e24 = ws_cha1e24.NamedRange("CostHeader24").Ranges.FirstOrDefault();
                    rngheader_cost_cha1e24.Style.Border.TopBorder = XLBorderStyleValues.Medium;
                    rngheader_cost_cha1e24.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    var rngheader_costcenter_cha1e24 = ws_cha1e24.NamedRange("CostcenterHeader24").Ranges.FirstOrDefault();
                    rngheader_costcenter_cha1e24.Style.Border.TopBorder = XLBorderStyleValues.Medium;
                    rngheader_costcenter_cha1e24.Style.Border.BottomBorder = XLBorderStyleValues.Medium;

                    int lastRowFutureProjectws_cha1e24 = ws_cha1e24.NamedRange("Future24_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();
                    var chartMetadataws_cha1e24 = Rpt.ExcelChartHelper.GetChartMetaData24(ws_cha1e24.Name, lastRowFutureProjectws_cha1e24);
                    workbookChartsMetadata.Add(chartMetadataws_cha1e24);

                    chartFromPosition_cha1e24 = GetChartPositionCoOrdinates(ws_cha1e24, "ChartLocationStart24");
                    chartFromPosition_cha1e24.Col = chartFromPosition_cha1e24.Col > 0 ? chartFromPosition_cha1e24.Col - 1 : chartFromPosition_cha1e24.Col;
                    chartFromPosition_cha1e24.Row = chartFromPosition_cha1e24.Row > 0 ? chartFromPosition_cha1e24.Row - 1 : chartFromPosition_cha1e24.Row;
                    chartToPosition_cha1e24 = GetChartPositionCoOrdinates(ws_cha1e24, "ChartLocationEnd24");
                    workbookCharts.Add(new ExcelHelper.WorkbookCharts { SheetName = ws_cha1e24.Name, FromPosition = chartFromPosition_cha1e24, ToPosition = chartToPosition_cha1e24 });

                    #endregion
                                        
                    #region Costcode sheets maniputaion

                    foreach (DataRow rowCC in dsCC.Tables["costcodeTable"].Rows)
                    {
                        string strCostcode = rowCC["costcode"].ToString();
                        var ws = wb.Worksheet(strCostcode);

                        int startRowProjects;
                        int endColProjects;
                        int endRowProjects;

                        Rpt.ExcelHelper.ExcelCoOrdinate chartFromPosition = new();
                        Rpt.ExcelHelper.ExcelCoOrdinate chartToPosition = new();

                        startRowProjects = ws.NamedRange("Future" + strCostcode + "_tpl").Ranges.FirstOrDefault().FirstCell().WorksheetRow().RowNumber();

                        endColProjects = ws.NamedRange("Future" + strCostcode + "_tpl").Ranges.FirstOrDefault().LastCell().WorksheetColumn().ColumnNumber();
                        endRowProjects = ws.NamedRange("Future" + strCostcode + "_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();

                        int counterRow = startRowProjects - 1;

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

                        var rng_active_project_total = ws.NamedRange("ActiveProjectTotal" + strCostcode).Ranges.FirstOrDefault();
                        rng_active_project_total.Style.Font.FontColor = XLColor.FromArgb(0, 112, 192);

                        var rngheader_project = ws.NamedRange("ProjectHeader" + strCostcode).Ranges.FirstOrDefault();
                        rngheader_project.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                        rngheader_project.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                        var rngheader_exptproject = ws.NamedRange("ExptProjectHeader" + strCostcode).Ranges.FirstOrDefault();
                        rngheader_exptproject.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                        rngheader_exptproject.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                        var rngheader_cost = ws.NamedRange("CostHeader" + strCostcode).Ranges.FirstOrDefault();
                        rngheader_cost.Style.Border.TopBorder = XLBorderStyleValues.Medium;
                        rngheader_cost.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                        var rngheader_costcenter = ws.NamedRange("CostcenterHeader" + strCostcode).Ranges.FirstOrDefault();
                        rngheader_costcenter.Style.Border.TopBorder = XLBorderStyleValues.Medium;
                        rngheader_costcenter.Style.Border.BottomBorder = XLBorderStyleValues.Medium;

                        int lastRowFutureProject = ws.NamedRange("Future" + strCostcode + "_tpl").Ranges.FirstOrDefault().LastCell().WorksheetRow().RowNumber();
                        var chartMetadata = Rpt.ExcelChartHelper.GetChartMetaData(ws.Name, lastRowFutureProject);
                        workbookChartsMetadata.Add(chartMetadata);

                        chartFromPosition = GetChartPositionCoOrdinates(ws, "ChartLocationStart" + strCostcode);
                        chartFromPosition.Col = chartFromPosition.Col > 0 ? chartFromPosition.Col - 1 : chartFromPosition.Col;
                        chartFromPosition.Row = chartFromPosition.Row > 0 ? chartFromPosition.Row - 1 : chartFromPosition.Row;
                        chartToPosition = GetChartPositionCoOrdinates(ws, "ChartLocationEnd" + strCostcode);
                        workbookCharts.Add(new ExcelHelper.WorkbookCharts { SheetName = ws.Name, FromPosition = chartFromPosition, ToPosition = chartToPosition });
                    }

                    #endregion

                    wb.Worksheet("Sheet1").Delete();
                    wb.Worksheet("Help").Select();

                    // Remove unused named ranges
                    foreach (var rng in wb.NamedRanges)
                    {
                        if (!rng.IsValid)
                            wb.NamedRanges.Delete(rng.Name);
                    }

                    wb.SaveAs(strFilePathName);
             
                }

                OpenXMLExcelChart chart = new();               

                chart.InsertChartNew(strFilePathName, workbookChartsMetadata);

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
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1NonEngg")]
        public async Task<ActionResult> GetCHA1NonEngg(string costcode, string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                                    "\\Cmplx\\cc\\CHA1E.xlsx";

            try
            {
                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

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
                        strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    return await t;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1Mgmt")]
        public async Task<ActionResult> GetCHA1Mgmt(string costcode, string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                                    "\\Cmplx\\cc\\CHA1E.xlsx";

            try
            {
                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

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
                        strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    return await t;
                }
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


        #endregion

        #region xlsx

        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1EnggNew")]
        public async Task<ActionResult> GetCHA1EnggNew(string yymm, string category, string simul, string yearmode)
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
                                                    "\\Cmplx\\mgmt\\CHA1EGRP.xlsm";

            try
            {
                byte[] m_Bytes = null;
                DataSet dsCC = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    //===== CH1E Group  =======================================================================================
                    var ws_cha1e = wb.Worksheet("CHA1E");
                    DataSet dsData = new DataSet();

                    dsData = (DataSet)cha1egrpRepository.GetCha1EGrpData(yymm, category, simul, 18, Request.Headers["activeYear"].ToString());
                    foreach (DataRow gg1 in dsData.Tables["genTable"].Rows)
                    {
                        string strTitle = string.Empty;
                        switch (category)
                        {
                            case "E":
                                strTitle = "Engg CostCodes";
                                break;

                            case "N":
                                strTitle = "NonEngg CostCodes";
                                break;

                            case "B":
                                strTitle = "Engg and NonEngg CostCodes";
                                break;
                        }

                        ws_cha1e.Cell(6, 5).Value = strTitle;                                                   // E6
                        ws_cha1e.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg1["changed_nemps"].ToString()) == 0)
                        {
                            ws_cha1e.Cell(7, 5).Value = Convert.ToInt32("0" + gg1["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_cha1e.Cell(7, 5).Value = Convert.ToInt32("0" + gg1["changed_nemps"].ToString());     // E7
                        }
                        ws_cha1e.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e.Cell(8, 5).Value = Convert.ToInt32("0" + gg1["noofemps"].ToString());         // E8
                        ws_cha1e.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg1["noofcons"].ToString()) > 0)
                        {
                            ws_cha1e.Cell(8, 7).Value = "Includes " + gg1["noofcons"].ToString() + " Consultants ";
                            ws_cha1e.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_cha1e.Cell(2, 22).Value = "'" + gg1["pdate"].ToString();                            // U2
                        ws_cha1e.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);  // U3
                        ws_cha1e.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_cha1e.Cell(4, 21).Value = "Jan - Dec";                                          // U4
                        }
                        else
                        {
                            ws_cha1e.Cell(4, 21).Value = "Apr - Mar";                                         // U4
                        }
                        ws_cha1e.Cell(4, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata = ws_cha1e.Cell(9, 4).InsertTable(dsData.Tables["alldataTable"].AsEnumerable());
                    tAlldata.Theme = XLTableTheme.None;
                    tAlldata.ShowHeaderRow = false;
                    tAlldata.ShowAutoFilter = false;

                    var rangeClear = ws_cha1e.Range(9, 4, 16, 4);
                    rangeClear.Clear();
                    rangeClear.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata = ws_cha1e.Range(9, 5, 16, 23);
                    rngdata.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata.Style.NumberFormat.Format = "0";
                    rngdata.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader = ws_cha1e.Range(9, 4, 9, 23);
                    rngheader.Style.Font.Bold = true;
                    rngheader.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc2 in dsData.Tables["colsTable"].Columns)
                    {
                        Int32 col = dsData.Tables["colsTable"].Columns.IndexOf(cc2);
                        string strVal = dsData.Tables["colsTable"].Rows[0][cc2.ColumnName.ToString()].ToString();
                        ws_cha1e.Cell(9, col + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws_cha1e.Cell(9, col + 5).DataType = XLDataType.Text;
                    }

                    tmlt.AddVariable("Cha1eSub", dsData.Tables["subcontractTable"]);
                    tmlt.AddVariable("Cha1eProj", dsData.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1eFur", dsData.Tables["futureTable"]);

                    Int32 colProject = dsData.Tables["projectTable"].Rows.Count;
                    Int32 colFuture = dsData.Tables["futureTable"].Rows.Count;

                    //var rngSub = ws_cha1e.Range(52, 5, 52, 23);
                    //rngSub.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngproject = ws_cha1e.Range(23, 1, (colProject + 23), 23);
                    //rngproject.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngfuture = ws_cha1e.Range((colProject + 38), 1, (colFuture + colProject + 38), 23);
                    //rngfuture.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //===== CH1E Group 24 months  =============================================================================
                    var ws_cha1e24 = wb.Worksheet("CHA1E_24");
                    DataSet dsData24 = new DataSet();

                    dsData24 = (DataSet)cha1egrpRepository.GetCha1EGrpData(yymm, category, simul, 24, Request.Headers["activeYear"].ToString());
                    foreach (DataRow gg2 in dsData24.Tables["genTable"].Rows)
                    {
                        string strTitle24 = string.Empty;
                        switch (category)
                        {
                            case "E":
                                strTitle24 = "Engg CostCodes";
                                break;

                            case "N":
                                strTitle24 = "NonEngg CostCodes";
                                break;

                            case "B":
                                strTitle24 = "Engg and NonEngg CostCodes";
                                break;
                        }

                        ws_cha1e.Cell(6, 5).Value = strTitle24;                                                  // E6
                        ws_cha1e24.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg2["changed_nemps"].ToString()) == 0)
                        {
                            ws_cha1e24.Cell(7, 5).Value = Convert.ToInt32("0" + gg2["noofemps"].ToString());     // E7
                        }
                        else
                        {
                            ws_cha1e24.Cell(7, 5).Value = Convert.ToInt32("0" + gg2["changed_nemps"].ToString());     // E7
                        }
                        ws_cha1e24.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e24.Cell(8, 5).Value = Convert.ToInt32("0" + gg2["noofemps"].ToString());         // E8
                        ws_cha1e24.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (Convert.ToInt32("0" + gg2["noofcons"].ToString()) > 0)
                        {
                            ws_cha1e24.Cell(8, 7).Value = "Includes " + gg2["noofcons"].ToString() + " Consultants ";
                            ws_cha1e24.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }
                        ws_cha1e24.Cell(2, 22).Value = "'" + gg2["pdate"].ToString();                            // U2
                        ws_cha1e24.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        ws_cha1e24.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                        ws_cha1e24.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        if (yearmode == "J")
                        {
                            ws_cha1e24.Cell(4, 22).Value = "Jan - Dec";                                         // U4
                        }
                        else
                        {
                            ws_cha1e24.Cell(4, 22).Value = "Apr - Mar";                                         // U4
                        }
                        ws_cha1e24.Cell(4, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                    }

                    var tAlldata24 = ws_cha1e24.Cell(9, 4).InsertTable(dsData24.Tables["alldataTable"].AsEnumerable());
                    tAlldata24.Theme = XLTableTheme.None;
                    tAlldata24.ShowHeaderRow = false;
                    tAlldata24.ShowAutoFilter = false;

                    var rangeClear24 = ws_cha1e24.Range(9, 4, 16, 4);
                    rangeClear24.Clear();
                    rangeClear24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    var rngdata24 = ws_cha1e24.Range(9, 5, 16, 29);
                    rngdata24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    rngdata24.Style.NumberFormat.Format = "0";
                    rngdata24.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                    var rngheader24 = ws_cha1e24.Range(9, 4, 9, 29);
                    rngheader24.Style.Font.Bold = true;
                    rngheader24.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    rngheader24.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    rngheader24.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    foreach (DataColumn cc2 in dsData24.Tables["colsTable"].Columns)
                    {
                        Int32 col24 = dsData24.Tables["colsTable"].Columns.IndexOf(cc2);
                        string strVal24 = dsData24.Tables["colsTable"].Rows[0][cc2.ColumnName.ToString()].ToString();
                        ws_cha1e24.Cell(9, col24 + 5).Value = "'" + strVal24.Substring(0, 4) + "/" + strVal24.Substring(4, 2);
                        ws_cha1e24.Cell(9, col24 + 5).DataType = XLDataType.Text;
                    }

                    tmlt.AddVariable("Cha1e24Sub", dsData24.Tables["subcontractTable"]);
                    tmlt.AddVariable("Cha1e24Proj", dsData24.Tables["projectTable"]);
                    tmlt.AddVariable("Cha1e24Fur", dsData24.Tables["futureTable"]);

                    Int32 colProject24 = dsData24.Tables["projectTable"].Rows.Count;
                    Int32 colFuture24 = dsData24.Tables["futureTable"].Rows.Count;

                    ////var rngSub24 = ws_cha1e24.Range(52, 5, 52, 29);
                    ////rngSub24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngproject24 = ws_cha1e24.Range(23, 1, (colProject24 + 23), 30);
                    //rngproject24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //var rngfuture24 = ws_cha1e24.Range((23 + colProject24 + 9), 1, (23 + colProject24 + 38 + colFuture24), 30);
                    //rngfuture24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    ////var rngfuture24 = ws_cha1e24.Range((colProject24 + 38), 1, (colFuture24 + colProject24 + 38), 29);
                    ////rngfuture24.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                    //===== Costcode sheets ===================================================================================
                    dsCC = (DataSet)cha1egrpRepository.GetCostcodeList(category);

                    foreach (DataRow rowCC in dsCC.Tables["costcodeTable"].Rows)
                    {
                        Int32 inPos = dsCC.Tables["costcodeTable"].Rows.IndexOf(rowCC) + 4;
                        string strCostcode = rowCC["costcode"].ToString();
                        string strCCName = rowCC["name"].ToString();

                        var ws_sheet = wb.Worksheet("Sheet1");
                        ws_sheet.CopyTo(strCostcode, inPos);

                        var ws = wb.Worksheet(strCostcode);

                        ws.ShowGridLines = false;

                        DataSet dsDataCC = new DataSet();

                        dsDataCC = (DataSet)cha1egrpRepository.GetCha1ECostcodeData(yymm, strCostcode.ToString(), simul, Request.Headers["activeYear"].ToString(), "");

                        foreach (DataRow gg3 in dsDataCC.Tables["genTable"].Rows)
                        {
                            ws.Cell(6, 5).Value = "'" + strCostcode.ToString();                             // E6
                            ws.Cell(6, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + gg3["changed_nemps"].ToString()) == 0)
                            {
                                ws.Cell(7, 5).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());     // E7
                            }
                            else
                            {
                                ws.Cell(7, 5).Value = Convert.ToInt32("0" + gg3["changed_nemps"].ToString());     // E7
                            }
                            ws.Cell(7, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(8, 5).Value = Convert.ToInt32("0" + gg3["noofemps"].ToString());         // E8
                            ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (Convert.ToInt32("0" + gg3["noofcons"].ToString()) > 0)
                            {
                                ws.Cell(8, 7).Value = "Includes " + gg3["noofcons"].ToString() + " Consultants ";
                                ws.Cell(8, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            }
                            ws.Cell(6, 18).Value = gg3["abbr"].ToString().ToString();                        // R6
                            ws.Cell(6, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(7, 18).Value = gg3["name"].ToString().ToString();                        // R7
                            ws.Cell(7, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(2, 22).Value = "'" + gg3["pdate"].ToString();                            // U2
                            ws.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            ws.Cell(3, 22).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // U3
                            ws.Cell(3, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            if (yearmode == "J")
                            {
                                ws.Cell(4, 22).Value = "Jan - Dec";                                         // U4
                            }
                            else
                            {
                                ws.Cell(4, 22).Value = "Apr - Mar";                                         // U4
                            }
                            ws.Cell(4, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                        }

                        var tAlldataCC = ws.Cell(9, 4).InsertTable(dsDataCC.Tables["alldataTable"].AsEnumerable());
                        tAlldataCC.Theme = XLTableTheme.None;
                        tAlldataCC.ShowHeaderRow = false;
                        tAlldataCC.ShowAutoFilter = false;

                        var rangeClearCC = ws.Range(9, 4, 16, 4);
                        rangeClearCC.Clear();
                        rangeClearCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                        var rngdataCC = ws.Range(9, 5, 16, 23);
                        rngdataCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                        rngdataCC.Style.NumberFormat.Format = "0";
                        rngdataCC.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                        var rngheaderCC = ws.Range(9, 4, 9, 23);
                        rngheaderCC.Style.Font.Bold = true;
                        rngheaderCC.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                        rngheaderCC.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                        rngheaderCC.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                        foreach (DataColumn cc3 in dsDataCC.Tables["colsTable"].Columns)
                        {
                            Int32 colCC = dsDataCC.Tables["colsTable"].Columns.IndexOf(cc3);
                            string strVal = dsDataCC.Tables["colsTable"].Rows[0][cc3.ColumnName.ToString()].ToString();
                            ws.Cell(9, colCC + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                            ws.Cell(9, colCC + 5).DataType = XLDataType.Text;
                        }

                        Int32 iNamedRng = inPos + 1;

                        ws.Range(52, 5, 52, 24).AddToNamed("Cha1eSub" + strCostcode, XLScope.Workbook);
                        ws.Range(23, 1, 24, 24).AddToNamed("Cha1eProj" + strCostcode, XLScope.Workbook);
                        ws.Range(32, 1, 33, 24).AddToNamed("Cha1eFur" + strCostcode, XLScope.Workbook);

                        tmlt.AddVariable("Cha1eSub" + strCostcode, dsDataCC.Tables["subcontractTable"]);
                        tmlt.AddVariable("Cha1eProj" + strCostcode, dsDataCC.Tables["projectTable"]);
                        tmlt.AddVariable("Cha1eFur" + strCostcode, dsDataCC.Tables["futureTable"]);

                        Int32 colProjectCC = dsDataCC.Tables["projectTable"].Rows.Count;
                        Int32 colFutureCC = dsDataCC.Tables["futureTable"].Rows.Count;

                        //var rngSubCC = ws.Range(52, 5, 52, 23);
                        //rngSubCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                        //var rngprojectCC = ws.Range(23, 1, (colProjectCC + 23), 23);
                        //rngprojectCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;

                        //var rngfutureCC = ws.Range(Convert.ToInt32(colProjectCC + 38), 1, Convert.ToInt32(colFutureCC + colProjectCC + 39), 23);
                        //rngfutureCC.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                    }

                    //var ws_xxx = wb.Worksheet("Sheet1");
                    //ws_xxx.CopyTo("Sample");
                    wb.Worksheet("Sheet1").Delete();

                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    switch (category)
                    {
                        case "E":
                            strFileName = "CHA1EGrp";
                            break;

                        case "N":
                            strFileName = "CHA1NEGrp";
                            break;

                        case "B":
                            strFileName = "CHA1EGrp_All";
                            break;
                    }
                    string strSimulation = string.Empty;
                    switch (simul)
                    {
                        case "A":
                            strSimulation = "_SimA";
                            break;

                        case "B":
                            strSimulation = "_SimB";
                            break;

                        case "C":
                            strSimulation = "_SimC";
                            break;

                        default:
                            strSimulation = string.Empty;
                            break;
                    }
                    strFileName = strFileName + yymm.Trim().Substring(2, 4).ToString() + strSimulation + ".xlsm";

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
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1NonEnggNew")]
        public async Task<ActionResult> GetCHA1NonEnggNew(string costcode, string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                                    "\\Cmplx\\cc\\CHA1E.xlsx";

            try
            {
                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

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
                        strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    return await t;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetCHA1MgmtNew")]
        public async Task<ActionResult> GetCHA1MgmtNew(string costcode, string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                                    "\\Cmplx\\cc\\CHA1E.xlsx";

            try
            {
                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

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
                        strFileName = costcode.Trim().ToString() + "E" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    return await t;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }



        #endregion
    }
}