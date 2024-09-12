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
    public class DuplTm02Controller : ControllerBase
    {
        private IDuplTm02Repository dupltTm02Repository;
        private IOptions<AppSettings> appSettings;

        public DuplTm02Controller(IDuplTm02Repository _dupltTm02Repository, IOptions<AppSettings> _settings)
        {
            dupltTm02Repository = _dupltTm02Repository;
            appSettings = _settings;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/cc/GetDuplTm02")]
        public async Task<ActionResult> duplTm02(string costcode, string yymm, string yearmode)
        {
            DataSet ds = new DataSet();

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

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\Cmplx\Cc\duplTM02.xlsx");

                ds = (DataSet)dupltTm02Repository.tm02(costcode, yymm, yearmode, Request.Headers["activeYear"].ToString());

                var wb = template.Workbook;
                var ws = wb.Worksheet("TM02");

                ws.Cell(2, 25).Value = DateTime.Now.ToString("dd-MMM-yyyy");                            // Y2
                ws.Cell(3, 25).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);         // Y3
                if (yearmode == "J")
                {
                    ws.Cell(4, 25).Value = "Jan - Dec";                                                 // Y4
                }
                else
                {
                    ws.Cell(4, 25).Value = "Apr - Mar";                                                 // Y4
                }
                ws.Cell(6, 4).Value = "'" + costcode;                                                   // D6
                ws.Cell(6, 22).Value = ds.Tables["TM02_CostCode"].Rows[0].Field<string>("ccName");      // V6
                ws.Cell(7, 22).Value = ds.Tables["TM02_CostCode"].Rows[0].Field<string>("emplName");    // V7

                //TM02
                template.AddVariable("TM02_Heading", ds.Tables["TM02_Heading"]);
                if (ds.Tables["TM02_EmpType_Hrs_Data"].Rows.Count > 0)
                {
                    template.AddVariable("ManhoursSpentBy", "Manhours spent by");
                }
                template.AddVariable("TM02_EmpType_Hrs_Data", ds.Tables["TM02_EmpType_Hrs_Data"]);
                template.AddVariable("TM02_Data", ds.Tables["TM02_Data"]);

                template.Generate();

                byte[] m_Bytes = null;
                using (MemoryStream ms = new MemoryStream())
                {
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    m_Bytes = ms.ToArray();
                }
                string strFileName = string.Empty;
                strFileName = costcode.Trim() + "DUPLTM02" + yymm.Trim().Substring(2) + ".xlsx";
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