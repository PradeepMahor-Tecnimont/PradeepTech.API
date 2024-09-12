using ClosedXML.Excel;
using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt
{
    [Authorize]
    [Produces("application/json")]
    public class AfterPostProjController : ControllerBase
    {
        private IAfterPostProjRepository afterPostProjRepository;

        private IOptions<AppSettings> appSettings;

        public AfterPostProjController(IAfterPostProjRepository _IAfterPostProjRepository, IOptions<AppSettings> _settings)
        {
            appSettings = _settings;
            afterPostProjRepository = _IAfterPostProjRepository;
        }

        [HttpGet]
        [Route("api/rap/rpt/Proj_Grade_Download")]
        public async Task<ActionResult> Proj_Grade_Download(string projno, string yymm)
        {
            //ProjNo 5 Digits
            //projno = "0900409";
            //yymm = "202001";
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                projno = projno.Trim();
                yymm = yymm.Trim();

                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\GRADE.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_GRADE(projno, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }

                string Title = "Gradewise Manhuors";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

                //template.AddVariable(
                //   "Data",
                //   afterpost.project.GradeList);
                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Proj_PlanRep1_Download")]
        public async Task<ActionResult> Proj_PlanRep1_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                projno = projno.Trim();
                yymm = yymm.Trim();

                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\Proj_PlanRep1.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_PlanRep1(projno, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }

                string Title = "Hours Costcode & Activity  Wise";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Proj_PlanRep2_Download")]
        public async Task<ActionResult> Proj_PlanRep2_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                projno = projno.Trim();
                yymm = yymm.Trim();

                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\Proj_PlanRep2.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_PlanRep2(projno, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }
                string Title = "Projectwise Costcode Activity wise hours for the various Period";

                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString() + @"\AfterPostProj\ProjCost_combine.xlsx";

                var workbook = new XLWorkbook(XlTempPath);
                var sheet = workbook.Worksheet("ReportData");

                var vTable = workbook.Table("DataTable");
                vTable.ReplaceData(dataTable, propagateExtraColumns: true);

                var wb = workbook;

                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");

                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/PRJ_ACC_ACT_BUDG_Download")]
        public async Task<ActionResult> PRJ_ACC_ACT_BUDG_Download(string projno)
        {
            //projno = "0002230";
            //yymm = "202001";

            try
            {
                if (string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                projno = projno.Trim();
                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\PRJ_ACC_ACT_BUDG.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_ACC_ACT_BUDG(projno); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} ");
                }
                string Title = "Project Actual- Budget";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/PRJ_CC_ACT_BUDG_Download")]
        public async Task<ActionResult> PRJ_CC_ACT_BUDG_Download(string projno)
        {
            //projno = "0002230";
            //yymm = "202001";

            try
            {
                if (string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                projno = projno.Trim();
                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                //var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\PRJ_CC_ACT_BUDG.xlsx");

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\PRJ_CC_ACT_BUDG.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.PRJ_CC_ACT_BUDG(projno); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} ");
                }
                string Title = "Project_ Actual_Budget";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/ProjCost_combine_Download")]
        public async Task<ActionResult> ProjCost_combine_Download(string projno)
        {
            // projno = "0002230"; yymm = "202001";

            try
            {
                if (string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                projno = projno.Trim();

                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_Cost_combine(projno); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} ");
                }
                string Title = "Project Costcode Wise Manhours from begining of project ";

                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\ProjCost_combine.xlsx";

                var workbook = new XLWorkbook(XlTempPath);
                var sheet = workbook.Worksheet("ReportData");

                var vTable = workbook.Table("DataTable");
                vTable.ReplaceData(dataTable, propagateExtraColumns: true);

                var wb = workbook;

                byte[] m_Bytes = null;

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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/ProjCostOT_combine_Download")]
        public async Task<ActionResult> ProjCostOT_combine_Download(string projno)
        {
            //projno = "0002230";
            //yymm = "202001";

            try
            {
                if (string.IsNullOrWhiteSpace(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                projno = projno.Trim();

                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_CostOT_combine(projno); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno}  ");
                }
                string Title = "Project Costcode Wise Manhours from begining of project (OT) ";
                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\ProjCostOT_combine.xlsx";

                var workbook = new XLWorkbook(XlTempPath);
                var sheet = workbook.Worksheet("ReportData");

                var vTable = workbook.Table("DataTable");
                vTable.ReplaceData(dataTable, propagateExtraColumns: true);

                var wb = workbook;

                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Projhrs_OtBreak_Download")]
        public async Task<ActionResult> Projhrs_OtBreak_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                projno = projno.Trim();
                yymm = yymm.Trim();

                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\Projhrs_OtBreak.xlsx");

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_hrs_OtBreak(projno, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }
                string Title = "Project Costcode Employee Manhours with Overtime Breakup";

                template.AddVariable("Title", Title);
                template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

                template.AddVariable("Data", dataTable);
                template.Generate();

                var wb = template.Workbook;
                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                    contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/Projhrs_OtCrossTab_Download")]
        public async Task<ActionResult> Projhrs_OtCrossTab_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                projno = projno.Trim();
                yymm = yymm.Trim();

                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_hrs_OtCrossTab(projno, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }
                string Title = "Project Costcode Employee Wise Manhours with Overtime BreakUp (Cross Tab)";

                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\Projhrs_OtCrossTab.xlsx";

                var workbook = new XLWorkbook(XlTempPath);
                var sheet = workbook.Worksheet("ReportData");

                var vTable = workbook.Table("DataTable");
                vTable.ReplaceData(dataTable, propagateExtraColumns: true);

                var wb = workbook;

                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                    contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/WorkPosition_Combine_Download")]
        public async Task<ActionResult> WorkPosition_Combine_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                projno = projno.Trim();
                yymm = yymm.Trim();
                if (projno.Length != 5 && projno.Length != 7)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable dataTable = new DataTable();
                dataTable = (DataTable)afterPostProjRepository.Proj_WorkPosition_Combine(projno, yymm); //Get DataTable
                if (dataTable.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }
                string Title = "Work Position Wise from 2011 onward";
                string XlTempPath = Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\AfterPostProj\WorkPosition_Combine.xlsx";

                var workbook = new XLWorkbook(XlTempPath);
                var sheet = workbook.Worksheet("ReportData");

                var vTable = workbook.Table("DataTable");
                vTable.ReplaceData(dataTable, propagateExtraColumns: true);

                var wb = workbook;
                //template.AddVariable("Title", Title);
                //template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

                //template.AddVariable("Data", dataTable);
                //template.Generate();

                //var wb = template.Workbook;
                byte[] m_Bytes = null;
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
                    strFileName = Title + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name", Title + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}