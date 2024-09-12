using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Models.rpt;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt
{
    [ApiController]
    [Authorize]
    [Produces("application/json")]
    public class BeforePostProjController : ControllerBase
    {
        private IBeforePostProjRepository beforePostProjRepository;
        private IOptions<AppSettings> appSettings;

        public BeforePostProjController(IBeforePostProjRepository _BeforePostProjRepository, IOptions<AppSettings> _settings)
        {
            appSettings = _settings;
            beforePostProjRepository = _BeforePostProjRepository;
        }

        [HttpGet]
        [Route("api/rap/rpt/BeforePostProj_YY_PRJ_CC_Download")]
        public async Task<ActionResult> YY_PRJ_CC_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\BeforePostProj\YY_PRJ_CC.xlsx");

                // var template = new XLTemplate(@".\Templates\YY_PRJ_CC.xlsx");

                DataTable dtMJM = new DataTable();
                dtMJM = (DataTable)beforePostProjRepository.YY_PRJ_CC(projno, yymm); //Get DataTable

                if (dtMJM.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }

                var beforePostProjModel = new BeforePostProjModel();

                beforePostProjModel.yy_prj_cc_list = dtMJM.AsEnumerable().Select(row =>
                                     new YY_PRJ_CC_List
                                     {
                                         Yymm = ((string)row["Yymm"]),
                                         Assign = ((string)row["Assign"]),
                                         ProjNo = ((string)row["ProjNo"]),
                                         CostCodeName = ((string)row["CostCode_Name"]),
                                         ProjName = ((string)row["Proj_Name"]),
                                         NHRS = ((decimal)row["NHRS"]),
                                         OHRS = ((decimal)row["OHRS"])
                                     }).ToList();

                template.AddVariable("Title", beforePostProjModel.Title_YY_PRJ_CC);
                template.AddVariable("OnDate", "Report Date : " + beforePostProjModel.OnDate);

                template.AddVariable(
                   "Data",
                   beforePostProjModel.yy_prj_cc_list);

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
                    strFileName = beforePostProjModel.Title_YY_PRJ_CC + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: "application/vnd.closedxmlformats-officedocument.spreadsheetml.sheet",
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                              "Monthly Jobwise Manhours " + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/BeforePostProj_YY_PRJ_CC_ACT_Download")]
        public async Task<ActionResult> YY_PRJ_CC_ACT_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\BeforePostProj\YY_PRJ_CC_ACT.xlsx");

                // var template = new XLTemplate(@".\Templates\YY_PRJ_CC_ACT.xlsx");

                DataTable dtMJM = new DataTable();
                dtMJM = (DataTable)beforePostProjRepository.YY_PRJ_CC_ACT(projno, yymm); //Get DataTable

                if (dtMJM.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }

                var beforePostProjModel = new BeforePostProjModel();

                beforePostProjModel.yy_prj_cc_act_list = dtMJM.AsEnumerable().Select(row =>
                                     new YY_PRJ_CC_ACT_List
                                     {
                                         Yymm = ((string)row["Yymm"]),
                                         Assign = ((string)row["Assign"]),
                                         ProjNo = ((string)row["ProjNo"]),
                                         Activity = ((string)row["Activity"]),
                                         ActName = ((string)row["ActName"]),
                                         ProjName = ((string)row["ProjName"]),
                                         NHRS = ((decimal)row["NHRS"]),
                                         OHRS = ((decimal)row["OHRS"]),
                                         TotalHRS = ((decimal)row["TotalHRS"])
                                     }).ToList();

                template.AddVariable("Title", beforePostProjModel.Title_YY_PRJ_CC_ACT);
                template.AddVariable("OnDate", "Report Date : " + beforePostProjModel.OnDate);

                template.AddVariable(
                   "Data",
                   beforePostProjModel.yy_prj_cc_act_list);

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
                    strFileName = beforePostProjModel.Title_YY_PRJ_CC_ACT + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: "application/vnd.closedxmlformats-officedocument.spreadsheetml.sheet",
                                   fileDownloadName: strFileName
                               );
                });

                Response.Headers.Add("xl_file_name",
                              "Monthly Jobwise Avtivitywise Manhours" + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/BeforePostProj_YY_PRJ_CC_EMP_Download")]
        public async Task<ActionResult> YY_PRJ_CC_EMP_Download(string projno, string yymm)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(projno) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\BeforePostProj\YY_PRJ_CC_EMP.xlsx");

                // var template = new XLTemplate(@".\Templates\YY_PRJ_CC_EMP.xlsx");

                DataTable dtMJM = new DataTable();
                dtMJM = (DataTable)beforePostProjRepository.YY_PRJ_CC_EMP(projno, yymm); //Get DataTable

                if (dtMJM.Rows.Count <= 0)
                {
                    throw new RAPDataNotFound(@$"No data exists for ProjNo : {projno} , yymm : {yymm}");
                }

                var beforePostProjModel = new BeforePostProjModel();

                beforePostProjModel.yy_prj_cc_emp_list = dtMJM.AsEnumerable().Select(row =>
                                     new YY_PRJ_CC_EMP_List
                                     {
                                         Yymm = ((string)row["Yymm"]),
                                         Assign = ((string)row["Assign"]),
                                         ProjNo = ((string)row["ProjNo"]),
                                         Activity = ((string)row["Activity"]),
                                         EmpNO = ((string)row["EmpNO"]),
                                         EmpName = ((string)row["EmpName"]),
                                         ProjName = ((string)row["ProjName"]),
                                         NHRS = ((decimal)row["NHRS"]),
                                         OHRS = ((decimal)row["OHRS"]),
                                         TotalHRS = ((decimal)row["TotalHRS"])
                                     }).ToList();

                template.AddVariable("Title", beforePostProjModel.Title_YY_PRJ_CC_EMP);
                template.AddVariable("OnDate", "Report Date : " + beforePostProjModel.OnDate);

                template.AddVariable(
                   "Data",
                   beforePostProjModel.yy_prj_cc_emp_list);

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
                    strFileName = beforePostProjModel.Title_YY_PRJ_CC_EMP + "_" + projno.ToString() + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                   contentType: "application/vnd.closedxmlformats-officedocument.spreadsheetml.sheet",
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                            "Monthly Jobwise Employeewise Manhours" + "_" + projno.ToString() + ".xlsx");
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/MJM_Proj_All_RptDownload")]
        public async Task<ActionResult> MJM_Proj_All_RptDownload(string yymm, string projno)
        {
            DataTable tb = new DataTable();

            try
            {
                if (string.IsNullOrEmpty(projno))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }
                else if (yymm.Trim().Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                var template = new XLTemplate(Common.CustomFunctions.GetRAPRepository(appSettings.Value) + @"\BeforePostProj\MjmProj.xlsx");

                tb = (DataTable)beforePostProjRepository.MJM_Proj_All_RptDownload(yymm, projno);

                //DataWorksheet
                var wb = template.Workbook;                //var ws = wb.Worksheet("DataWorksheet");

                //ws.Cell("M2").Value = DateTime.Now.ToString("dd-MMM-yyyy");

                //ws.Cell("M4").Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);
                //ws.Cell("E6").Value = "'" + assign;

                //DataWorksheet
                template.AddVariable("mjm_datatable", tb);

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
                strFileName = "Mjm_Project_" + projno.Trim() + "_YYmm_" + yymm.Trim().Substring(2) + ".xlsx";
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
                tb.Dispose();
            }
        }
    }
}