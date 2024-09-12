using ClosedXML.Excel;
using DocumentFormat.OpenXml.Packaging;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using MoreLinq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Library.Excel.Writer;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Area("DMS")]
    public class ReportsController : BaseController
    {
        private const string ConstFilterStatusIndex = "StatusIndex";
        private const string ConstFilterWorkloadIndex = "WorkloadIndex";

        private readonly IConfiguration _configuration;
        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IDeskManagementStatusDataTableLisRepository _deskManagementStatusDataTableLisRepository;
        private readonly IDeskManagementWorkloadDataTableLisRepository _deskManagementWorkloadDataTableLisRepository;
        private readonly IAssetDistributionDataTableListRepository _assetDistributionDataTableListRepository;
        private readonly IEmployeeAssetStatusDataTableListRepository _employeeAssetStatusDataTableListRepository;
        private readonly IAssetWithITPoolDataTableListRepository _assetWithITPoolDataTableListRepository;
        private readonly IDMSReportDataTableListRepository _dmsReportDataTableListRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;

        private readonly IInvLaptopLotwiseDataTableListExcelRepository _invLaptopLotwiseDataTableListExcelRepository;
        private readonly IOfficeDeskStatusDataListRepository _officeDeskStatusDataListRepository;
        private readonly IEmpDeskInMoreThanPlacesDataTableListRepository _empDeskInMoreThanPlacesDataTableListRepository;

        private readonly TextInfo textInfo = CultureInfo.CurrentCulture.TextInfo;

        public ReportsController(IConfiguration configuration,
                                 IFilterRepository filterRepository,
                                 IUtilityRepository utilityRepository,
                                 IDeskManagementStatusDataTableLisRepository deskManagementStatusDataTableLisRepository,
                                 IDeskManagementWorkloadDataTableLisRepository deskManagementWorkloadDataTableLisRepository,
                                 IAssetDistributionDataTableListRepository assetDistributionDataTableListRepository,
                                 IEmployeeAssetStatusDataTableListRepository employeeAssetStatusDataTableListRepository,
                                 IAssetWithITPoolDataTableListRepository assetWithITPoolDataTableListRepository,
                                 IDMSReportDataTableListRepository dmsReportDataTableListRepository,
                                 ISelectTcmPLRepository selectTcmPLRepository,
                                 IInvLaptopLotwiseDataTableListExcelRepository invLaptopLotwiseDataTableListExcelRepository,
                                 IOfficeDeskStatusDataListRepository officeDeskStatusDataListRepository,
                                 IEmpDeskInMoreThanPlacesDataTableListRepository empDeskInMoreThanPlacesDataTableListRepository)
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _utilityRepository = utilityRepository;
            _deskManagementStatusDataTableLisRepository = deskManagementStatusDataTableLisRepository;
            _deskManagementWorkloadDataTableLisRepository = deskManagementWorkloadDataTableLisRepository;
            _assetDistributionDataTableListRepository = assetDistributionDataTableListRepository;
            _employeeAssetStatusDataTableListRepository = employeeAssetStatusDataTableListRepository;
            _assetWithITPoolDataTableListRepository = assetWithITPoolDataTableListRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _invLaptopLotwiseDataTableListExcelRepository = invLaptopLotwiseDataTableListExcelRepository;
            _dmsReportDataTableListRepository = dmsReportDataTableListRepository;
            _officeDeskStatusDataListRepository = officeDeskStatusDataListRepository;
            _empDeskInMoreThanPlacesDataTableListRepository = empDeskInMoreThanPlacesDataTableListRepository;
        }

        #region Desk management status

        public async Task<IActionResult> StatusIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterStatusIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskManagementStatusIndexViewModel deskManagementStatusIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskManagementStatusIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetDeskManagementStatusLists(DTParameters param)
        {
            DTResult<DeskManagementStatusDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<DeskManagementStatusDataTableList> data = await _deskManagementStatusDataTableLisRepository.DeskManagementStatusDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        POffice = param.Office,
                        PFloor = param.Floor,
                        PWing = param.Wing,
                        PCabin = param.Cabin,
                        PGrade = param.Grade,
                        PDepartment = param.Department,
                        PPcModelList = param.PcModelList,
                        PMonitorModel = param.MonitorModel,
                        PTelephoneModel = param.TelModel,
                        PPrinterModel = param.PrinterModel,
                        PDocstnModel = param.DocstnModel,
                        PDualMonitor = param.DualMonitor,
                        PVacantDesk = param.VacantDesk,
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> StatusIndexDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterStatusIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Desk_Management_Status_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                var data = await _dmsReportDataTableListRepository.DeskManagementStatusExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = filterDataModel.GenericSearch ?? " ",
                        POffice = filterDataModel.Office,
                        PFloor = filterDataModel.Floor,
                        PWing = filterDataModel.Wing,
                        PCabin = filterDataModel.Cabin,
                        PGrade = filterDataModel.Grade,
                        PDepartment = filterDataModel.Department,
                        PPcModelList = filterDataModel.PcModelList,
                        PMonitorModel = filterDataModel.MonitorModel,
                        PTelephoneModel = filterDataModel.TelModel,
                        PPrinterModel = filterDataModel.PrinterModel,
                        PDocstnModel = filterDataModel.DocstnModel,
                        PDualMonitor = filterDataModel.DualMonitor,
                        PVacantDesk = filterDataModel.VacantDesk,
                        PRowNumber = 0,
                        PPageLength = 990000
                    });

                if (data == null) { return NotFound(); }

                //var json = JsonConvert.SerializeObject(data);

                //IEnumerable<DeskManagementStatusDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<DeskManagementStatusDataTableExcel>>(json);

                foreach (System.Data.DataColumn col in data.Columns)
                {
                    col.ColumnName = textInfo.ToTitleCase(textInfo.ToLower(col.ColumnName.ToLower().Replace("_", " "))).Replace(" ", "");
                }

                data.Columns.Remove("RowNumber");
                data.Columns.Remove("TotalRow");

                byte[] byteContent = _utilityRepository.ExcelDownloadFromDataTable(data, "Desk Management status", "Desk Management status");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Desk management status

        #region Workload

        public async Task<IActionResult> WorkloadIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterWorkloadIndex
            });

            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            DeskManagementWorkloadIndexViewModel deskManagementWorkloadIndexViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(deskManagementWorkloadIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetDeskManagementWorkloadLists(DTParameters param)
        {
            DTResult<DeskManagementWorkloadDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<DeskManagementWorkloadDataTableList> data = await _deskManagementWorkloadDataTableLisRepository.DeskManagementWorkloadDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PFrom = param.StartDate,
                        PTo = param.EndDate,
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> WorkloadFilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterWorkloadIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            return PartialView("_ModalWorkloadFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> WorkloadFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                if (filterDataModel.StartDate != null || filterDataModel.EndDate != null)
                {
                    if (filterDataModel.StartDate == null || filterDataModel.EndDate == null)
                    {
                        throw new Exception("Both the dates are required.");
                    }
                    else if (filterDataModel.StartDate > filterDataModel.EndDate)
                    {
                        throw new Exception("End date should be greater than start date");
                    }
                }
                {
                    string jsonFilter;
                    jsonFilter = JsonConvert.SerializeObject(
                            new
                            {
                                filterDataModel.StartDate,
                                filterDataModel.EndDate
                            }
                            );

                    var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                    {
                        PModuleName = CurrentUserIdentity.CurrentModule,
                        PMetaId = CurrentUserIdentity.MetaId,
                        PPersonId = CurrentUserIdentity.EmployeeId,
                        PMvcActionName = ConstFilterWorkloadIndex,
                        PFilterJson = jsonFilter
                    });

                    return Json(new
                    {
                        success = true,
                        startDate = filterDataModel.StartDate,
                        endDate = filterDataModel.EndDate
                    });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            //return PartialView("_ModalLeaveFilterSet", filterDataModel);
        }

        public async Task<IActionResult> WorkloadResetFilter(string ActionId)
        {
            try
            {
                var result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == "OK", response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Workload

        #region EmpDeskInMoreThan1PlacesIndex

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> EmpInMoreThan1PlacesIndex()
        {
            EmpDeskInMoreThan1PlacesIndexViewModel empDeskInMoreThan1PlacesIndexViewModel = new();

            return View(empDeskInMoreThan1PlacesIndexViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> DeskInMoreThan1PlacesIndex()
        {
            EmpDeskInMoreThan1PlacesIndexViewModel empDeskInMoreThan1PlacesIndexViewModel = new();

            return View(empDeskInMoreThan1PlacesIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<JsonResult> GetEmpLists(DTParameters param)
        {
            DTResult<EmpDeskInMoreThanPlacesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<EmpDeskInMoreThanPlacesDataTableList> data = await _empDeskInMoreThanPlacesDataTableListRepository.EmployeeDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<JsonResult> GetDeskLists(DTParameters param)
        {
            DTResult<EmpDeskInMoreThanPlacesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<EmpDeskInMoreThanPlacesDataTableList> data = await _empDeskInMoreThanPlacesDataTableListRepository.DeskDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> EmpDeskInMoreThan1PlacesExcelDownload()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "EmpDeskInMoreThan1Places" + timeStamp.ToString();

                IEnumerable<EmpDeskInMoreThanPlacesDataTableList> deskData = await _empDeskInMoreThanPlacesDataTableListRepository.DeskDataTableListAsync(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PGenericSearch = " ",
                         PRowNumber = 0,
                         PPageLength = 9999
                     }
                 );

                IEnumerable<EmpDeskInMoreThanPlacesDataTableList> empData = await _empDeskInMoreThanPlacesDataTableListRepository.EmployeeDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = " ",
                        PRowNumber = 0,
                        PPageLength = 9999
                    }
                );

                using XLWorkbook wb = new();

                var sheet1 = wb.Worksheets.Add("Employee");
                _ = sheet1.Cell(3, 1).InsertTable(empData);

                var sheet2 = wb.Worksheets.Add("Desk");
                _ = sheet2.Cell(3, 1).InsertTable(deskData);

                wb.Worksheet("Employee").Column(5).Delete();
                wb.Worksheet("Employee").Column(6).Delete();

                wb.Worksheet("Desk").Column(5).Delete();
                wb.Worksheet("Desk").Column(6).Delete();

                await Task.Delay(1000);

                using MemoryStream stream = new();
                wb.SaveAs(stream);
                stream.Position = 0;
                byte[] byteContent = stream.ToArray();

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion EmpDeskInMoreThan1PlacesIndex

        #region Asset with IT pool

        public async Task<IActionResult> AssetwithITPool()
        {
            try
            {
                string StrFileName = "Asset_with_IT_Pool_" + DateTime.Now.ToFileTime().ToString();

                var result = await _assetWithITPoolDataTableListRepository.AssetWithITPoolDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                var settings = new JsonSerializerSettings
                {
                    DateFormatString = "dd-MMM-yyyy",
                    Formatting = (Formatting)1,
                    ContractResolver = new CustomContractResolverForAssetDistributionXL()
                };

                byte[] xls_Bytes = null;
                using (XLWorkbook wb = new())
                {
                    ExcelFromDataTable(wb, result, "Asset with IT pool", "AssetWithITPool");

                    wb.CalculateMode = XLCalculateMode.Auto;

                    using (MemoryStream ms = new())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        xls_Bytes = ms.ToArray();
                    }

                    wb.Dispose();
                }

                return File(xls_Bytes,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> EmployeeAssetWithITPoolExcel()
        {
            FilterDataModel filterDataModel = new();

            var invAssetCategoryList = await _selectTcmPLRepository.InvItemTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["AssetCategoryList"] = new SelectList(invAssetCategoryList, "DataValueField", "DataTextField");

            return PartialView("_ModalAssetWithITPoolExcelFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeAssetWithITPoolExcel(string assetCategoryVal, string assetCategoryText)
        {
            try
            {
                string StrFileName = "Asset_with_IT_Pool_" + DateTime.Now.ToFileTime().ToString();
                string strReportFor = "";

                if (string.IsNullOrEmpty(assetCategoryVal) && string.IsNullOrEmpty(assetCategoryText))
                {
                    strReportFor = $"_All_";
                }
                else
                {
                    strReportFor = $"_{assetCategoryText.Replace("-", "")}_";
                    strReportFor = assetCategoryText.Replace(" ", "");
                }

                StrFileName = "Asset_with_IT_Pool" + strReportFor + DateTime.Now.ToFileTime().ToString();

                var result = await _assetWithITPoolDataTableListRepository.AssetWithITPoolDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PAssetCategory = assetCategoryVal
                            });

                var settings = new JsonSerializerSettings
                {
                    DateFormatString = "dd-MMM-yyyy",
                    Formatting = (Formatting)1,
                    ContractResolver = new CustomContractResolverForAssetDistributionXL()
                };

                byte[] xls_Bytes = null;
                using (XLWorkbook wb = new())
                {
                    ExcelFromDataTable(wb, result, "Asset with IT pool " + $" {strReportFor.Replace("_", " ")}", "AssetWithITPool");

                    wb.CalculateMode = XLCalculateMode.Auto;

                    using (MemoryStream ms = new())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        xls_Bytes = ms.ToArray();
                    }

                    wb.Dispose();
                }

                return File(xls_Bytes,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Asset with IT pool

        #region >>>>>>>>>>> Excel Download <<<<<<<<<<<<<<

        #region ExcelDownloadAssetDistribution

        public async Task<IActionResult> ExcelDownloadAssetDistribution1()
        {
            try
            {
                string StrFileName = "AssetDistribution_" + DateTime.Now.ToFileTime().ToString();

                var dataAssetDistribution = await _assetDistributionDataTableListRepository.AssetDistributionDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                var dataEmployeeAssetStatus = await _employeeAssetStatusDataTableListRepository.EmployeeAssetsDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                var settings = new JsonSerializerSettings
                {
                    DateFormatString = "dd-MMM-yyyy",
                    Formatting = (Formatting)1,
                    ContractResolver = new CustomContractResolverForAssetDistributionXL()
                };

                byte[] xls_Bytes = null;
                using (XLWorkbook wb = new())
                {
                    ExcelFromIEnumerable(wb, dataAssetDistribution, "Asset Distribution", "AssetDistribution");

                    ExcelFromDataTable(wb, dataEmployeeAssetStatus, "Employee Asset Status", "EmployeeAssetStatus");

                    wb.CalculateMode = XLCalculateMode.Auto;

                    using (MemoryStream ms = new())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        xls_Bytes = ms.ToArray();
                    }

                    wb.Dispose();
                }

                return File(xls_Bytes,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ExcelDownloadAssetDistribution()
        {
            try
            {
                string startDate = DateTime.Now.ToFileTime().ToString();
                string StrFileName = "AssetDistribution_" + startDate + ".xlsx";
                //string excelFileName = "AssetDistributionTemplate.xlsx";
                var dataAssetDistribution = await _assetDistributionDataTableListRepository.AssetDistributionDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                var dataEmployeeAssets = await _employeeAssetStatusDataTableListRepository.EmployeeAssetsDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                var dataLaptopLotwiseAll = await _invLaptopLotwiseDataTableListExcelRepository.LaptopLotwiseAllDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                var dataLaptopLotwiseIssued = await _invLaptopLotwiseDataTableListExcelRepository.LaptopLotwiseIssuedDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                var dataLaptopLotwisePending = await _invLaptopLotwiseDataTableListExcelRepository.LaptopLotwisePendingDataTableListForExcelAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                            });

                byte[] byteContent = null;

                using (XLWorkbook wb = new())
                {
                    //var columns = (dt.GetType().GetGenericArguments()[0]).GetProperties();

                    //Int32 cols = columns.Count();
                    //Int32 rows = dt.ToList().Count;

                    string sheetNameAssetDistribution = "AssetDistribution";
                    string sheetNameEmployeeAssets = "EmployeeAssets";
                    string sheetNameLaptopLotwiseAll = "LaptopLotwiseAll";
                    string sheetNameLaptopLotwiseIssued = "LaptopLotwiseIssued";
                    string sheetNameLaptopLotwisePending = "LaptopLotwisePending";

                    IXLWorksheet wsAssetDistribution = wb.Worksheets.Add(sheetNameAssetDistribution);
                    wsAssetDistribution.Cell("A1").Value = "Asset Distribution";
                    _ = wsAssetDistribution.Cell(3, 1).InsertTable(dataAssetDistribution);

                    IXLWorksheet wsEmployeeAssetStatusData = wb.Worksheets.Add(sheetNameEmployeeAssets);
                    wsEmployeeAssetStatusData.Cell("A1").Value = "Employee Assets";
                    _ = wsEmployeeAssetStatusData.Cell(3, 1).InsertTable(dataEmployeeAssets);

                    IXLWorksheet wsLaptopLotwiseAll = wb.Worksheets.Add(sheetNameLaptopLotwiseAll);
                    wsLaptopLotwiseAll.Cell("A1").Value = "Laptop Lotwise All";
                    _ = wsLaptopLotwiseAll.Cell(3, 1).InsertTable(dataLaptopLotwiseAll);

                    IXLWorksheet wsLaptopLotwiseIssued = wb.Worksheets.Add(sheetNameLaptopLotwiseIssued);
                    wsLaptopLotwiseIssued.Cell("A1").Value = "Laptop Lotwise Issued";
                    _ = wsLaptopLotwiseIssued.Cell(3, 1).InsertTable(dataLaptopLotwiseIssued);

                    IXLWorksheet wsLaptopLotwisePending = wb.Worksheets.Add(sheetNameLaptopLotwisePending);
                    wsLaptopLotwisePending.Cell("A1").Value = "Laptop Lotwise Pending";
                    _ = wsLaptopLotwisePending.Cell(3, 1).InsertTable(dataLaptopLotwisePending);

                    using MemoryStream ms = new();
                    wb.SaveAs(ms);
                    byte[] buffer = ms.GetBuffer();
                    long length = ms.Length;
                    byteContent = ms.ToArray();
                }

                return File(byteContent, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", StrFileName);

                //var settings = new JsonSerializerSettings();
                //settings.DateFormatString = "dd-MMM-yyyy";
                //settings.Formatting = (Formatting)1;
                //settings.ContractResolver = new CustomContractResolverForAssetDistributionXL();

                //var template = new XLTemplate(StorageHelper.GetFilePath(StorageHelper.DMS.Repository, FileName: excelFileName, Configuration));

                //string assetDistributionDataTableName = "AssetDistribution";
                //string employeeAssetStatusDataTableName = "EmployeeAssetStatusData";

                //var wb = template.Workbook;

                //wb.Table(assetDistributionDataTableName).ReplaceData(dataAssetDistribution);
                //wb.Table(employeeAssetStatusDataTableName).ReplaceData(dataEmployeeAssetStatus);

                //wb.Worksheet(assetDistributionDataTableName).Cell("A1").Value = "AssetDistribution";

                //wb.Worksheet(employeeAssetStatusDataTableName).Cell("A1").Value = "EmployeeAssetStatus";

                //byte[] byteContent = null;

                //using (MemoryStream ms = new MemoryStream())
                //{
                //    wb.SaveAs(ms);
                //    byte[] buffer = ms.GetBuffer();
                //    long length = ms.Length;
                //    byteContent = ms.ToArray();
                //}

                //return File(byteContent,
                //        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                //        StrFileName);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public void ExcelFromIEnumerable<T>(XLWorkbook wb, IEnumerable<T> dt, string ReportTitle, string Sheetname)
        {
            var columns = dt.GetType().GetGenericArguments()[0].GetProperties();

            int cols = columns.Count();
            int rows = dt.ToList().Count;

            IXLWorksheet ws = wb.Worksheets.Add(Sheetname);
            if (cols < 20)
            {
                ws.Range(1, 1, 1, cols).Value = ReportTitle;
                ws.Range(1, 1, 1, cols).Style.Font.FontSize = 16;
                ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                _ = ws.Range(1, 1, 1, cols).Merge();
                ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            }
            else
            {
                ws.Range(1, 1, 1, 1).Value = ReportTitle;
                ws.Range(1, 1, 1, 1).Style.Font.FontSize = 16;
                ws.Range(1, 1, 1, 1).Style.Font.Bold = true;
            }
            _ = ws.Cell(3, 1).InsertTable(dt);

            var rngTable = ws.Range("A3:" + Convert.ToChar(65 + (cols - 1)) + (rows + 3));
            rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
            rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
            rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
            rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

            _ = ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
            _ = ws.Columns().AdjustToContents();
        }

        public void ExcelFromDataTable(XLWorkbook wb, DataTable dt, string ReportTitle, string Sheetname)
        {
            int cols = dt.Columns.Count;
            int rows = dt.Rows.Count;

            IXLWorksheet ws = wb.Worksheets.Add(Sheetname);
            if (cols < 20)
            {
                ws.Range(1, 1, 1, cols).Value = ReportTitle;
                ws.Range(1, 1, 1, cols).Style.Font.FontSize = 16;
                ws.Range(1, 1, 1, cols).Style.Font.Bold = true;
                _ = ws.Range(1, 1, 1, cols).Merge();
                ws.Range(1, 1, 1, cols).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            }
            else
            {
                ws.Range(1, 1, 1, 1).Value = ReportTitle;
                ws.Range(1, 1, 1, 1).Style.Font.FontSize = 16;
                ws.Range(1, 1, 1, 1).Style.Font.Bold = true;
            }
            _ = ws.Cell(3, 1).InsertTable(dt);

            IXLRange rngTable = cols > 26
                ? ws.Range("A3:A" + Convert.ToChar(65 + (cols - 26 - 1)) + (rows + 3))
                : ws.Range("A3:" + Convert.ToChar(65 + (cols - 1)) + (rows + 3));
            rngTable.Style.Border.TopBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.TopBorderColor = XLColor.LightGray;
            rngTable.Style.Border.BottomBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.BottomBorderColor = XLColor.LightGray;
            rngTable.Style.Border.LeftBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.LeftBorderColor = XLColor.LightGray;
            rngTable.Style.Border.RightBorder = XLBorderStyleValues.Thin;
            rngTable.Style.Border.RightBorderColor = XLColor.LightGray;

            _ = ws.Tables.FirstOrDefault().SetShowAutoFilter(false);
            _ = ws.Columns().AdjustToContents();
        }

        #endregion ExcelDownloadAssetDistribution

        #region OfficeDeskStatusReprot

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> OfficeDeskStatusExcelDownload()
        {
            var timeStamp = DateTime.Now.ToFileTime();
            string excelFileName = "OfficeDeskStatusTemplate.xlsx";
            var data = await _officeDeskStatusDataListRepository.OfficeDeskStatusDataListXlAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            if (!data.Any())
            {
                Notify("Error", "No data exists", "toaster", notificationType: NotificationType.error);
            }
            string strFileName = string.Empty;
            strFileName = "OfficeStatus_" + timeStamp + ".xlsx";

            byte[] byteContent1 = null;

            string dataSheetName = "Data";

            byte[] templateBytes = System.IO.File.ReadAllBytes(StorageHelper.GetTemplateFilePath(StorageHelper.DMS.Repository, FileName: excelFileName, Configuration));
            using (MemoryStream templateStream = new MemoryStream())
            {
                templateStream.Write(templateBytes, 0, templateBytes.Length);

                using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(templateStream, true))
                {
                    XLBookWriter.AppendDataInExcel(spreadsheetDocument, dataSheetName, "DataList", data);
                    spreadsheetDocument.Save();
                }
                long length = templateStream.Length;
                byteContent1 = templateStream.ToArray();
            }

            return File(byteContent1,
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    strFileName);
        }

        #endregion OfficeDeskStatusReprot

        #endregion >>>>>>>>>>> Excel Download <<<<<<<<<<<<<<

        #region Filter

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                var result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == IsOk, response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName,
                PFilterJson = jsonFilter
            });
            return retVal;
        }

        private async Task<Domain.Models.FilterRetrieve> RetriveFilter(string ActionName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        public async Task<IActionResult> FilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterStatusIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var dmsOfficeList = await _selectTcmPLRepository.DmsOfficeList(BaseSpTcmPLGet(), null);
            ViewData["DmsOfficeList"] = new SelectList(dmsOfficeList, "DataValueField", "DataTextField");

            var dmsFloorList = await _selectTcmPLRepository.DmsFloorList(BaseSpTcmPLGet(), null);
            ViewData["DmsFloorList"] = new SelectList(dmsFloorList, "DataValueField", "DataTextField");

            var dmsWingList = await _selectTcmPLRepository.DmsWingList(BaseSpTcmPLGet(), null);
            ViewData["DmsWingList"] = new SelectList(dmsWingList, "DataValueField", "DataTextField");

            var dmsDepartmentList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);
            ViewData["DmsDepartmentList"] = new SelectList(dmsDepartmentList, "DataValueField", "DataTextField");

            var dmsGradeList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), null);
            ViewData["DmsGradeList"] = new SelectList(dmsGradeList, "DataValueField", "DataTextField");

            //var dmsDesignationList = await _selectTcmPLRepository.GradeListSWP(BaseSpTcmPLGet(), null);
            //ViewData["DmsDesignationList"] = new SelectList(dmsDesignationList, "DataValueField", "DataTextField");

            var dmsPcModelList = await _selectTcmPLRepository.PcModelList(BaseSpTcmPLGet(), null);
            ViewData["DmsPcModelList"] = new SelectList(dmsPcModelList, "DataValueField", "DataTextField");

            var dmsMonitorModelList = await _selectTcmPLRepository.MonitorModelList(BaseSpTcmPLGet(), null);
            ViewData["DmsMonitorModelList"] = new SelectList(dmsMonitorModelList, "DataValueField", "DataTextField");

            //var dmsTelModelList = await _selectTcmPLRepository.TelModelList(BaseSpTcmPLGet(), null);
            //ViewData["DmsTelModelList"] = new SelectList(dmsTelModelList, "DataValueField", "DataTextField");

            //var dmsPrinterModelList = await _selectTcmPLRepository.PrinterModelList(BaseSpTcmPLGet(), null);
            //ViewData["DmsPrinterModelList"] = new SelectList(dmsPrinterModelList, "DataValueField", "DataTextField");

            //var dmsDockStationModelList = await _selectTcmPLRepository.DockStationModelList(BaseSpTcmPLGet(), null);
            //ViewData["DmsDockStationModelList"] = new SelectList(dmsDockStationModelList, "DataValueField", "DataTextField");

            return PartialView("_ModalReportFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.Office,
                            filterDataModel.Floor,
                            filterDataModel.Wing,
                            filterDataModel.Department,
                            filterDataModel.Grade,
                            filterDataModel.PcModelList,
                            filterDataModel.MonitorModel,
                            filterDataModel.TelModel,
                            filterDataModel.PrinterModel,
                            filterDataModel.DocstnModel,
                            filterDataModel.DualMonitor,
                            filterDataModel.VacantDesk
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterStatusIndex);

                return Json(new
                {
                    success = true,
                    office = filterDataModel.Office,
                    floor = filterDataModel.Floor,
                    wing = filterDataModel.Wing,
                    department = filterDataModel.Department,
                    grade = filterDataModel.Grade,
                    //designation = filterDataModel.Designation,
                    pcModelList = filterDataModel.PcModelList,
                    monitorModel = filterDataModel.MonitorModel,
                    telModel = filterDataModel.TelModel,
                    printerModel = filterDataModel.PrinterModel,
                    docstnModel = filterDataModel.DocstnModel,
                    dualMonitor = filterDataModel.DualMonitor,
                    vacantDesk = filterDataModel.VacantDesk
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter
    }
}