using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC.proj;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt.Cmplx.CC.proco
{
    [Authorize]
    public class TM11TM01GController : ControllerBase
    {
        private ITM11TM01GRepository tm11tm01gRepository;
        private RAPDbContext _dbContext;
        private IOptions<AppSettings> appSettings;

        public TM11TM01GController(ITM11TM01GRepository _tm11tm01gRepository,
                                RAPDbContext paramDBContext,
                                IOptions<AppSettings> _appSettings)
        {
            tm11tm01gRepository = _tm11tm01gRepository;
            _dbContext = paramDBContext;
            appSettings = _appSettings;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/proj/GetTM11TM01GData")]
        public async Task<ActionResult> GetTM11TM01GData(string projno, string yymm, string yearmode, string yyyy)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proj\\TM11A.xlsx";

            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (projno.Trim().Length != 7)
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
                    var ws = wb.Worksheet("TM11A");

                    ds = (DataSet)tm11tm01gRepository.TM11AData(projno.Substring(0, 5), yymm, yearmode);

                    ws.Cell(2, 9).Value = "'" + ds.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws.Cell(3, 9).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws.Cell(4, 9).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws.Cell(4, 9).Value = "Apr - Mar";
                    }
                    ws.Cell(6, 6).Value = ds.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString();
                    ws.Cell(8, 3).Value = "'" + projno.Substring(0, 5).ToString();
                    ws.Cell(9, 3).Value = ds.Tables["genTable"].Rows[0]["Name"].ToString();
                    ws.Cell(10, 3).Value = ds.Tables["genTable"].Rows[0]["Prjmngrname"].ToString();
                    ws.Cell(8, 8).Value = "'" + ds.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    tmlt.AddVariable("tm11a_data", ds.Tables["tm11aTable"]);
                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = projno.Substring(0, 5).Trim().ToString() + "_G_TM11A_" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";

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
        [Route("api/rap/rpt/cmplx/proj/GetTM11Data_Old")]
        public async Task<ActionResult> GetTM11Data_Old(string projno, string yymm, string yearmode, string yyyy)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proj\\TM11TM01.xlsm";

            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (projno.Trim().Length != 7)
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

                    ds = (DataSet)tm11tm01gRepository.TM11TM01Data_Old(projno.Substring(0, 5), yymm, yearmode, yyyy);

                    //=========== TM11 ===========
                    var ws1 = wb.Worksheet("TM11");

                    ws1.Cell(2, 12).Value = "'" + ds.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws1.Cell(3, 12).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws1.Cell(4, 12).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws1.Cell(4, 12).Value = "Apr - Mar";
                    }
                    ws1.Cell(6, 8).Value = ds.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString();
                    ws1.Cell(8, 3).Value = "'" + projno.Substring(0, 5).ToString();
                    ws1.Cell(9, 3).Value = ds.Tables["genTable"].Rows[0]["Name"].ToString();
                    ws1.Cell(10, 3).Value = ds.Tables["genTable"].Rows[0]["Prjmngrname"].ToString();
                    ws1.Cell(8, 10).Value = "'" + ds.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    tmlt.AddVariable("tm11_data", ds.Tables["tm11Table"]);

                    //=========== TM01 ===========
                    var ws2 = wb.Worksheet("TM01");

                    ws2.Cell(2, 25).Value = "'" + ds.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws2.Cell(3, 25).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws2.Cell(4, 11).Value = yyyy;
                        ws2.Cell(4, 25).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws2.Cell(4, 11).Value = yyyy;
                        ws2.Cell(4, 25).Value = "Apr - Mar";
                    }
                    ws2.Cell(6, 7).Value = ds.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString();
                    ws2.Cell(8, 3).Value = "'" + projno.Substring(0, 5).ToString();
                    ws2.Cell(9, 3).Value = ds.Tables["genTable"].Rows[0]["Name"].ToString();
                    ws2.Cell(10, 3).Value = ds.Tables["genTable"].Rows[0]["Prjmngrname"].ToString();
                    ws2.Cell(8, 8).Value = "'" + ds.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    foreach (DataColumn cc in ds.Tables["colsTable"].Columns)
                    {
                        Int32 col = ds.Tables["colsTable"].Columns.IndexOf(cc);
                        string strVal = ds.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                        ws2.Cell(14, col + 12).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws2.Cell(14, col + 12).DataType = XLDataType.Text;
                    }
                    tmlt.AddVariable("tm01_part4", ds.Tables["part4Table"]);
                    tmlt.AddVariable("tm01_part3", ds.Tables["part3Table"]);
                    tmlt.AddVariable("tm01_part2", ds.Tables["part2Table"]);
                    tmlt.AddVariable("tm01_data", ds.Tables["part1Table"]);

                    tmlt.Generate();

                    //var rngTM11 = ws1.Range(14, 1, ds.Tables["tm11Table"].Rows.Count + 14, 8);
                    //rngTM11.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    //rngTM11.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    //rngTM11.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    //var rngTM01 = ws1.Range(16, 1, ds.Tables["part1Table"].Rows.Count + 16, 24);
                    //rngTM01.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                    //rngTM01.Style.Border.TopBorder = XLBorderStyleValues.Thin;
                    //rngTM01.Style.Border.BottomBorder = XLBorderStyleValues.Thin;

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = projno.Substring(0, 5).Trim().ToString() + "G" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";

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
        [Route("api/rap/rpt/cmplx/proj/GetTM11Data")]
        public async Task<ActionResult> GetTM11Data(string projno, string yymm, string yearmode, string yyyy)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proj\\TM11TM01.xlsm";

            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (projno.Trim().Length != 7)
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
                    ds = (DataSet)tm11tm01gRepository.TM11TM01Data(projno.Substring(0, 5), yymm, yearmode, yyyy);

                    //=========== TM11 ===========
                    var ws1 = wb.Worksheet("TM11");

                    ws1.Cell(2, 12).Value = "'" + ds.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws1.Cell(3, 12).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws1.Cell(4, 11).Value = yyyy;
                        ws1.Cell(4, 12).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws1.Cell(4, 11).Value = yyyy;
                        ws1.Cell(4, 12).Value = "Apr - Mar";
                    }
                    ws1.Cell(6, 8).Value = ds.Tables["genTable"].Rows[0]["Prjmngrname"].ToString(); 
                    ws1.Cell(8, 3).Value = "'" + projno.Substring(0, 5).ToString();
                    ws1.Cell(9, 3).Value = ds.Tables["genTable"].Rows[0]["Name"].ToString();
                    ws1.Cell(10, 3).Value = ds.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString();
                    ws1.Cell(8, 10).Value = "'" + ds.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    tmlt.AddVariable("tm11_data", ds.Tables["tm11Table"]);

                    //=========== TM01 ===========
                    var ws2 = wb.Worksheet("TM01");

                    ws2.Cell(2, 25).Value = "'" + ds.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws2.Cell(3, 25).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws2.Cell(4, 24).Value = yyyy;
                        ws2.Cell(4, 25).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws2.Cell(4, 24).Value = yyyy;
                        ws2.Cell(4, 25).Value = "Apr - Mar";
                    }
                    ws2.Cell(6, 7).Value = ds.Tables["genTable"].Rows[0]["Prjmngrname"].ToString();
                    ws2.Cell(8, 3).Value = "'" + projno.Substring(0, 5).ToString();
                    ws2.Cell(9, 3).Value = ds.Tables["genTable"].Rows[0]["Name"].ToString();
                    ws2.Cell(10, 3).Value = ds.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString(); 
                    ws2.Cell(8, 8).Value = "'" + ds.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    foreach (DataColumn cc in ds.Tables["colsTable"].Columns)
                    {
                        Int32 col = ds.Tables["colsTable"].Columns.IndexOf(cc);
                        string strVal = ds.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                        ws2.Cell(14, col + 12).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                        ws2.Cell(14, col + 12).DataType = XLDataType.Text;
                    }
                    tmlt.AddVariable("tm01_part6", ds.Tables["part6Table"]);
                    tmlt.AddVariable("tm01_part4", ds.Tables["part4Table"]);
                    tmlt.AddVariable("tm01_part3", ds.Tables["part3Table"]);
                    tmlt.AddVariable("tm01_part2", ds.Tables["part2Table"]);
                    tmlt.AddVariable("tm01_data", ds.Tables["part1Table"]);

                    //=========== TM01 Breakup ===========
                    var ws3 = wb.Worksheet("TM01_Breakup");

                    ws3.Cell(2, 12).Value = "'" + ds.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws3.Cell(3, 12).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws3.Cell(4, 11).Value = yyyy;
                        ws3.Cell(4, 12).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws3.Cell(4, 11).Value = yyyy;
                        ws3.Cell(4, 12).Value = "Apr - Mar";
                    }
                    ws3.Cell(6, 7).Value = ds.Tables["genTable"].Rows[0]["Prjmngrname"].ToString();
                    ws3.Cell(8, 3).Value = "'" + projno.Substring(0, 5).ToString();
                    ws3.Cell(9, 3).Value = ds.Tables["genTable"].Rows[0]["Name"].ToString();
                    ws3.Cell(10, 3).Value = ds.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString(); 
                    ws3.Cell(8, 8).Value = "'" + ds.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    //foreach (DataColumn cc in ds.Tables["colsTable"].Columns)
                    //{
                    //    Int32 col = ds.Tables["colsTable"].Columns.IndexOf(cc);
                    //    string strVal = ds.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                    //    ws3.Cell(14, col + 18).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                    //    ws3.Cell(14, col + 18).DataType = XLDataType.Text;
                    //}
                    tmlt.AddVariable("tm01_part5", ds.Tables["part5Table"]);

                    tmlt.Generate();

                    wb.Worksheet("Menu").Select();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = projno.Substring(0, 5).Trim().ToString() + "G" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";

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
        [Route("api/rap/rpt/cmplx/proj/GetTM11BData")]
        public async Task<ActionResult> GetTM11BData(string projno, string yymm, string yearmode, string yyyy)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proj\\TM11B.xlsx";

            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (projno.Trim().Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                byte[] m_Bytes = null;
                DataSet dsTM11B = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;
                    var ws = wb.Worksheet("TM11B");

                    dsTM11B = (DataSet)tm11tm01gRepository.TM11BData(projno.Substring(0, 5), yymm, yearmode, yyyy);

                    ws.Cell(2, 13).Value = "'" + dsTM11B.Tables["genTable"].Rows[0]["processdate"].ToString();
                    ws.Cell(3, 13).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                    if (yearmode == "J")
                    {
                        ws.Cell(4, 13).Value = "Jan - Dec";
                    }
                    else
                    {
                        ws.Cell(4, 13).Value = "Apr - Mar";
                    }
                    ws.Cell(6, 3).Value = dsTM11B.Tables["genTable"].Rows[0]["Prjmngrname"].ToString();
                    ws.Cell(7, 3).Value = "'" + projno.Substring(0, 5).ToString();
                    ws.Cell(8, 3).Value = dsTM11B.Tables["genTable"].Rows[0]["Name"].ToString();
                    ws.Cell(9, 3).Value = dsTM11B.Tables["genTable"].Rows[0]["Prjdymngrname"].ToString(); 
                    ws.Cell(7, 13).Value = "'" + dsTM11B.Tables["genTable"].Rows[0]["Tcmno"].ToString();

                    tmlt.AddVariable("tm11b_data", dsTM11B.Tables["TM11B"]);
                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = projno.Substring(0, 5).Trim().ToString() + "_G_TM11B_" + yymm.Trim().Substring(2, 4).ToString() + ".xlsx";

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
        [Route("api/rap/rpt/cmplx/proj/getProjectsTCMJobsGrp")]
        public ActionResult GetProjectsTCMJobsGrp(string yymm)
        {
            try
            {
                var result = tm11tm01gRepository.getProjectsTCMJobsGrp(yymm);
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
    }
}