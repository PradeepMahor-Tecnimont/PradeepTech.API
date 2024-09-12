using ClosedXML.Excel;
using ClosedXML.Report;
using DocumentFormat.OpenXml.Office2016.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt.Cmplx.proj
{
    [Authorize]
    public class ComplexProcoController : ControllerBase
    {
        private IComplexProcoRepository complexprocoRepository;
        private RAPDbContext _dbContext;
        private IOptions<AppSettings> appSettings;

        public ComplexProcoController(IComplexProcoRepository _complexprocoRepository, RAPDbContext paramDBContext, IOptions<AppSettings> _appSettings)
        {
            complexprocoRepository = _complexprocoRepository;
            _dbContext = paramDBContext;
            appSettings = _appSettings;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/proco/GetPRJCCTCMData")]
        public async Task<ActionResult> GetPRJCCTCMData(string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proco\\PRJ_CC_TCM.xlsx";

            try
            {
                //if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(projno))
                //{
                //    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                //}
                //else if (projno.Trim().Length != 7)
                //{
                //    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                //}
                if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    //ds = (DataSet)complexprocoRepository.PRJCCTCData(projno.Substring(0, 5), yymm, yearmode);
                    ds = (DataSet)complexprocoRepository.PRJCCTCData(yymm, yearmode);

                    var ws = wb.Worksheet("PRJ_CC");

                    ws.Cell(2, 16).Value = "'" + ds.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws.Cell(3, 16).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws.Cell(5, 16).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws.Cell(5, 16).Value = "Apr - Mar";
                    }
                    //ws.Cell(6, 6).Value = ds.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString();
                    //ws.Cell(8, 3).Value = "'" + projno.ToString();
                    //ws.Cell(9, 3).Value = ds.Tables["genTable"].Rows[0]["Name"].ToString();
                    //ws.Cell(10, 3).Value = ds.Tables["genTable"].Rows[0]["Prjmngrname"].ToString();
                    //ws.Cell(8, 8).Value = "'" + ds.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    foreach (DataColumn cc in ds.Tables["colsTable"].Columns)
                    {
                        Int32 col = ds.Tables["colsTable"].Columns.IndexOf(cc);
                        string strVal = ds.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                        ws.Cell(10, col + 5).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws.Cell(10, col + 5).DataType = XLDataType.Text;
                    }

                    tmlt.AddVariable("prjccdata", ds.Tables["prjcctcmTable"]);
                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "Prj_CC_" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";

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
        [Route("api/rap/rpt/cmplx/proco/GetPRJCCPORTHRSData")]
        public async Task<ActionResult> GetPRJCCPORTHRSData(string yymm, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proco\\PRJ_CC_PO_RT_HRS.xlsx";

            try
            {
                if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    ds = (DataSet)complexprocoRepository.ReimbPOData(yymm);

                    // All records
                    var ws = wb.Worksheet("PRJ_CC_PO_RT_HRS");

                    ws.Cell(2, 9).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                    ws.Cell(3, 9).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws.Cell(5, 9).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws.Cell(5, 9).Value = "Apr - Mar";
                    }

                    tmlt.AddVariable("prjccportdata", ds.Tables["hrsTable"]);

                    // Subcontract (O)
                    var ws_o = wb.Worksheet("OSubcontract");

                    ws_o.Cell(2, 9).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                    ws_o.Cell(3, 9).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws_o.Cell(5, 9).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws_o.Cell(5, 9).Value = "Apr - Mar";
                    }

                    tmlt.AddVariable("subcontractData", ds.Tables["hrsOTable"]);

                    // Excluding Subcontract (O) Mumbai Delhi Combined 

                    var ws_ex = wb.Worksheet("Excl_OSubcontract");

                    ws_ex.Cell(2, 9).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                    ws_ex.Cell(3, 9).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws_ex.Cell(5, 9).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws_ex.Cell(5, 9).Value = "Apr - Mar";
                    }

                    tmlt.AddVariable("exclsubcontractData", ds.Tables["hrsEXOTable"]);

                    // Excluding Subcontract (O) Mumbai 

                    var ws_ex_mumbai = wb.Worksheet("Excl_OSubcontract M");

                    ws_ex_mumbai.Cell(2, 9).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                    ws_ex_mumbai.Cell(3, 9).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws_ex_mumbai.Cell(5, 9).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws_ex_mumbai.Cell(5, 9).Value = "Apr - Mar";
                    }

                    tmlt.AddVariable("exclsubcontractMumbaiData", ds.Tables["hrsMumbaiEXOTable"]);

                    // Excluding Subcontract (O) Delhi 

                    var ws_ex_delhi = wb.Worksheet("Excl_OSubcontract D");

                    ws_ex_delhi.Cell(2, 9).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                    ws_ex_delhi.Cell(3, 9).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws_ex_delhi.Cell(5, 9).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws_ex_delhi.Cell(5, 9).Value = "Apr - Mar";
                    }

                    tmlt.AddVariable("exclsubcontractDelhiData", ds.Tables["hrsDelhiEXOTable"]);

                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "Prj_CC_PO_RT_HRS_" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";

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
        [Route("api/rap/rpt/cmplx/proco/GetOUTSIDESUBCONData")]
        public async Task<ActionResult> GetOUTSIDESUBCONData(string yyyy, string yearmode, string yymm, string costcode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proco\\OUTSIDESUBCONTRACT.xlsx";

            try
            {
                if (yyyy.Trim().Length != 7 && yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    
                    ds = (DataSet)complexprocoRepository.OutsideSubcontractData(yyyy, yearmode, yymm, costcode);

                    var ws = wb.Worksheet("Subcontract");

                    ws.Cell(1, 19).Value = "Report Processed on : " + DateTime.Now.ToString("dd-MMM-yyyy");
                    ws.Cell(1, 24).Value = "Cutoff Month : " + yymm.ToString();

                    foreach (DataColumn cc in ds.Tables["colsTable"].Columns)
                    {
                        Int32 col = ds.Tables["colsTable"].Columns.IndexOf(cc);
                        string strVal = ds.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                        if (col < 13)
                        {
                            ws.Cell(3, col + 11).Value = "'" + strVal.ToString();
                            ws.Cell(3, col + 11).DataType = XLDataType.Text;                            
                        } 
                        else
                        {
                            ws.Cell(3, col + 12).Value = "'" + strVal.ToString(); 
                            ws.Cell(3, col + 12).DataType = XLDataType.Text;
                        }                        
                    }
                    ws.Range(3, 1, 3, 26).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                    tmlt.AddVariable("resultsdata", ds.Tables["resultsTable"]);
                    tmlt.Generate();
                                       
                    int ii = 4;
                    
                    string preProjno = string.Empty;
                    string preVendorName = string.Empty;
                    string prePONumberName = string.Empty;
                    string preCostcode = string.Empty;

                    // Grouping

                    foreach (DataRow rr in ds.Tables["resultsTable"].Rows)
                    {
                        if (rr["projno"].ToString() == preProjno && rr["vendor"].ToString() == preVendorName && rr["po_number"].ToString() == prePONumberName && rr["costcode"].ToString() == preCostcode)
                        {
                            ws.Range(ii, 1, ii, 8).Clear();
                            var rngBlock = ws.Range(ii, 1, ii, 26);
                            rngBlock.Style.Border.InsideBorder = XLBorderStyleValues.Hair;                            
                        }
                        else
                        {                            
                            preProjno = rr["projno"].ToString();
                            preVendorName = rr["vendor"].ToString();
                            prePONumberName = rr["po_number"].ToString();
                            preCostcode = rr["costcode"].ToString();

                            var rngHorizontal = ws.Range(ii, 1, ii, 26);
                            rngHorizontal.Style.Border.InsideBorder = XLBorderStyleValues.Hair;
                            rngHorizontal.Style.Border.TopBorder = XLBorderStyleValues.Medium;                            
                        }

                        ii++;        
                    }

                    int totalRows = ds.Tables["resultsTable"].Rows.Count;
                    var rngBox = ws.Range(4, 1, totalRows + 3, 26);                    
                    rngBox.Style.Border.OutsideBorder = XLBorderStyleValues.Medium;

                    var rngNumFormat = ws.Range(4, 11, totalRows + 3, 26);
                    rngNumFormat.Style.NumberFormat.Format = "#,#";

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "Outside_Subcontract_" + yearmode + "_" + yyyy.ToString().Replace("-","_") + ".xlsx";

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


        //[HttpGet]
        //[Route("api/rap/rpt/cmplx/proco/GetTM11AllData")]
        //public async Task<ActionResult> GetTM11AllData(string yymm, string yearmode, string yyyy)
        //{
        //    string inputFile = appSettings.Value.RAPAppSettings.ApplicationRepository +
        //                       "\\Templates\\Cmplx\\proj\\TM11TM01.xlsm";

        // try { if (string.IsNullOrWhiteSpace(yymm)) { throw new RAPInvalidParameter("Parameter
        // values are invalid, please check"); } else if (yymm.Trim().Length != 6) { throw new
        // RAPInvalidParameter("Parameter values are invalid, please check"); }

        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}
    }
}