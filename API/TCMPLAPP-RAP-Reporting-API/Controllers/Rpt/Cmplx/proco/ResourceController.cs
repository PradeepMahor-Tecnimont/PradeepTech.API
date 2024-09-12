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
    public class ResourceController : ControllerBase
    {
        private IResourceRepository resourceRepository;
        private RAPDbContext _dbContext;
        private IOptions<AppSettings> appSettings;

        public ResourceController(IResourceRepository _resourceRepository, RAPDbContext paramDBContext, IOptions<AppSettings> _appSettings)
        {
            resourceRepository = _resourceRepository;
            _dbContext = paramDBContext;
            appSettings = _appSettings;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/proco/GetResourceAvlSch")]
        public async Task<ActionResult> GetResourceAvlSch(string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proco\\ResoAvlblSchedule.xlsm";
            DataSet dsCC = new DataSet();
            DataSet dsProj = new DataSet();
            try
            {
                byte[] m_Bytes = null;

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    var ws = wb.Worksheet("Resource");
                    Int32 printHeader = 0;
                    Int32 startRange = 10;
                    Int32 pasteRange = 10;
                    string timesheet_yyyy = string.Empty;
                    timesheet_yyyy = Request.Headers["activeYear"].ToString();
                    dsCC = (DataSet)resourceRepository.GetCostcodeList();
                    foreach (DataRow rr in dsCC.Tables["costcodeTable"].Rows)
                    {
                        DataSet dsData = new DataSet();

                        string strCostcode = rr["costcode"].ToString();
                        string strCCName = rr["name"].ToString();

                        dsData = (DataSet)resourceRepository.GetResourceData(timesheet_yyyy, strCostcode, yymm, yearmode);
                        startRange = pasteRange;

                        if (printHeader == 0)
                        {
                            foreach (DataColumn cc in dsData.Tables["colsTable"].Columns)
                            {
                                Int32 col = dsData.Tables["colsTable"].Columns.IndexOf(cc);
                                string strVal = dsData.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                                ws.Cell(9, col + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                                ws.Cell(9, col + 5).DataType = XLDataType.Text;
                            }
                        }
                        printHeader = printHeader + 1;
                        pasteRange = startRange + 9;

                        // Copy Template cells
                        var rngTemplate = ws.Range(startRange, 1, startRange + 9, 23);
                        ws.Cell(pasteRange, 1).Value = rngTemplate;

                        ws.Cell(startRange, 1).Value = "'" + strCostcode.ToString();
                        ws.Cell(startRange, 2).Value = strCCName;

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
                                        if (ddrow == 0)
                                        {
                                            ws.Cell(startRange + ddrow + 1, ddcol + 4).Value = Convert.ToDecimal(rowFldValue);
                                            ws.Cell(startRange + ddrow + 1, ddcol + 4).DataType = XLDataType.Number;
                                        }
                                        else if (ddrow == 1)
                                        {
                                            ws.Cell(startRange + ddrow + 2, ddcol + 4).Value = Convert.ToDecimal(rowFldValue);
                                            ws.Cell(startRange + ddrow + 2, ddcol + 4).DataType = XLDataType.Number;
                                        }
                                        else if (ddrow == 2)
                                        {
                                            ws.Cell(startRange + ddrow + 3, ddcol + 4).Value = Convert.ToDecimal(rowFldValue);
                                            ws.Cell(startRange + ddrow + 3, ddcol + 4).DataType = XLDataType.Number;
                                        }
                                    }
                                }
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

                    string strFileName = string.Empty;
                    strFileName = "ResoAvlblSchedule" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";

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