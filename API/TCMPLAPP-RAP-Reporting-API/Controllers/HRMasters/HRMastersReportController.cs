using ClosedXML.Report;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.HRMasters;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.HRMasters
{
    [Authorize]
    public class HRMastersReportController : ControllerBase
    {
        private readonly IHRMastersReportRepository hrMastersReportRepository;
        private IOptions<AppSettings> appSettings;

        public HRMastersReportController(IHRMastersReportRepository _hrMastersReportRepository, IOptions<AppSettings> _appSettings)
        {
            hrMastersReportRepository = _hrMastersReportRepository;
            appSettings = _appSettings;
        }

        [HttpGet]
        [Route("api/rap/hrmasters/GetMonthlyConsolidated")]
        public async Task<ActionResult> GetMonthlyConsolidated(string yymm)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                        "\\HRMasters\\EmployeeMasterMIS.xlsx";

            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DateTime dt_last = new DateTime(int.Parse(yymm.Substring(0, 4)), int.Parse(yymm.Substring(4, 2)), 1).AddMonths(1).AddDays(-1);

                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    ds = (DataSet)hrMastersReportRepository.MonthlyConsolidatedData(yymm);

                    wb.Worksheet("Final").Cell(2, 26).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Final_all").Cell(2, 28).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Left_all").Cell(2, 23).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("MPTotal").Cell(4, 7).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Grade").Cell(4, 18).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Age").Cell(4, 9).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Experience").Cell(4, 11).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Sex").Cell(5, 6).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("ManpowerWise").Cell(4, 7).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("ManpowerWise_Delhi").Cell(4, 7).Value = dt_last.ToString("dd-MMM-yyyy");

                    tmlt.AddVariable("Final", ds.Tables["finalTable"]);
                    tmlt.AddVariable("Final_all", ds.Tables["finalallTable"]);
                    tmlt.AddVariable("Left_all", ds.Tables["leftallTable"]);
                    tmlt.AddVariable("MPTotal", ds.Tables["mptotalTable"]);
                    tmlt.AddVariable("MPTotalDelhi", ds.Tables["mptotalDelhiTable"]);
                    tmlt.AddVariable("MPTotal_187", ds.Tables["mptotal187Table"]);
                    tmlt.AddVariable("Grade", ds.Tables["GradeTable"]);
                    tmlt.AddVariable("GradeDelhi", ds.Tables["GradeDelhiTable"]);
                    tmlt.AddVariable("Grade_187", ds.Tables["grade187Table"]);
                    tmlt.AddVariable("Age", ds.Tables["ageTable"]);
                    tmlt.AddVariable("AgeDelhi", ds.Tables["ageDelhiTable"]);
                    tmlt.AddVariable("Age_187", ds.Tables["age187Table"]);
                    tmlt.AddVariable("Experience", ds.Tables["expTable"]);
                    tmlt.AddVariable("ExperienceDelhi", ds.Tables["expDelhiTable"]);
                    tmlt.AddVariable("Experience_187", ds.Tables["exp187Table"]);
                    tmlt.AddVariable("Sex", ds.Tables["sexTable"]);
                    tmlt.AddVariable("SexDelhi", ds.Tables["sexDelhiTable"]);
                    tmlt.AddVariable("Sex_187", ds.Tables["sex187Table"]);


                    if (ds.Tables["manpowerTable"].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables["manpowerTable"].Rows)
                        {
                            if (string.IsNullOrEmpty(dr[1].ToString()))
                            {
                                dr[2] = "Sub Total - " + dr[0];
                                dr[0] = string.Empty;
                            }

                            if (ds.Tables["manpowerTable"].Rows.IndexOf(dr) == (ds.Tables["manpowerTable"].Rows.Count - 1))
                            {
                                dr[2] = "Total";
                            }
                                                        
                        }
                    }

                    if (ds.Tables["manpowerDelhiTable"].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables["manpowerDelhiTable"].Rows)
                        {
                            if (string.IsNullOrEmpty(dr[1].ToString()))
                            {
                                dr[2] = "Sub Total - " + dr[0];
                                dr[0] = string.Empty;
                            }

                            if (ds.Tables["manpowerDelhiTable"].Rows.IndexOf(dr) == (ds.Tables["manpowerDelhiTable"].Rows.Count - 1))
                            {
                                dr[2] = "Total";
                            }                                                       
                        }
                    }


                    tmlt.AddVariable("ManpowerWise", ds.Tables["manpowerTable"]);
                    tmlt.AddVariable("ManpowerWise_Delhi", ds.Tables["manpowerDelhiTable"]);

                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "MonthlyConsolidated_" + yymm.Trim().ToString() + ".xlsx";
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
        [Route("api/rap/hrmasters/GetMonthlyConsolidatedEngg")]
        public async Task<ActionResult> GetMonthlyConsolidatedEngg(string yymm)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                        "\\HRMasters\\EmployeeMasterMIS.xlsx";

            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DateTime dt_last = new DateTime(int.Parse(yymm.Substring(0, 4)), int.Parse(yymm.Substring(4, 2)), 1).AddMonths(1).AddDays(-1);

                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    ds = (DataSet)hrMastersReportRepository.MonthlyConsolidatedEnggData(yymm);

                    wb.Worksheet("Final").Cell(2, 26).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Final_all").Cell(2, 28).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Left_all").Cell(2, 23).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("MPTotal").Cell(4, 7).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Grade").Cell(4, 18).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Age").Cell(4, 9).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Experience").Cell(4, 11).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("Sex").Cell(5, 6).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("ManpowerWise").Cell(4, 7).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("ManpowerWise_Delhi").Cell(4, 7).Value = dt_last.ToString("dd-MMM-yyyy");

                    //tmlt.AddVariable("Final", ds.Tables["finalTable"]);
                    //tmlt.AddVariable("MPTotal", ds.Tables["mptotalTable"]);
                    //tmlt.AddVariable("MPTotal_187", ds.Tables["mptotal187Table"]);
                    //tmlt.AddVariable("Grade", ds.Tables["GradeTable"]);
                    //tmlt.AddVariable("Grade_187", ds.Tables["grade187Table"]);
                    //tmlt.AddVariable("Age", ds.Tables["ageTable"]);
                    //tmlt.AddVariable("Age_187", ds.Tables["age187Table"]);
                    //tmlt.AddVariable("Experience", ds.Tables["expTable"]);
                    //tmlt.AddVariable("Experience_187", ds.Tables["exp187Table"]);
                    //tmlt.AddVariable("Sex", ds.Tables["sexTable"]);
                    //tmlt.AddVariable("Sex_187", ds.Tables["sex187Table"]);

                    tmlt.AddVariable("Final", ds.Tables["finalTable"]);
                    tmlt.AddVariable("Final_all", ds.Tables["finalallTable"]);
                    tmlt.AddVariable("Left_all", ds.Tables["leftallTable"]);
                    tmlt.AddVariable("MPTotal", ds.Tables["mptotalTable"]);
                    tmlt.AddVariable("MPTotalDelhi", ds.Tables["mptotalDelhiTable"]);
                    tmlt.AddVariable("MPTotal_187", ds.Tables["mptotal187Table"]);
                    tmlt.AddVariable("Grade", ds.Tables["GradeTable"]);
                    tmlt.AddVariable("GradeDelhi", ds.Tables["GradeDelhiTable"]);
                    tmlt.AddVariable("Grade_187", ds.Tables["grade187Table"]);
                    tmlt.AddVariable("Age", ds.Tables["ageTable"]);
                    tmlt.AddVariable("AgeDelhi", ds.Tables["ageDelhiTable"]);
                    tmlt.AddVariable("Age_187", ds.Tables["age187Table"]);
                    tmlt.AddVariable("Experience", ds.Tables["expTable"]);
                    tmlt.AddVariable("ExperienceDelhi", ds.Tables["expDelhiTable"]);
                    tmlt.AddVariable("Experience_187", ds.Tables["exp187Table"]);
                    tmlt.AddVariable("Sex", ds.Tables["sexTable"]);
                    tmlt.AddVariable("SexDelhi", ds.Tables["sexDelhiTable"]);
                    tmlt.AddVariable("Sex_187", ds.Tables["sex187Table"]);

                    if (ds.Tables["manpowerTable"].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables["manpowerTable"].Rows)
                        {
                            if (string.IsNullOrEmpty(dr[1].ToString()))
                            {
                                dr[2] = "Sub Total - " + dr[0];
                                dr[0] = string.Empty;
                            }

                            if (ds.Tables["manpowerTable"].Rows.IndexOf(dr) == (ds.Tables["manpowerTable"].Rows.Count - 1))
                            {
                                dr[2] = "Total";
                            }

                        }
                    }

                    if (ds.Tables["manpowerDelhiTable"].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables["manpowerDelhiTable"].Rows)
                        {
                            if (string.IsNullOrEmpty(dr[1].ToString()))
                            {
                                dr[2] = "Sub Total - " + dr[0];
                                dr[0] = string.Empty;
                            }

                            if (ds.Tables["manpowerDelhiTable"].Rows.IndexOf(dr) == (ds.Tables["manpowerDelhiTable"].Rows.Count - 1))
                            {
                                dr[2] = "Total";
                            }
                        }
                    }

                    tmlt.AddVariable("ManpowerWise", ds.Tables["manpowerTable"]);
                    tmlt.AddVariable("ManpowerWise_Delhi", ds.Tables["manpowerDelhiTable"]);
                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "MonthlyConsolidatedEngg_" + yymm.Trim().ToString() + ".xlsx";
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
        [Route("api/rap/hrmasters/GetMonthlyOutsourceEmployee")]
        public async Task<ActionResult> GetMonthlyOutsourceEmployee(string yymm)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                                        "\\HRMasters\\OutsourceEmployee.xlsx";

            try
            {
                if (string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DateTime dt_last = new DateTime(int.Parse(yymm.Substring(0, 4)), int.Parse(yymm.Substring(4, 2)), 1).AddMonths(1).AddDays(-1);

                byte[] m_Bytes = null;
                DataSet ds = new DataSet();

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;

                    ds = (DataSet)hrMastersReportRepository.OutsourceEmployeeData(yymm);

                    wb.Worksheet("OutsourceEmployee").Cell(2, 42).Value = dt_last.ToString("dd-MMM-yyyy");
                    wb.Worksheet("OutsourceEmployeeAbstract").Cell(2, 3).Value = "as on " + dt_last.ToString("dd-MMM-yyyy");

                    tmlt.AddVariable("Employee", ds.Tables["employeeTable"]);
                    tmlt.AddVariable("EmployeeAbstract", ds.Tables["employeeAbstractTable"]);
                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "OutsourceEmployee_" + yymm.Trim().ToString() + ".xlsx";
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
    }
}