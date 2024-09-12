using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Repositories.Logs;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.Logs;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.CoreSettings.Controllers
{
    [Authorize]
    [Area("CoreSettings")]
    public class LogsController : BaseController
    {
        private const string ConstFilterEmailIndex = "EmailIndex";

        private const string ConstFilterProcessIndex = "ProcessIndex";

        private const string ConstFilterAppTaskSchedulerLogIndex = "AppTaskSchedulerLogIndex";
        private const string ConstFilterAppProcessQueueLogIndex = "AppProcessQueueLogIndex";

        //private const string WebAPILogRAP = @"C:\WebAPILogs\RAP";
        //private const string WebAPILogTCMPLApp = @"C:\WebAPILogs\TCMPLApp";
        //private const string WebAPILogWinService = @"C:\WebAPILogs\WinService";
        //private const string WebAPILogsWebAPI = @"C:\WebAPILogs\WebAPI";
        private const string SendMailWinService = @"C:\WebAPILogs\SendMail-WinService";

        //Finished
        private readonly IUtilityRepository _utilityRepository;

        private readonly IFilterRepository _filterRepository;
        private readonly IEmailDataTableListRepository _emailDataTableListRepository;
        private readonly IEmailDetailsRepository _emailDetailsRepository;

        private readonly IAccessGrantDataTableListRepository _accessGrantDataTableListRepository;
        private readonly IAccessGrantRepository _accessGrantRepository;
        private readonly IProcessDataTableListRepository _processDataTableListRepository;
        private readonly IProcessDetailsRepository _processDetailsRepository;
        private readonly IAppTaskSchedulerLogDataTableListRepository _appTaskSchedulerLogDataTableListRepository;
        private readonly IAppProcessQueueLogDataTableListRepository _appProcessQueueLogDataTableListRepository;

        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;

        public LogsController(IEmployeeDetailsRepository employeeDetailsRepository,
                                    ISelectTcmPLRepository selectTcmPLRepository,
                                    IEmailDataTableListRepository emailDataTableListRepository,
                                    IEmailDetailsRepository emailDetailsRepository,
                                    IProcessDataTableListRepository processDataTableListRepository,
                                    IAccessGrantDataTableListRepository accessGrantDataTableListRepository,
                                    IAccessGrantRepository accessGrantRepository,
                                    IProcessDetailsRepository processDetailsRepository,
                                    IAppTaskSchedulerLogDataTableListRepository appTaskSchedulerLogDataTableListRepository,
                                    IAppProcessQueueLogDataTableListRepository appProcessQueueLogDataTableListRepository,
            IFilterRepository filterRepository,
            IUtilityRepository utilityRepository
            )
        {
            _employeeDetailsRepository = employeeDetailsRepository;
            _selectTcmPLRepository = selectTcmPLRepository;

            _filterRepository = filterRepository;
            _utilityRepository = utilityRepository;
            _emailDataTableListRepository = emailDataTableListRepository;
            _emailDetailsRepository = emailDetailsRepository;

            _processDataTableListRepository = processDataTableListRepository;
            _processDetailsRepository = processDetailsRepository;

            _appTaskSchedulerLogDataTableListRepository = appTaskSchedulerLogDataTableListRepository;
            _appProcessQueueLogDataTableListRepository = appProcessQueueLogDataTableListRepository;
            _accessGrantDataTableListRepository = accessGrantDataTableListRepository;
            _accessGrantRepository = accessGrantRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        #region Email

        #region EmailFilter

        public async Task<IActionResult> EmailFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalEmailFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> EmailFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter = JsonConvert.SerializeObject(new { filterDataModel.StartDate });

                Domain.Models.FilterCreate retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterEmailIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, filterDataModel.StartDate });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion EmailFilter

        #region Queue

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> EmailQueueIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmailViewModel emailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(emailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsEmailQueue(DTParameters param)
        {
            DTResult<EmailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<EmailDataTableList> data = await _emailDataTableListRepository.EmailQueueDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> EmailQueueDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            EmailDetailsOut result = await _emailDetailsRepository.EmailQueueDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL { PKeyId = id });

            EmailDetailsViewModel emailDetailsViewModel = new()
            {
                KeyId = id,
                EntryDate = result.PEntryDate,
                MailAttachBusiness = result.PMailAttachBusiness,
                MailAttachOs = result.PMailAttachOs,
                MailBcc = result.PMailBcc,
                MailBody1 = result.PMailBody1,
                MailBody2 = result.PMailBody2,
                MailCc = result.PMailCc,
                MailFrom = result.PMailFrom,
                MailSubject = result.PMailSubject,
                MailTo = result.PMailTo,
                MailType = result.PMailType,
                ModifiedOn = result.PModifiedOn,
                StatusCode = result.PStatusCode,
                StatusDesc = result.PStatusDesc,
                StatusMessage = result.PStatusMessage,
            };

            return PartialView("_ModalEmailDetails", emailDetailsViewModel);
        }

        #endregion Queue

        #region Sent

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> EmailSentIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmailViewModel emailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(emailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsEmailSent(DTParameters param)
        {
            DTResult<EmailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<EmailDataTableList> data = await _emailDataTableListRepository.EmailSentDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> EmailSentDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            EmailDetailsOut result = await _emailDetailsRepository.EmailSentDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL { PKeyId = id });

            EmailDetailsViewModel emailDetailsViewModel = new()
            {
                KeyId = id,
                EntryDate = result.PEntryDate,
                MailAttachBusiness = result.PMailAttachBusiness,
                MailAttachOs = result.PMailAttachOs,
                MailBcc = result.PMailBcc,
                MailBody1 = result.PMailBody1,
                MailBody2 = result.PMailBody2,
                MailCc = result.PMailCc,
                MailFrom = result.PMailFrom,
                MailSubject = result.PMailSubject,
                MailTo = result.PMailTo,
                MailType = result.PMailType,
                ModifiedOn = result.PModifiedOn,
                StatusCode = result.PStatusCode,
                StatusDesc = result.PStatusDesc,
                StatusMessage = result.PStatusMessage,
            };

            return PartialView("_ModalEmailDetails", emailDetailsViewModel);
        }

        #endregion Sent

        #endregion Email

        #region Process

        #region ProcessFilter

        public async Task<IActionResult> ProcessFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProcessIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalProcessFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ProcessFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter = JsonConvert.SerializeObject(new { filterDataModel.StartDate });

                Domain.Models.FilterCreate retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterProcessIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, filterDataModel.StartDate });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion ProcessFilter

        #region Queue

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> ProcessQueueIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProcessIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ProcessViewModel processViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(processViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsProcessQueue(DTParameters param)
        {
            DTResult<ProcessDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<ProcessDataTableList> data = await _processDataTableListRepository.ProcessQueueDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> ProcessQueueDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            ProcessDetailsOut result = await _processDetailsRepository.ProcessQueueDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL { PKeyId = id });

            ProcessDetailsViewModel ProcessDetailsViewModel = new()
            {
                KeyId = id,
                CreatedOn = result.PCreatedOn,
                EmpName = result.PEmpName,
                Empno = result.PEmpno,
                MailCc = result.PMailCc,
                MailTo = result.PMailTo,
                ModuleDesc = result.PModuleDesc,
                ModuleId = result.PModuleId,
                ParameterJson = result.PParameterJson,
                ProcessDesc = result.PParameterJson,
                ProcessFinishDate = result.PProcessFinishDate,
                ProcessId = result.PProcessId,
                ProcessStartDate = result.PProcessStartDate,
                Status = result.PStatus
            };

            return PartialView("_ModalProcessDetails", ProcessDetailsViewModel);
        }

        #endregion Queue

        #region Finished

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> ProcessFinishedIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProcessIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ProcessViewModel ProcessViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(ProcessViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsProcessFinished(DTParameters param)
        {
            DTResult<ProcessDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<ProcessDataTableList> data = await _processDataTableListRepository.ProcessFinishedDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> ProcessFinishedDetails(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            ProcessDetailsOut result = await _processDetailsRepository.ProcessFinishedDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL { PKeyId = id });

            ProcessDetailsViewModel ProcessDetailsViewModel = new()
            {
                KeyId = id,
                CreatedOn = result.PCreatedOn,
                EmpName = result.PEmpName,
                Empno = result.PEmpno,
                MailCc = result.PMailCc,
                MailTo = result.PMailTo,
                ModuleDesc = result.PModuleDesc,
                ModuleId = result.PModuleId,
                ParameterJson = result.PParameterJson,
                ProcessDesc = result.PParameterJson,
                ProcessFinishDate = result.PProcessFinishDate,
                ProcessId = result.PProcessId,
                ProcessStartDate = result.PProcessStartDate,
                Status = result.PStatus
            };

            return PartialView("_ModalProcessDetails", ProcessDetailsViewModel);
        }

        #endregion Finished

        #endregion Process

        #region AppProcessQueueLog

        public async Task<IActionResult> AppProcessQueueFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAppProcessQueueLogIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalAppProcessQueueFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AppProcessQueueFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter = JsonConvert.SerializeObject(new { filterDataModel.StartDate });

                Domain.Models.FilterCreate retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterAppProcessQueueLogIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, filterDataModel.StartDate });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> AppProcessQueueLogIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAppProcessQueueLogIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AppProcessQueueLogViewModel appProcessQueueLogViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(appProcessQueueLogViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsAppProcessQueueLog(DTParameters param)
        {
            DTResult<AppProcessQueueLogDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<AppProcessQueueLogDataTableList> data = await _appProcessQueueLogDataTableListRepository.AppProcessQueueLogDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate,
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

        #endregion AppProcessQueueLog

        #region AppTaskSchedulerLog

        public async Task<IActionResult> AppTaskSchedulerFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAppTaskSchedulerLogIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            return PartialView("_ModalAppTaskSchedulerFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> AppTaskSchedulerFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter = JsonConvert.SerializeObject(new { filterDataModel.StartDate });

                Domain.Models.FilterCreate retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterAppTaskSchedulerLogIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, filterDataModel.StartDate });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<IActionResult> AppTaskSchedulerLogIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterAppTaskSchedulerLogIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            AppTaskSchedulerLogViewModel appTaskSchedulerLogViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(appTaskSchedulerLogViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsAppTaskSchedulerLog(DTParameters param)
        {
            DTResult<AppTaskSchedulerLogDataTableList> result = new();
            int totalRow = 0;

            try
            {
                IEnumerable<AppTaskSchedulerLogDataTableList> data = await _appTaskSchedulerLogDataTableListRepository.AppTaskSchedulerLogDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PStartDate = param.StartDate
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

        #endregion AppTaskSchedulerLog

        #region Generic Methods for download files

        #region WebAPI

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public IActionResult RAPLogIndex()
        {
            LogFileViewModel logFileViewModel = new();
            return View(logFileViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsRAPLogFile(DTParameters param)
        {
            DTResult<LogFileViewModel> result = new();
            int totalRow = 0;
            string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
            string rapReportingDir = Configuration.GetSection("TCMPLAppLogDirs")["RapReporting"];

            string logDirectoryPath = Path.Combine(logDir, rapReportingDir);
            try
            {
                DirectoryInfo d = new(logDirectoryPath);
                if (d.GetFiles().Length == 0)
                {
                    result.draw = param.Draw;
                    result.recordsTotal = totalRow;
                    result.recordsFiltered = totalRow;
                    result.data = null;
                }
                //var fileList = d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList();
                List<FileInfo> fileList = await Task.Run(() => d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList());

                List<LogFileViewModel> logFileViewModelList = new();
                foreach (FileInfo file in fileList)
                {
                    LogFileViewModel logFileViewModel = new()
                    {
                        FileName = file.Name,
                        FullPath = file.FullName,
                        CreationDateTime = file.CreationTime
                    };

                    logFileViewModelList.Add(logFileViewModel);
                }

                List<LogFileViewModel> data = logFileViewModelList;

                if (data.Count > 0)
                {
                    totalRow = data.Count;
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public IActionResult TCMPLAppIndex()
        {
            LogFileViewModel logFileViewModel = new();
            return View(logFileViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsTCMPLAppLogFile(DTParameters param)
        {
            DTResult<LogFileViewModel> result = new();
            int totalRow = 0;
            string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
            string webAppDir = Configuration.GetSection("TCMPLAppLogDirs")["WebApp"];
            string logDirectoryPath = Path.Combine(logDir, webAppDir);
            try
            {
                DirectoryInfo d =new(logDirectoryPath);
                if (d.GetFiles().Length == 0)
                {
                    result.draw = param.Draw;
                    result.recordsTotal = totalRow;
                    result.recordsFiltered = totalRow;
                    result.data = null;
                }
                //var fileList = d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList();
                List<FileInfo> fileList = await Task.Run(() => d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList());

                List<LogFileViewModel> logFileViewModelList = new();
                foreach (FileInfo file in fileList)
                {
                    LogFileViewModel logFileViewModel = new()
                    {
                        FileName = file.Name,
                        FullPath = file.FullName,
                        CreationDateTime = file.CreationTime
                    };

                    logFileViewModelList.Add(logFileViewModel);
                }

                List<LogFileViewModel> data = logFileViewModelList;

                if (data.Count > 0)
                {
                    totalRow = data.Count;
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public IActionResult WinServiceIndex()
        {
            LogFileViewModel logFileViewModel = new();
            return View(logFileViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsWinServiceLogFile(DTParameters param)
        {
            DTResult<LogFileViewModel> result = new();
            int totalRow = 0;
            string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
            string winServiceDir = Configuration.GetSection("TCMPLAppLogDirs")["WinService"];

            string logDirectoryPath = Path.Combine(logDir, winServiceDir);
            try
            {
                DirectoryInfo d = new(logDirectoryPath);

                if (d.GetFiles().Length == 0)
                {
                    result.draw = param.Draw;
                    result.recordsTotal = totalRow;
                    result.recordsFiltered = totalRow;
                    result.data = null;
                }
                //var fileList = d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList();
                List<FileInfo> fileList = await Task.Run(() => d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList());

                List<LogFileViewModel> logFileViewModelList = new();
                foreach (FileInfo file in fileList)
                {
                    LogFileViewModel logFileViewModel = new()
                    {
                        FileName = file.Name,
                        FullPath = file.FullName,
                        CreationDateTime = file.CreationTime
                    };

                    logFileViewModelList.Add(logFileViewModel);
                }

                List<LogFileViewModel> data = logFileViewModelList;

                if (data.Count > 0)
                {
                    totalRow = data.Count;
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public IActionResult EmailWinServiceIndex()
        {
            LogFileViewModel logFileViewModel = new();
            return View(logFileViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsEmailWinServiceLogFile(DTParameters param)
        {
            DTResult<LogFileViewModel> result = new();
            int totalRow = 0;
            try
            {
                DirectoryInfo d = new(SendMailWinService);

                if (d.GetFiles().Length == 0)
                {
                    result.draw = param.Draw;
                    result.recordsTotal = totalRow;
                    result.recordsFiltered = totalRow;
                    result.data = null;
                }

                List<FileInfo> fileList = await Task.Run(() => d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList());

                List<LogFileViewModel> logFileViewModelList = new();
                foreach (FileInfo file in fileList)
                {
                    LogFileViewModel logFileViewModel = new()
                    {
                        FileName = file.Name,
                        FullPath = file.FullName,
                        CreationDateTime = file.CreationTime
                    };

                    logFileViewModelList.Add(logFileViewModel);
                }

                List<LogFileViewModel> data = logFileViewModelList;

                if (data.Count > 0)
                {
                    totalRow = data.Count;
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public IActionResult TCMPLAppWinServiceIndex()
        {
            LogFileViewModel logFileViewModel = new();
            return View(logFileViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, LogsHelper.ActionViewLogs)]
        public async Task<JsonResult> GetListsTCMPLAppWinServiceLogFile(DTParameters param)
        {
            DTResult<LogFileViewModel> result = new();
            int totalRow = 0;

            string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
            string WebApiDir = Configuration.GetSection("TCMPLAppLogDirs")["WebApi"];

            string logDirectoryPath = Path.Combine(logDir, WebApiDir);
            try
            {
                DirectoryInfo d = new(logDirectoryPath);

                if (d.GetFiles().Length == 0)
                {
                    result.draw = param.Draw;
                    result.recordsTotal = totalRow;
                    result.recordsFiltered = totalRow;
                    result.data = null;
                }
                //var fileList = d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList();
                List<FileInfo> fileList = await Task.Run(() => d.GetFiles().OrderByDescending(f => f.Name).Take(10).ToList());

                List<LogFileViewModel> logFileViewModelList = new();
                foreach (FileInfo file in fileList)
                {
                    LogFileViewModel logFileViewModel = new()
                    {
                        FileName = file.Name,
                        FullPath = file.FullName,
                        CreationDateTime = file.CreationTime
                    };

                    logFileViewModelList.Add(logFileViewModel);
                }

                List<LogFileViewModel> data = logFileViewModelList;

                if (data.Count > 0)
                {
                    totalRow = data.Count;
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

        #endregion WebAPI

        public IActionResult DownloadFile(string fpath)
        {
            if (fpath == null)
            {
                return NotFound();
            }
            byte[] bytes = StorageHelper.DirectDownloadFile(fpath);

            return File(bytes, "application/octet-stream");
        }

        #endregion Generic Methods for download files

        #region Download Excel

        public async Task<IActionResult> ExcelDownloadAccessGrant()
        {
            try
            {
                var result = await _accessGrantRepository.GenerateAccessGrantAsync(
                BaseSpTcmPLGet(), new ParameterSpTcmPL());

                if (result.ParamMsgType != "SUCCESS")
                {
                    return NotFound(result.ParamMsgType);
                }

                string StrFileName = "AccessGrant_" + DateTime.Now.ToFileTime().ToString();

                var data = await _accessGrantDataTableListRepository.AccessGrantList(
                BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PRowNumber = 0,
                    PPageLength = 0,
                });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<AccessGrantExcelModel> excelData = JsonConvert.DeserializeObject<IEnumerable<AccessGrantExcelModel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "AccessGrant", "Data");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Download Excel

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                Domain.Models.FilterReset result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
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
    }
}