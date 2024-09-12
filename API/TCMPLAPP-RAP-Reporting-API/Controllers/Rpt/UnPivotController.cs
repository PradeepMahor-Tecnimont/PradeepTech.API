using ClosedXML.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Exceptions;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Rpt;
using System;
using System.Data;
using System.IO;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt
{
    [Authorize]
    public class UnPivotController : ControllerBase
    {
        private IOptions<AppSettings> appSettings;
        private IUnPivotReportRepository unPivotReportRepository;

        public UnPivotController(IUnPivotReportRepository _unPivotReportRepository, IOptions<AppSettings> _settings)
        {
            appSettings = _settings;
            unPivotReportRepository = _unPivotReportRepository;
        }

        [HttpGet]
        [Route("api/rap/rpt/ProcessData")]
        public string ProcessData(string yymm, string RepFor)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(RepFor) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                RepFor = RepFor.Trim();
                yymm = yymm.Trim();

                if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                string Result = unPivotReportRepository.ProcessData(yymm, RepFor); //Get DataTable
                return Result;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/GetProcessStatus")]
        public ActionResult GetProcessStatus(string yymm, string RepFor)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(RepFor) || string.IsNullOrWhiteSpace(yymm))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                RepFor = RepFor.Trim();
                yymm = yymm.Trim();

                if (yymm.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                object Result = (object)unPivotReportRepository.GetProcessStatus(yymm, RepFor);
                return new JsonResult(Ok(Result));
            }
            catch (Exception)
            {
                throw;
            }
        }

        ////[HttpGet]
        ////[Route("api/rap/rpt/WkJob")]
        //////api/rap/rpt/WkJob?FromDate=20-07-19&ToDate=30-07-19&Assign=0221
        ////public async Task<ActionResult> WkJob(string pYYYYMM, string pAssign)
        ////{
        ////    try
        ////    {
        ////        if (string.IsNullOrWhiteSpace(pYYYYMM) || string.IsNullOrWhiteSpace(pAssign))
        ////        {
        ////            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        ////        }

        ////        pYYYYMM = pYYYYMM.Trim();

        ////        pAssign = pAssign.Trim();

        ////        if (pAssign.Length != 4 || pYYYYMM.Length != 8 )
        ////        {
        ////            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        ////        }

        ////        var template = new XLTemplate(oAppSettings.Value.RAPAppSettings
        ////            .ApplicationRepository.ToString() + @"\UnPivot\WKJOB.xlsx");

        ////        DataTable dataTable = new DataTable();
        ////        dataTable = (DataTable)unPivotReportRepository.WkJob(pYYYYMM, pAssign   ); //Get DataTable

        ////        string Title = " (WKJON) Weekly Jobwise Manhours  ";

        ////        template.AddVariable("Title", Title);
        ////        template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

        ////        template.AddVariable("Data", dataTable);
        ////        template.Generate();

        ////        var wb = template.Workbook;
        ////        byte[] m_Bytes = null;
        ////        using (MemoryStream ms = new MemoryStream())
        ////        {
        ////            wb.SaveAs(ms);
        ////            byte[] buffer = ms.GetBuffer();
        ////            long length = ms.Length;
        ////            m_Bytes = ms.ToArray();
        ////        }
        ////        var t = Task.Run(() =>
        ////        {
        ////            string strFileName = string.Empty;
        ////            strFileName = Title + "_" + pAssign.ToString() + ".xlsx";
        ////            return this.File(
        ////                           fileContents: m_Bytes,
        ////                          contentType: oAppSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        ////                           fileDownloadName: strFileName
        ////                       );
        ////        });
        ////        return await t;
        ////    }
        ////    catch (Exception e)
        ////    {
        ////        throw e;
        ////    }
        ////}

        //[HttpGet]
        //[Route("api/rap/rpt/WkMJEAM")]
        ////api/rap/rpt/WkMJEAM?FromDate=20-07-19&ToDate=30-07-19&Assign=0221
        //public async Task<ActionResult> WkMJEAM(string FromDate, string ToDate, string Assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(FromDate) || string.IsNullOrWhiteSpace(ToDate) || string.IsNullOrWhiteSpace(Assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }

        // FromDate = FromDate.Trim(); ToDate = ToDate.Trim(); Assign = Assign.Trim();

        // if (Assign.Length != 4 || FromDate.Length != 8 || ToDate.Length != 8) { throw new
        // RAPInvalidParameter("Parameter values are invalid, please check"); }

        // var template = new XLTemplate(oAppSettings.Value.RAPAppSettings
        // .ApplicationRepository.ToString() + @"\UnPivot\.xlsx");

        // DataTable dataTable = new DataTable(); dataTable =
        // (DataTable)unPivotReportRepository.WkMJEAM(FromDate, ToDate, Assign); //Get DataTable

        // string Title = " (WKMJEAM) Weekly Project Employeewise Activity wise Report ";

        // template.AddVariable("Title", Title); template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

        // template.AddVariable("Data", dataTable); template.Generate();

        //        var wb = template.Workbook;
        //        byte[] m_Bytes = null;
        //        using (MemoryStream ms = new MemoryStream())
        //        {
        //            wb.SaveAs(ms);
        //            byte[] buffer = ms.GetBuffer();
        //            long length = ms.Length;
        //            m_Bytes = ms.ToArray();
        //        }
        //        var t = Task.Run(() =>
        //        {
        //            string strFileName = string.Empty;
        //            strFileName = Title + "_" + Assign.ToString() + ".xlsx";
        //            return this.File(
        //                           fileContents: m_Bytes,
        //                          contentType: oAppSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        //                           fileDownloadName: strFileName
        //                       );
        //        });
        //        return await t;
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        //[HttpGet]
        //[Route("api/rap/rpt/WKMJEM")]
        ////api/rap/rpt/WKMJEM?FromDate=20-07-19&ToDate=30-07-19&Assign=0221
        //public async Task<ActionResult> WKMJEM(string FromDate, string ToDate, string Assign)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(FromDate) || string.IsNullOrWhiteSpace(ToDate) || string.IsNullOrWhiteSpace(Assign))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }

        // FromDate = FromDate.Trim(); ToDate = ToDate.Trim(); Assign = Assign.Trim();

        // if (Assign.Length != 4 || FromDate.Length != 8 || ToDate.Length != 8) { throw new
        // RAPInvalidParameter("Parameter values are invalid, please check"); }

        // var template = new XLTemplate(oAppSettings.Value.RAPAppSettings
        // .ApplicationRepository.ToString() + @"\UnPivot\.xlsx");

        // DataTable dataTable = new DataTable(); dataTable =
        // (DataTable)unPivotReportRepository.WKMJEM(FromDate, ToDate, Assign); //Get DataTable

        // string Title = " (WKMJEM) Weekly Manhours Jobwise Employeewise ";

        // template.AddVariable("Title", Title); template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

        // template.AddVariable("Data", dataTable); template.Generate();

        //        var wb = template.Workbook;
        //        byte[] m_Bytes = null;
        //        using (MemoryStream ms = new MemoryStream())
        //        {
        //            wb.SaveAs(ms);
        //            byte[] buffer = ms.GetBuffer();
        //            long length = ms.Length;
        //            m_Bytes = ms.ToArray();
        //        }
        //        var t = Task.Run(() =>
        //        {
        //            string strFileName = string.Empty;
        //            strFileName = Title + "_" + Assign.ToString() + ".xlsx";
        //            return this.File(
        //                           fileContents: m_Bytes,
        //                          contentType: oAppSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        //                           fileDownloadName: strFileName
        //                       );
        //        });
        //        return await t;
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        //[HttpGet]
        //[Route("api/rap/rpt/WKMJEMP")]
        ////api/rap/rpt/WKMJEMP?FromDate=20-07-19&ToDate=30-07-19&ProjNo=09794
        //public async Task<ActionResult> WKMJEMP(string FromDate, string ToDate, string ProjNo)
        //{
        //    try
        //    {
        //        if (string.IsNullOrWhiteSpace(FromDate) || string.IsNullOrWhiteSpace(ToDate) || string.IsNullOrWhiteSpace(ProjNo))
        //        {
        //            throw new RAPInvalidParameter("Parameter values are invalid, please check");
        //        }

        // FromDate = FromDate.Trim(); ToDate = ToDate.Trim(); ProjNo = ProjNo.Trim();

        // if (ProjNo.Length != 5 || FromDate.Length != 8 || ToDate.Length != 8) { throw new
        // RAPInvalidParameter("Parameter values are invalid, please check"); }

        // var template = new XLTemplate(oAppSettings.Value.RAPAppSettings
        // .ApplicationRepository.ToString() + @"\UnPivot\.xlsx");

        // DataTable dataTable = new DataTable(); dataTable =
        // (DataTable)unPivotReportRepository.WKMJEMP(FromDate, ToDate, ProjNo); //Get DataTable

        // string Title = " (WKMJEMP) Weekly Manhours Jobwise Employeewise ";

        // template.AddVariable("Title", Title); template.AddVariable("OnDate", "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy"));

        // template.AddVariable("Data", dataTable); template.Generate();

        //        var wb = template.Workbook;
        //        byte[] m_Bytes = null;
        //        using (MemoryStream ms = new MemoryStream())
        //        {
        //            wb.SaveAs(ms);
        //            byte[] buffer = ms.GetBuffer();
        //            long length = ms.Length;
        //            m_Bytes = ms.ToArray();
        //        }
        //        var t = Task.Run(() =>
        //        {
        //            string strFileName = string.Empty;
        //            strFileName = Title + "_" + ProjNo.ToString() + ".xlsx";
        //            return this.File(
        //                           fileContents: m_Bytes,
        //                          contentType: oAppSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        //                           fileDownloadName: strFileName
        //                       );
        //        });
        //        return await t;
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}

        [HttpGet]
        [Route("api/rap/rpt/CostCenterManhours")]
        public async Task<ActionResult> CostCenterManhours(string YYYYMM, string CostCenter)
        {
            XLWorkbook wb = null;

            try
            {
                if (string.IsNullOrWhiteSpace(YYYYMM) || string.IsNullOrWhiteSpace(CostCenter))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                YYYYMM = YYYYMM.Trim();
                CostCenter = CostCenter.Trim();

                if (CostCenter.Length != 4 || YYYYMM.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable oDT = new DataTable();
                oDT = (DataTable)unPivotReportRepository.GetData4CostCenter(YYYYMM, CostCenter); //Get DataTable

                if (oDT.Rows.Count == 0)
                    throw new RAPCustomException("No data exists for " + CostCenter + " - " + YYYYMM, "NO_DATA_FOUND");
                wb = new XLWorkbook(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString() + @"\BeforePost\CostCenterManHours.xlsx");
                var ws = wb.Worksheet(1);

                ws.Cell(2, 1).Value = CostCenter + " - Costcenter Manhours Report for - " + YYYYMM;
                ws.Cell(2, 15).Value = "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy");
                ws.Cell(5, 1).InsertData(oDT);

                string strRange = "'DataSheet'!$A$4:$O$" + (oDT.Rows.Count + 4);
                string Title = CostCenter + "- Weekly Jobwise Manhours -" + YYYYMM + ".xlsx";

                var tabs = ws.Tables;

                var tab = tabs.Table(0);
                //tab.ReplaceData(oDT);
                IXLRange oRange = ws.Range(strRange);
                tab.Resize(oRange);

                //var pTab = wb.Worksheets.Worksheet(2).PivotTables.PivotTable("PivotTable1");
                //pTab.SourceRange = ws.Range(strRange);

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
                    strFileName = Title + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });

                Response.Headers.Add("xl_file_name",
                   Title);
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if (wb != null)
                    wb.Dispose();
            }
        }

        [HttpGet]
        [Route("api/rap/rpt/ProjectManhours")]
        public async Task<ActionResult> ProjectManhours(string YYYYMM, string ProjNo)
        {
            XLWorkbook wb = null;
            try
            {
                if (string.IsNullOrWhiteSpace(YYYYMM) || string.IsNullOrWhiteSpace(ProjNo))
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                YYYYMM = YYYYMM.Trim();
                ProjNo = ProjNo.Trim();

                if (ProjNo.Length != 5 || YYYYMM.Length != 6)
                {
                    throw new RAPInvalidParameter("Parameter values are invalid, please check");
                }

                DataTable oDT = new DataTable();
                oDT = (DataTable)unPivotReportRepository.GetData4Project(YYYYMM, ProjNo); //Get DataTable

                if (oDT.Rows.Count == 0)
                    throw new RAPCustomException("No data exists for " + ProjNo + " - " + YYYYMM, "NO_DATA_FOUND");

                wb = new XLWorkbook(Common.CustomFunctions.GetRAPRepository(appSettings.Value).ToString() + @"\BeforePost\ProjectManhours.xlsx");
                var ws = wb.Worksheet(1);

                ws.Cell(2, 1).Value = ProjNo + " - Project Manhours Report for - " + YYYYMM;
                ws.Cell(2, 15).Value = "Report Date : " + DateTime.Now.ToString("dd-MMM-yyyy");
                ws.Cell(5, 1).InsertData(oDT);
                string strRange = "'DataSheet'!$A$4:$O$" + (oDT.Rows.Count + 4);
                //var xlRnage = wb.NamedRange("ManHoursData");

                //xlRnage.RefersTo = strRange;

                string Title = ProjNo + "-Project-Manhours-" + YYYYMM + ".xlsx";

                var tabs = ws.Tables;

                var tab = tabs.Table(0);
                //tab.ReplaceData(oDT);
                IXLRange oRange = ws.Range(strRange);
                tab.Resize(oRange);

                //var ptabs = ws.PivotTables;
                //var ptab = ptabs.PivotTable("");
                //ptab.SourceRange.Range(

                //var pTab = wb.Worksheets.Worksheet(2).PivotTables.PivotTable("PivotTable1");
                //pTab.SourceRange = ws.Range(strRange);

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
                    strFileName = Title + ".xlsx";
                    return this.File(
                                   fileContents: m_Bytes,
                                  contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                   fileDownloadName: strFileName
                               );
                });
                Response.Headers.Add("xl_file_name",
                 Title);
                return await t;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if (wb != null)
                    wb.Dispose();
            }
        }
    }
}