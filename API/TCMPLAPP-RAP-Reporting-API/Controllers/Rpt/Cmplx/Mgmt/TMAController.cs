using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt
{
    [Authorize]
    public class TMAController : ControllerBase
    {
        private ITMARepository tmaRepository;
        private IOptions<AppSettings> appSettings;

        public TMAController(ITMARepository _tmaRepository, IOptions<AppSettings> _settings)
        {
            tmaRepository = _tmaRepository;
            appSettings = _settings;
        }

        //TMA & TMA Summary
        [HttpGet]
        [Route("api/rap/rpt/cmplx/mgmt/GetTMA")]
        public async Task<ActionResult> TMA(string yymm, string yearmode, string reporttype)
        {
            DataSet ds = new DataSet();

            try
            {
                if (string.IsNullOrWhiteSpace(yymm) || string.IsNullOrWhiteSpace(yearmode) || string.IsNullOrWhiteSpace(Request.Headers["activeYear"].ToString()))
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
                else if (reporttype.Trim() != "D" && reporttype.Trim() != "S")
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                string fileSuffix = string.Empty;
                if (yearmode.Trim() == "J")
                {
                    fileSuffix = "_Jan_Dec";
                }
                else
                {
                    fileSuffix = "_Apr_Mar";
                }

                if (reporttype.Trim() == "S")
                {
                    fileSuffix = "_Summ" + fileSuffix;
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Cmplx\Mgmt\TMATM13.xlsx");

                ds = (DataSet)tmaRepository.tma(yymm, yearmode, reporttype, Request.Headers["activeYear"].ToString());

                var wb = template.Workbook;
                var ws = wb.Worksheet("TMA");

                ws.Cell(6, 3).Value = "BO";                                                     // C6
                ws.Cell(6, 8).Value = ds.Tables["JobHead"].Rows[0].Field<string>("descr");      // H6
                ws.Cell(2, 20).Value = DateTime.Now.ToString("dd-MMM-yyyy");                    // T2
                ws.Cell(3, 20).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2); // T3
                if (yearmode.Trim() == "J")
                {
                    ws.Cell(4, 20).Value = "Jan - Dec";                                         // T4
                }
                else
                {
                    ws.Cell(4, 20).Value = "Apr - Mar";                                         // T4
                }

                template.AddVariable("TMA", ds.Tables["TMA"]);
                template.AddVariable("TMA_T", ds.Tables["TMA_T"]);
                template.AddVariable("TMA_E", ds.Tables["TMA_E"]);
                template.AddVariable("TMA_D", ds.Tables["TMA_D"]);
                template.AddVariable("TMA_N", ds.Tables["TMA_N"]);
                template.AddVariable("TMA_O", ds.Tables["TMA_O"]);
                template.AddVariable("TM13_Cols", ds.Tables["TM13_Cols"]);
                template.AddVariable("TM_13", ds.Tables["TM13"]);
                template.AddVariable("TM13_E_Cols", ds.Tables["TM13_Cols"]);
                template.AddVariable("TM13_E", ds.Tables["TM13_E"]);
                template.AddVariable("TM13_C_Cols", ds.Tables["TM13_Cols"]);
                template.AddVariable("TM13_C", ds.Tables["TM13_C"]);
                template.AddVariable("TM13_P_Cols", ds.Tables["TM13_Cols"]);
                template.AddVariable("TM13_P", ds.Tables["TM13_P"]);
                template.AddVariable("TM13_M_Cols", ds.Tables["TM13_Cols"]);
                template.AddVariable("TM13_M", ds.Tables["TM13_M"]);
                template.AddVariable("TM13_D_Cols", ds.Tables["TM13_Cols"]);
                template.AddVariable("TM13_D", ds.Tables["TM13_D"]);
                template.AddVariable("TM13_Z_Cols", ds.Tables["TM13_Cols"]);
                template.AddVariable("TM13_Z", ds.Tables["TM13_Z"]);
                template.AddVariable("TMA_Summary", ds.Tables["TMA_Summary"]);

                template.Generate();
                ws.RowHeight = 12.75;
                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                string strFileName = string.Empty;
                strFileName = yymm.Trim().Substring(2) + fileSuffix + ".xlsx";
                var t = Task.Run(() =>
                {
                    return this.File(
                                   fileContents: m_Bytes,
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
                ds.Dispose();
            }
        }
    }
}