using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Models;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt.Cmplx.proco
{
    [Authorize]
    public class WorkloadController : ControllerBase
    {
        private IWorkloadRepository workloadRepository;
        private RAPDbContext _dbContext;
        private IOptions<AppSettings> appSettings;

        public WorkloadController(IWorkloadRepository _workloadRepository, RAPDbContext paramDBContext, IOptions<AppSettings> _appSettings)
        {
            workloadRepository = _workloadRepository;
            _dbContext = paramDBContext;
            appSettings = _appSettings;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/proco/GetWorkloadData")]
        public async Task<ActionResult> GetWorkloadData(string yymm, string sim, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proco\\Corpworkload.xlsm";
            DataSet dsCC = new DataSet();
            DataSet dsProj = new DataSet();
            string[] arrSheets = new string[] { "Engg", "Projconst", "Procure", "Construction", "Mumbai", "Delhi" };

            try
            {
                byte[] m_Bytes = null;

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    var ws = wb.Worksheet("SUMMARY");
                    string reportMode = "";
                    Int32 printHeader;
                    Int32 startRange;
                    Int32 pasteRange;
                    // Select Sheet
                    for (int i = 0; i < arrSheets.Length; i++)
                    {
                        printHeader = 0;
                        startRange = 19;
                        pasteRange = 19;
                        switch (arrSheets[i].ToString().ToUpper())
                        {
                            case "ENGG":
                                ws = wb.Worksheet(arrSheets[i].ToString());
                                dsCC = (DataSet)workloadRepository.GetCostcodeList("ENGG");
                                reportMode = "COMBINED";
                                break;

                            case "PROJCONST":
                                ws = wb.Worksheet(arrSheets[i].ToString());
                                dsCC = (DataSet)workloadRepository.GetCostcodeList("PROJCONST");
                                reportMode = "COMBINED";
                                break;

                            case "PROCURE":
                                ws = wb.Worksheet(arrSheets[i].ToString());
                                dsCC = (DataSet)workloadRepository.GetCostcodeList("PROCURE");
                                reportMode = "COMBINED";
                                break;

                            case "CONSTRUCTION":
                                ws = wb.Worksheet(arrSheets[i].ToString());
                                dsCC = (DataSet)workloadRepository.GetCostcodeList("CONSTRUCTION");
                                reportMode = "COMBINED";
                                break;
                            case "MUMBAI":
                                ws = wb.Worksheet(arrSheets[i].ToString());
                                dsCC = (DataSet)workloadRepository.GetCostcodeList("MUMBAI");
                                reportMode = "SINGLE";
                                break;
                            case "DELHI":
                                ws = wb.Worksheet(arrSheets[i].ToString());
                                dsCC = (DataSet)workloadRepository.GetCostcodeList("DELHI");
                                reportMode = "SINGLE";
                                break;
                        }

                        ws.Cell(2, 21).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                        ws.Cell(3, 21).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);

                        // Exyract Costcode for the selected sheet
                        foreach (DataRow rr in dsCC.Tables["costcodeTable"].Rows)
                        {
                            string strCostcode = rr["costcode"].ToString();
                            DataSet dsData = new DataSet();
                            Int32 empCount = Convert.ToInt32("0" + rr["intNoEmps"]);
                            string strCostcodeAbbr = rr["costcode"].ToString() + " " + rr["abbr"].ToString();

                            //Int32 chkRowValue = 0;
                            //Int32 chkColValue = 0;

                            try
                            {
                                dsData = (DataSet)workloadRepository.GetWorkloadData(strCostcode, yymm, sim, yearmode, Request.Headers["activeYear"].ToString(), reportMode);
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
                                pasteRange = startRange + 12;

                                // Copy Template cells
                                var rngTemplate = ws.Range(startRange, 1, startRange + 12, 23);
                                ws.Cell(pasteRange, 1).Value = rngTemplate;

                                ws.Cell(startRange, 1).Value = printHeader;
                                ws.Cell(startRange, 2).Value = strCostcodeAbbr;

                                // Costcode Data
                                foreach (DataRow rrdata in dsData.Tables["dataTable"].Rows)
                                {
                                    Int32 ddrow = dsData.Tables["dataTable"].Rows.IndexOf(rrdata);
                                    //chkRowValue = chkRowValue + 1;
                                    foreach (DataColumn ccdata in dsData.Tables["dataTable"].Columns)
                                    {
                                        Int32 ddcol = dsData.Tables["dataTable"].Columns.IndexOf(ccdata);
                                        //chkColValue = chkColValue + 1;
                                        if (ddcol > 0)
                                        {
                                            string rowFldValue = (rrdata[ccdata.ColumnName.ToString()].ToString() == "") ? "0" : rrdata[ccdata.ColumnName.ToString()].ToString();

                                            if (rrdata[ccdata.ColumnName.ToString()] != null)
                                            {
                                                if (ddrow > 6)
                                                {
                                                    ws.Cell(startRange + ddrow + 1, ddcol + 5).Value = Convert.ToDecimal(rowFldValue);
                                                    ws.Cell(startRange + ddrow + 1, ddcol + 5).DataType = XLDataType.Number;
                                                }
                                                else
                                                {
                                                    ws.Cell(startRange + ddrow, ddcol + 5).Value = Convert.ToDecimal(rowFldValue);
                                                    ws.Cell(startRange + ddrow, ddcol + 5).DataType = XLDataType.Number;
                                                }
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

                        ws = wb.Worksheet("SUMMARY");
                        dsProj = (DataSet)workloadRepository.GetExptProjList();
                        foreach (DataRow pp in dsProj.Tables["projTable"].Rows)
                        {
                            Int32 ppRow = dsProj.Tables["projTable"].Rows.IndexOf(pp);
                            ws.Cell(73 + ppRow, 2).Value = ppRow + 1;
                            ws.Cell(73 + ppRow, 2).DataType = XLDataType.Number;
                            ws.Cell(73 + ppRow, 3).Value = "'" + pp["projno"].ToString() + " " + pp["name"].ToString();
                            ws.Cell(73 + ppRow, 3).DataType = XLDataType.Text;
                        }
                    }

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    switch (sim)
                    {
                        case "A":
                            strFileName = "Corpload_A_";
                            break;

                        case "B":
                            strFileName = "Corpload_B_";
                            break;

                        case "C":
                            strFileName = "Corpload_C_";
                            break;

                        default:
                            strFileName = "Corpload_";
                            break;
                    }
                    strFileName = strFileName + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";

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
                dsProj.Dispose();
            }
        }
    }
}