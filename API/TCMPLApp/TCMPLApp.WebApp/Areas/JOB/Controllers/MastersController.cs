using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using static TCMPLApp.WebApp.Classes.DTModel;
using TCMPLApp.WebApp.Models;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Drawing.Charts;
using NuGet.Protocol.Plugins;
using System.Net.NetworkInformation;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.DataAccess.Repositories.JOB;

namespace TCMPLApp.WebApp.Areas.JOB.Controllers
{
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobFormAdmin)]
    [Area("JOB")]
    public class MastersController : BaseController
    {
        private const string ConstFilterTMAGroupsIndex = "JobTMAGroupsIndex";
        private const string ConstFilterJobCopanyMasterIndex = "JobCopanyMasterIndex";
        private const string ConstFilterBusinessLinesIndex = "JobBusinessLinesIndex";
        private const string ConstFilterSubBusinessLinesIndex = "JobSubBusinessLinesIndex";
        private const string ConstFilterSegmentsIndex = "JobSegmentsIndex";
        private const string ConstFilterScopeOfWorks = "JobScopeOfWorkIndex";
        private const string ConstFilterPlantTypes = "JobPlantTypesIndex";
        private const string ConstFilterProjectTypes = "JobProjectTypesIndex";

        private readonly IFilterRepository _filterRepository;

        private readonly ITMAGroupsDataTableListRepository _TMAGroupsDataTableListRepository;
        private readonly ITMAGroupsRepository _TMAGroupsRepository;
        private readonly ITMAGroupsDetailRepository _TMAGroupsDetailRepository;

        private readonly IBusinessLinesDataTableListRepository _businessLinesDataTableListRepository;
        private readonly IBusinessLinesRepository _businessLinesRepository;
        private readonly IBusinessLinesDetailRepository _businessLinesDetailRepository;

        private readonly IJobCoMasterDataTableListRepository _jobCoMasterDataTableListRepository;
        private readonly IJobCoMasterRepository _jobCoMasterRepository;
        private readonly IJobCoMasterDetailRepository _jobCoMasterDetailRepository;

        private readonly ISubBusinessLinesDataTableListRepository _subBusinessLinesDataTableListRepository;
        private readonly ISubBusinessLinesRepository _subBusinessLinesRepository;
        private readonly ISubBusinessLinesDetailRepository _subBusinessLinesDetailRepository;

        private readonly ISegmentsDataTableListRepository _segmentsDataTableListRepository;
        private readonly ISegmentsRepository _segmentsRepository;
        private readonly ISegmentsDetailRepository _segmentsDetailRepository;

        private readonly IScopeOfWorkDataTableListRepository _scopeOfWorkDataTableListRepository;
        private readonly IScopeOfWorkRepository _scopeOfWorkRepository;
        private readonly IScopeOfWorkDetailRepository _scopeOfWorkDetailRepository;

        private readonly IPlantTypesDataTableListRepository _plantTypesDataTableListRepository;
        private readonly IPlantTypesRepository _plantTypesRepository;
        private readonly IPlantTypesDetailRepository _plantTypesDetailRepository;

        private readonly IProjectTypesDataTableListRepository _projectTypesDataTableListRepository;
        private readonly IProjectTypesRepository _projectTypesRepository;
        private readonly IProjectTypesDetailRepository _projectTypesDetailRepository;

        private readonly IUtilityRepository _utilityRepository;

        public MastersController(
            IFilterRepository filterRepository,
            ITMAGroupsDataTableListRepository TMAGroupsDataTableListRepository,
            ITMAGroupsRepository TMAGroupsRepository,
            ITMAGroupsDetailRepository TMAGroupsDetailRepository,
            IUtilityRepository utilityRepository,
            IBusinessLinesDataTableListRepository businessLinesDataTableListRepository,
            IBusinessLinesRepository businessLinesRepository,
            IBusinessLinesDetailRepository businessLinesDetailRepository,
            ISubBusinessLinesDataTableListRepository subBusinessLinesDataTableListRepository,
            ISubBusinessLinesRepository subBusinessLinesRepository,
            ISubBusinessLinesDetailRepository subBusinessLinesDetailRepository,
            ISegmentsDataTableListRepository segmentsDataTableListRepository,
            ISegmentsRepository segmentsRepository,
            ISegmentsDetailRepository segmentsDetailRepository,
            IScopeOfWorkDataTableListRepository scopeOfWorkDataTableListRepository,
            IScopeOfWorkRepository scopeOfWorkRepository,
            IScopeOfWorkDetailRepository scopeOfWorkDetailRepository,
            IPlantTypesDataTableListRepository plantTypesDataTableListRepository,
            IPlantTypesRepository plantTypesRepository,
            IPlantTypesDetailRepository plantTypesDetailRepository,
            IProjectTypesDataTableListRepository projectTypesDataTableListRepository,
            IProjectTypesRepository projectTypesRepository,
            IProjectTypesDetailRepository projectTypesDetailRepository,

            IJobCoMasterDataTableListRepository jobCoMasterDataTableListRepository,
        IJobCoMasterRepository jobCoMasterRepository,
        IJobCoMasterDetailRepository jobCoMasterDetailRepository
            )
        {
            _filterRepository = filterRepository;
            _TMAGroupsDataTableListRepository = TMAGroupsDataTableListRepository;
            _utilityRepository = utilityRepository;
            _TMAGroupsRepository = TMAGroupsRepository;
            _TMAGroupsDetailRepository = TMAGroupsDetailRepository;
            _businessLinesDataTableListRepository = businessLinesDataTableListRepository;
            _businessLinesRepository = businessLinesRepository;
            _businessLinesDetailRepository = businessLinesDetailRepository;
            _subBusinessLinesDataTableListRepository = subBusinessLinesDataTableListRepository;
            _subBusinessLinesRepository = subBusinessLinesRepository;
            _subBusinessLinesDetailRepository = subBusinessLinesDetailRepository;
            _segmentsDataTableListRepository = segmentsDataTableListRepository;
            _segmentsRepository = segmentsRepository;
            _segmentsDetailRepository = segmentsDetailRepository;
            _scopeOfWorkDataTableListRepository = scopeOfWorkDataTableListRepository;
            _scopeOfWorkRepository = scopeOfWorkRepository;
            _scopeOfWorkDetailRepository = scopeOfWorkDetailRepository;
            _plantTypesDataTableListRepository = plantTypesDataTableListRepository;
            _plantTypesRepository = plantTypesRepository;
            _plantTypesDetailRepository = plantTypesDetailRepository;
            _projectTypesDataTableListRepository = projectTypesDataTableListRepository;
            _projectTypesRepository = projectTypesRepository;
            _projectTypesDetailRepository = projectTypesDetailRepository;

            _jobCoMasterDataTableListRepository = jobCoMasterDataTableListRepository;
            _jobCoMasterRepository = jobCoMasterRepository;
            _jobCoMasterDetailRepository = jobCoMasterDetailRepository;
        }


        public IActionResult Index()
        {
            return View();
        }

        #region TMAGroups

        public async Task<IActionResult> TMAGroupsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTMAGroupsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            TMAGroupsViewModel TMAGroupsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(TMAGroupsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTMAGroups(DTParameters param)
        {
            DTResult<TMAGroupsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<TMAGroupsDataTableList> data = await _TMAGroupsDataTableListRepository.TMAGroupsDataTableListAsync(
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
        public IActionResult TMAGroupsCreate()
        {
            TMAGroupsCreateViewModel TMAGroupsCreateViewModel = new();

            return PartialView("_ModalTMAGroupsCreatePartial", TMAGroupsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> TMAGroupsCreate([FromForm] TMAGroupsCreateViewModel TMAGroupsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _TMAGroupsRepository.TMAGroupsCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTmaGroup = TMAGroupsCreateViewModel.TmaGroup,
                            PSubGroup = TMAGroupsCreateViewModel.SubGroup,
                            PTmaGroupDesc = TMAGroupsCreateViewModel.TmaGroupDesc
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalTMAGroupsCreatePartial", TMAGroupsCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> TMAGroupsEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            TMAGroupsDetails result = await _TMAGroupsDetailRepository.TMAGroupsDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTmaGroup = id
                });

            TMAGroupsUpdateViewModel TMAGroupsUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                TMAGroupsUpdateViewModel.TmaGroup = id;
                TMAGroupsUpdateViewModel.SubGroup = result.PSubGroup;
                TMAGroupsUpdateViewModel.TmaGroupDesc = result.PTmaGroupDesc;
            }

            return PartialView("_ModalTMAGroupsEditPartial", TMAGroupsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> TMAGroupsEdit([FromForm] TMAGroupsUpdateViewModel TMAGroupsUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _TMAGroupsRepository.TMAGroupsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTmaGroup = TMAGroupsUpdateViewModel.TmaGroup,
                            PSubGroup = TMAGroupsUpdateViewModel.SubGroup,
                            PTmaGroupDesc = TMAGroupsUpdateViewModel.TmaGroupDesc
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalTMAGroupsEditPartial", TMAGroupsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> TMAGroupsDelete(string id)
        {
            try
            {
                var result = await _TMAGroupsRepository.TMAGroupsDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTmaGroup = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> TMAGroupsExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterTMAGroupsIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "TMA Groups_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<TMAGroupsDataTableList> data = await _TMAGroupsDataTableListRepository.TMAGroupsDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<TMAGroupsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<TMAGroupsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "TMA Groups", "TMA Groups");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion TMAGroups

        #region BusinessLines

        public async Task<IActionResult> BusinessLinesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterBusinessLinesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            BusinessLinesViewModel businessLinesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(businessLinesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsBusinessLines(DTParameters param)
        {
            DTResult<BusinessLinesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<BusinessLinesDataTableList> data = await _businessLinesDataTableListRepository.BusinessLinesDataTableListAsync(
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
        public IActionResult BusinessLinesCreate()
        {
            BusinessLinesCreateViewModel businessLinesCreateViewModel = new();

            return PartialView("_ModalBusinessLinesCreatePartial", businessLinesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BusinessLinesCreate([FromForm] BusinessLinesCreateViewModel businessLinesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _businessLinesRepository.BusinessLinesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShortDescription = businessLinesCreateViewModel.ShortDescription,
                            PDescription = businessLinesCreateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalBusinessLinesCreatePartial", businessLinesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> BusinessLinesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            BusinessLinesDetails result = await _businessLinesDetailRepository.BusinessLinesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCode = id
                });

            BusinessLinesUpdateViewModel businessLinesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                businessLinesUpdateViewModel.Code = id;

                businessLinesUpdateViewModel.ShortDescription = result.PShortDescription;
                businessLinesUpdateViewModel.Description = result.PDescription;
            }

            return PartialView("_ModalBusinessLinesEditPartial", businessLinesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BusinessLinesEdit([FromForm] BusinessLinesUpdateViewModel businessLinesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _businessLinesRepository.BusinessLinesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = businessLinesUpdateViewModel.Code,
                            PShortDescription = businessLinesUpdateViewModel.ShortDescription,
                            PDescription = businessLinesUpdateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalBusinessLinesEditPartial", businessLinesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> BusinessLinesDelete(string id)
        {
            try
            {
                var result = await _businessLinesRepository.BusinessLinesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> BusinessLinesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterBusinessLinesIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Business Lines_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<BusinessLinesDataTableList> data = await _businessLinesDataTableListRepository.BusinessLinesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<BusinessLinesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<BusinessLinesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Business Lines", "Business Lines");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion BusinessLines

        #region SubBusinessLines

        public async Task<IActionResult> SubBusinessLinesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSubBusinessLinesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            SubBusinessLinesViewModel subBusinessLinesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(subBusinessLinesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsSubBusinessLines(DTParameters param)
        {
            DTResult<SubBusinessLinesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<SubBusinessLinesDataTableList> data = await _subBusinessLinesDataTableListRepository.SubBusinessLinesDataTableListAsync(
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
        public IActionResult SubBusinessLinesCreate()
        {
            SubBusinessLinesCreateViewModel subBusinessLinesCreateViewModel = new();

            return PartialView("_ModalSubBusinessLinesCreatePartial", subBusinessLinesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SubBusinessLinesCreate([FromForm] SubBusinessLinesCreateViewModel subBusinessLinesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _subBusinessLinesRepository.SubBusinessLinesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShortDescription = subBusinessLinesCreateViewModel.ShortDescription,
                            PDescription = subBusinessLinesCreateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalSubBusinessLinesCreatePartial", subBusinessLinesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> SubBusinessLinesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            SubBusinessLinesDetails result = await _subBusinessLinesDetailRepository.SubBusinessLinesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCode = id
                });

            SubBusinessLinesUpdateViewModel subBusinessLinesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                subBusinessLinesUpdateViewModel.Code = id;

                subBusinessLinesUpdateViewModel.ShortDescription = result.PShortDescription;
                subBusinessLinesUpdateViewModel.Description = result.PDescription;
            }

            return PartialView("_ModalSubBusinessLinesEditPartial", subBusinessLinesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SubBusinessLinesEdit([FromForm] SubBusinessLinesUpdateViewModel subBusinessLinesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _subBusinessLinesRepository.SubBusinessLinesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = subBusinessLinesUpdateViewModel.Code,
                            PShortDescription = subBusinessLinesUpdateViewModel.ShortDescription,
                            PDescription = subBusinessLinesUpdateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalSubBusinessLinesEditPartial", subBusinessLinesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> SubBusinessLinesDelete(string id)
        {
            try
            {
                var result = await _subBusinessLinesRepository.SubBusinessLinesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> SubBusinessLinesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterSubBusinessLinesIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Sub Business Lines_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<SubBusinessLinesDataTableList> data = await _subBusinessLinesDataTableListRepository.SubBusinessLinesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<SubBusinessLinesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<SubBusinessLinesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Sub Business Lines", "Sub Business Lines");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion SubBusinessLines

        #region Segments

        public async Task<IActionResult> SegmentsIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterSegmentsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            SegmentsViewModel segmentsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(segmentsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsSegments(DTParameters param)
        {
            DTResult<SegmentsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<SegmentsDataTableList> data = await _segmentsDataTableListRepository.SegmentsDataTableListAsync(
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
        public IActionResult SegmentsCreate()
        {
            SegmentsCreateViewModel segmentsCreateViewModel = new();

            return PartialView("_ModalSegmentsCreatePartial", segmentsCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SegmentsCreate([FromForm] SegmentsCreateViewModel segmentsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _segmentsRepository.SegmentsCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = segmentsCreateViewModel.Code,
                            PDescription = segmentsCreateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalSegmentsCreatePartial", segmentsCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> SegmentsEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            SegmentsDetails result = await _segmentsDetailRepository.SegmentsDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCode = id
                });

            SegmentsUpdateViewModel segmentsUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                segmentsUpdateViewModel.Code = id;
                segmentsUpdateViewModel.Description = result.PDescription;
            }

            return PartialView("_ModalSegmentsEditPartial", segmentsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SegmentsEdit([FromForm] SegmentsUpdateViewModel segmentsUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _segmentsRepository.SegmentsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = segmentsUpdateViewModel.Code,
                            PDescription = segmentsUpdateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalSegmentsEditPartial", segmentsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAdm)]
        public async Task<IActionResult> SegmentsDelete(string id)
        {
            try
            {
                var result = await _segmentsRepository.SegmentsDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> SegmentsExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterSegmentsIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Segments_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<SegmentsDataTableList> data = await _segmentsDataTableListRepository.SegmentsDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<SegmentsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<SegmentsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Segments", "Segments");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Segments

        #region ScopeOfWorks

        public async Task<IActionResult> ScopeOfWorkIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterScopeOfWorks
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ScopeOfWorkViewModel scopeOfWorkViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(scopeOfWorkViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsScopeOfWork(DTParameters param)
        {
            DTResult<ScopeOfWorkDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<ScopeOfWorkDataTableList> data = await _scopeOfWorkDataTableListRepository.ScopeOfWorkDataTableListAsync(
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
        public IActionResult ScopeOfWorkCreate()
        {
            ScopeOfWorkCreateViewModel scopeOfWorkCreateViewModel = new();

            return PartialView("_ModalScopeOfWorkCreatePartial", scopeOfWorkCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ScopeOfWorkCreate([FromForm] ScopeOfWorkCreateViewModel scopeOfWorkCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _scopeOfWorkRepository.ScopeOfWorkCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShortDescription = scopeOfWorkCreateViewModel.ShortDescription,
                            PDescription = scopeOfWorkCreateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalScopeOfWorkCreatePartial", scopeOfWorkCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ScopeOfWorkEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            ScopeOfWorkDetails result = await _scopeOfWorkDetailRepository.ScopeOfWorkDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCode = id
                });

            ScopeOfWorkUpdateViewModel scopeOfWorkUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                scopeOfWorkUpdateViewModel.Code = id;

                scopeOfWorkUpdateViewModel.ShortDescription = result.PShortDescription;
                scopeOfWorkUpdateViewModel.Description = result.PDescription;
            }

            return PartialView("_ModalScopeOfWorkEditPartial", scopeOfWorkUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ScopeOfWorkEdit([FromForm] ScopeOfWorkUpdateViewModel scopeOfWorkUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _scopeOfWorkRepository.ScopeOfWorkEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = scopeOfWorkUpdateViewModel.Code,
                            PShortDescription = scopeOfWorkUpdateViewModel.ShortDescription,
                            PDescription = scopeOfWorkUpdateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalScopeOfWorkEditPartial", scopeOfWorkUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> ScopeOfWorkDelete(string id)
        {
            try
            {
                var result = await _scopeOfWorkRepository.ScopeOfWorkDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> ScopeOfWorkExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterScopeOfWorks
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Scope Of Work_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<ScopeOfWorkDataTableList> data = await _scopeOfWorkDataTableListRepository.ScopeOfWorkDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<ScopeOfWorkDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<ScopeOfWorkDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Scope Of Work", "Scope Of Work");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion ScopeOfWorks

        #region PlantTypes

        public async Task<IActionResult> PlantTypesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterPlantTypes
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            PlantTypesViewModel plantTypesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(plantTypesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsPlantTypes(DTParameters param)
        {
            DTResult<PlantTypesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<PlantTypesDataTableList> data = await _plantTypesDataTableListRepository.PlantTypesDataTableListAsync(
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

        public async Task<IActionResult> PlantTypesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterPlantTypes
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Plant Types_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<PlantTypesDataTableList> data = await _plantTypesDataTableListRepository.PlantTypesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<PlantTypesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<PlantTypesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Plant Types", "Plant Types");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public IActionResult PlantTypesCreate()
        {
            PlantTypesCreateViewModel plantTypesCreateViewModel = new();

            return PartialView("_ModalPlantTypesCreatePartial", plantTypesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PlantTypesCreate([FromForm] PlantTypesCreateViewModel plantTypesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _plantTypesRepository.PlantTypesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShortDescription = plantTypesCreateViewModel.ShortDescription,
                            PDescription = plantTypesCreateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalPlantTypesCreatePartial", plantTypesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> PlantTypesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            PlantTypesDetails result = await _plantTypesDetailRepository.PlantTypesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCode = id
                });

            PlantTypesUpdateViewModel plantTypesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                plantTypesUpdateViewModel.Code = id;

                plantTypesUpdateViewModel.ShortDescription = result.PShortDescription;
                plantTypesUpdateViewModel.Description = result.PDescription;
            }

            return PartialView("_ModalPlantTypesEditPartial", plantTypesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PlantTypesEdit([FromForm] PlantTypesUpdateViewModel plantTypesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _plantTypesRepository.PlantTypesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = plantTypesUpdateViewModel.Code,
                            PShortDescription = plantTypesUpdateViewModel.ShortDescription,
                            PDescription = plantTypesUpdateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalPlantTypesEditPartial", plantTypesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> PlantTypesDelete(string id)
        {
            try
            {
                var result = await _plantTypesRepository.PlantTypesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion PlantTypes

        #region ProjectTypes

        public async Task<IActionResult> ProjectTypesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProjectTypes
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ProjectTypesViewModel projectTypesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(projectTypesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProjectTypes(DTParameters param)
        {
            DTResult<ProjectTypesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<ProjectTypesDataTableList> data = await _projectTypesDataTableListRepository.ProjectTypesDataTableListAsync(
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
        public IActionResult ProjectTypesCreate()
        {
            ProjectTypesCreateViewModel projectTypesCreateViewModel = new();

            return PartialView("_ModalProjectTypesCreatePartial", projectTypesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectTypesCreate([FromForm] ProjectTypesCreateViewModel projectTypesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _projectTypesRepository.ProjectTypesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PShortDescription = projectTypesCreateViewModel.ShortDescription,
                            PDescription = projectTypesCreateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalProjectTypesCreatePartial", projectTypesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> ProjectTypesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            ProjectTypesDetails result = await _projectTypesDetailRepository.ProjectTypesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCode = id
                });

            ProjectTypesUpdateViewModel projectTypesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                projectTypesUpdateViewModel.Code = id;

                projectTypesUpdateViewModel.ShortDescription = result.PShortDescription;
                projectTypesUpdateViewModel.Description = result.PDescription;
            }

            return PartialView("_ModalProjectTypesEditPartial", projectTypesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProjectTypesEdit([FromForm] ProjectTypesUpdateViewModel projectTypesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _projectTypesRepository.ProjectTypesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = projectTypesUpdateViewModel.Code,
                            PShortDescription = projectTypesUpdateViewModel.ShortDescription,
                            PDescription = projectTypesUpdateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalProjectTypesEditPartial", projectTypesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> ProjectTypesDelete(string id)
        {
            try
            {
                var result = await _projectTypesRepository.ProjectTypesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        public async Task<IActionResult> ProjectTypesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterProjectTypes
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Project Types_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<ProjectTypesDataTableList> data = await _projectTypesDataTableListRepository.ProjectTypesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<ProjectTypesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<ProjectTypesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Project Types", "Project Types");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion ProjectTypes

        #region JobCoMaster

        public async Task<IActionResult> JobCoMasterIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterJobCopanyMasterIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            JobCoMasterViewModel jobCoMasterViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(jobCoMasterViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsJobCoMaster(DTParameters param)
        {
            DTResult<JobCoMasterDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<JobCoMasterDataTableList> data = await _jobCoMasterDataTableListRepository.JobCoMasterDataTableListAsync(
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
        public IActionResult JobCoMasterCreate()
        {
            JobCoMasterCreateViewModel jobCoMasterCreateViewModel = new();

            return PartialView("_ModalJobCoMasterCreatePartial", jobCoMasterCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> JobCoMasterCreate([FromForm] JobCoMasterCreateViewModel jobCoMasterCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _jobCoMasterRepository.JobCoMasterCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = jobCoMasterCreateViewModel.Code,
                            PDescription = jobCoMasterCreateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalJobCoMasterCreatePartial", jobCoMasterCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> JobCoMasterEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            JobCoMasterDetails result = await _jobCoMasterDetailRepository.JobCoMasterDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PCode = id
                });

            JobCoMasterUpdateViewModel jobCoMasterUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                jobCoMasterUpdateViewModel.Code = id;
                jobCoMasterUpdateViewModel.Description = result.PDescription;
            }

            return PartialView("_ModalJobCoMasterEditPartial", jobCoMasterUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> JobCoMasterEdit([FromForm] JobCoMasterUpdateViewModel jobCoMasterUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _jobCoMasterRepository.JobCoMasterEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCode = jobCoMasterUpdateViewModel.Code,
                            PDescription = jobCoMasterUpdateViewModel.Description
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalJobCoMasterEditPartial", jobCoMasterUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionReadJob)]
        public async Task<IActionResult> JobCoMasterDelete(string id)
        {
            try
            {
                var result = await _jobCoMasterRepository.JobCoMasterDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> JobCoMasterExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterJobCopanyMasterIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Business Lines_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<JobCoMasterDataTableList> data = await _jobCoMasterDataTableListRepository.JobCoMasterDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<JobCoMasterDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<JobCoMasterDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Business Lines", "Business Lines");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion JobCoMaster
    }
}