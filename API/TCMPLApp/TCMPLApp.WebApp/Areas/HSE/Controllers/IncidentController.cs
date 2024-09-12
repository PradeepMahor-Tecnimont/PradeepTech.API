using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HSE;
using TCMPLApp.Domain.Models.HSE;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using Microsoft.AspNetCore.Authorization;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Linq;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.WebApp.Models;
using TCMPLApp.DataAccess.Models;
using System;
using TCMPLApp.WebApp.CustomPolicyProvider;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Net;
using System.Collections.Generic;
using static TCMPLApp.WebApp.Classes.DTModel;
using DocumentFormat.OpenXml.Drawing;


namespace TCMPLApp.WebApp.Areas.HSE.Controllers
{
    [Authorize]
    [Area("HSE")]
    public class IncidentController : BaseController
    {
        private const string ConstFilterIncidentIndex = "IncidentIndex";
        private const string ConstFilterCoordinateIndex = "CoordinateIndex";

        private readonly IConfiguration _configuration;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly ISelectRepository _selectRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IIncidentRepository _incidentRepository;
        private readonly IIncidentDataTableListRepository _incidentDataTableListRepository;
        private readonly IIncidentDetailRepository _incidentDetailRepository;
        private readonly IIncidentRecipientListRepository _incidentRecipientListRepository;


        public IncidentController(
            IConfiguration configuration,
            IUtilityRepository utilityRepository,
            IFilterRepository filterRepository,
            ISelectRepository selectRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IIncidentRepository incidentRepository,
            IIncidentDataTableListRepository incidentDataTableListRepository,
            IIncidentDetailRepository incidentDetailRepository,
            IIncidentRecipientListRepository incidentRecipientListRepository
            )
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _utilityRepository = utilityRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _selectRepository = selectRepository;
            _incidentRepository = incidentRepository;
            _incidentDataTableListRepository = incidentDataTableListRepository;
            _incidentDetailRepository = incidentDetailRepository;
            _incidentRecipientListRepository = incidentRecipientListRepository;
        }

        #region Employee

        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterIncidentIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            IncidentDataTableListViewModel incidentDataTableListViewModel = new IncidentDataTableListViewModel();
            incidentDataTableListViewModel.FilterDataModel = filterDataModel;

            return View(incidentDataTableListViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> Detail(string id)
        {
            if (id == null)
                return NotFound();

            var result = await _incidentDetailRepository.IncidentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL {  PReportid = id });

            IncidentDetailViewModel incident = new IncidentDetailViewModel();            

            if (result.PMessageType == IsOk)
            {
                var officeList = _selectTcmPLRepository.GetListOffice();
                var officeName = officeList.Where(o => o.DataValueField == result.POffice).Select(s => s.DataTextField).ToList();

                incident.Reportid = id;
                incident.Reportdate = result.PReportdate;
                incident.Yyyy = result.PYyyy;
                incident.Office = officeName[0];
                incident.Loc = result.PLoc;
                incident.Costcode = result.PCostcode;
                incident.Incdate = result.PIncdate;
                incident.Inctime = result.PInctime;
                incident.Inctype = result.PInctype;
                incident.Inctypename = result.PInctypename;
                incident.Nature = result.PNature;
                incident.Naturename = result.PNaturename;                
                incident.Injuredparts = result.PInjuredparts;
                incident.Empno = result.PEmpno;
                incident.Empname = result.PEmpname;
                incident.Desg = result.PDesg;
                incident.Age = result.PAge;
                incident.Sex = result.PSex;
                incident.Subcontract = result.PSubcontract;
                incident.Subcontractname = result.PSubcontractname;
                incident.Aid = result.PAid;
                incident.Description = result.PDescription;
                incident.Causes = result.PCauses;
                incident.Action = result.PAction;
                incident.Mailsend = result.PMailsend;
                incident.Isactive = result.PIsactive;
                incident.Isdelete = result.PIsdelete;
            }

            ViewData["ReportId"] = id;
            return PartialView("_ModalDetail", incident);           
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetLists(DTParameters param)
        {
            int totalRow = 0;           

            DTResult<IncidentDataTableList> result = new DTResult<IncidentDataTableList>();

            try
            {
                var data = await _incidentDataTableListRepository.IncidentDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,                        
                        PIsActive = param.IsActive,
                        PShowall = 0,
                        PGenericSearch = param.GenericSearch,
                        PStatusstring = null
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]        
        public async Task<IActionResult> Create()
        {
            Incident incident = new Incident();
            
            var officeList = _selectTcmPLRepository.GetListOffice();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            var incidenttypes = await _selectTcmPLRepository.HSEIncidentTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["IncidentTypeList"] = new SelectList(incidenttypes, "DataValueField", "DataTextField");

            var naturetypes = await _selectTcmPLRepository.HSENatureTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["NatureTypeList"] = new SelectList(naturetypes, "DataValueField", "DataTextField");

            var costcenterList = await _selectRepository.CostcenterWithEmployeeSelectListCacheAsync();
            ViewData["CostcenterList"] = new SelectList(costcenterList, "DataValueField", "DataTextField");
            
            return View("Create", incident);
        }

        [HttpPost]        
        public async Task<IActionResult> Create([FromForm] IncidentCreateViewModel incidentCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _incidentRepository.IncidentCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            POffice = incidentCreateViewModel.Office,
                            PLoc = incidentCreateViewModel.Loc,
                            PCostcode = incidentCreateViewModel.Costcode,
                            PIncdate = incidentCreateViewModel.Incdate,
                            PInctime = incidentCreateViewModel.Inctime,
                            PInctype = incidentCreateViewModel.Inctype,
                            PNature = incidentCreateViewModel.Nature,
                            PBHead = Convert.ToInt32(incidentCreateViewModel.BHead),
                            PBNeck = Convert.ToInt32(incidentCreateViewModel.BNeck),
                            PBForearm = Convert.ToInt32(incidentCreateViewModel.BForearm),
                            PBLegs = Convert.ToInt32(incidentCreateViewModel.BLegs),
                            PBFace = Convert.ToInt32(incidentCreateViewModel.BFace),
                            PBShoulder = Convert.ToInt32(incidentCreateViewModel.BShoulder),
                            PBElbow = Convert.ToInt32(incidentCreateViewModel.BElbow),
                            PBKnee = Convert.ToInt32(incidentCreateViewModel.BKnee),
                            PBMouth = Convert.ToInt32(incidentCreateViewModel.BMouth),
                            PBChest = Convert.ToInt32(incidentCreateViewModel.BChest),
                            PBWrist = Convert.ToInt32(incidentCreateViewModel.BWrist),
                            PBAnkle = Convert.ToInt32(incidentCreateViewModel.BAnkle),
                            PBEar = Convert.ToInt32(incidentCreateViewModel.BEar),
                            PBAbdomen = Convert.ToInt32(incidentCreateViewModel.BAbdomen),
                            PBHip = Convert.ToInt32(incidentCreateViewModel.BHip),
                            PBFoot = Convert.ToInt32(incidentCreateViewModel.BFoot),
                            PBEye = Convert.ToInt32(incidentCreateViewModel.BEye),
                            PBBack = Convert.ToInt32(incidentCreateViewModel.BBack),
                            PBThigh = Convert.ToInt32(incidentCreateViewModel.BThigh),
                            PBOther = Convert.ToInt32(incidentCreateViewModel.BOther),
                            PEmpno = incidentCreateViewModel.Empno ?? " ",
                            PEmpname = incidentCreateViewModel.Empname,
                            PDesg = incidentCreateViewModel.Desg ?? " ",
                            PAge = incidentCreateViewModel.Age,
                            PSex = incidentCreateViewModel.Sex,
                            PSubcontract = incidentCreateViewModel.Subcontract,
                            PSubcontractname = incidentCreateViewModel.Subcontractname ?? " ",
                            PAid = incidentCreateViewModel.Aid,
                            PDescription = incidentCreateViewModel.Description,
                            PCauses = incidentCreateViewModel.Causes,
                            PAction = incidentCreateViewModel.Action
                        });

                    if (result.PMessageType != "OK")                   
                    {                       
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);                        
                    }
                    else
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                        return RedirectToAction("Index");
                    }
                }
            }
            catch (Exception ex)
            {
                //return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
                Notify("Error", StringHelper.CleanExceptionMessage(ex.Message).Replace("-", " "), "toaster", NotificationType.error);
            }

            Incident incident = new()
            {
                Office = incidentCreateViewModel.Office,
                Loc = incidentCreateViewModel.Loc,
                Costcode = incidentCreateViewModel.Costcode,
                Incdate = incidentCreateViewModel.Incdate,
                Inctime = incidentCreateViewModel.Inctime,
                Inctype = incidentCreateViewModel.Inctype,
                Nature = incidentCreateViewModel.Nature,
                BHead = incidentCreateViewModel.BHead,
                BNeck = incidentCreateViewModel.BNeck,
                BForearm = incidentCreateViewModel.BForearm,
                BLegs = incidentCreateViewModel.BLegs,
                BFace = incidentCreateViewModel.BFace,
                BShoulder = incidentCreateViewModel.BShoulder,
                BElbow = incidentCreateViewModel.BElbow,
                BKnee = incidentCreateViewModel.BKnee,
                BMouth = incidentCreateViewModel.BMouth,
                BChest = incidentCreateViewModel.BChest,
                BWrist = incidentCreateViewModel.BWrist,
                BAnkle = incidentCreateViewModel.BAnkle,
                BEar = incidentCreateViewModel.BEar,
                BAbdomen = incidentCreateViewModel.BAbdomen,
                BHip = incidentCreateViewModel.BHip,
                BFoot = incidentCreateViewModel.BFoot,
                BEye = incidentCreateViewModel.BEye,
                BBack = incidentCreateViewModel.BBack,
                BThigh = incidentCreateViewModel.BThigh,
                BOther = incidentCreateViewModel.BOther,
                Empno = incidentCreateViewModel.Empno,
                Empname = incidentCreateViewModel.Empname,
                Desg = incidentCreateViewModel.Desg,
                Age = incidentCreateViewModel.Age,
                Sex = incidentCreateViewModel.Sex,
                Subcontract = incidentCreateViewModel.Subcontract,
                Subcontractname = incidentCreateViewModel.Subcontractname ?? " ",
                Aid = incidentCreateViewModel.Aid,
                Description = incidentCreateViewModel.Description,
                Causes = incidentCreateViewModel.Causes,
                Action = incidentCreateViewModel.Action
            };

            var officeList = _selectTcmPLRepository.GetListOffice();
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            var incidenttypes = await _selectTcmPLRepository.HSEIncidentTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["IncidentTypeList"] = new SelectList(incidenttypes, "DataValueField", "DataTextField");

            var naturetypes = await _selectTcmPLRepository.HSENatureTypeListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["NatureTypeList"] = new SelectList(naturetypes, "DataValueField", "DataTextField");

            var costcenterList = await _selectRepository.CostcenterWithEmployeeSelectListCacheAsync();
            ViewData["CostcenterList"] = new SelectList(costcenterList, "DataValueField", "DataTextField");

            return View(incident);
        }

        #endregion Employee

        #region Coordinate
        
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HSEHelper.ActionIncidentAdmin)]
        public async Task<IActionResult> CoordinateIndex()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCoordinateIndex
            });
            FilterDataModel filterDataModel = new FilterDataModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            IncidentDataTableListViewModel incidentDataTableListViewModel = new IncidentDataTableListViewModel();
            incidentDataTableListViewModel.FilterDataModel = filterDataModel;

            incidentDataTableListViewModel.FilterDataModel.StatusString = filterDataModel.StatusString ?? "In Process";

            return View(incidentDataTableListViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]        
        public async Task<JsonResult> GetCoordinateLists(DTParameters param)
        {
            int totalRow = 0;

            DTResult<IncidentDataTableList> result = new DTResult<IncidentDataTableList>();

            try
            {
                var data = await _incidentDataTableListRepository.IncidentDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PIsActive = param.IsActive,
                        PShowall = 1,
                        PGenericSearch = param.GenericSearch,
                        PStatusstring = param.Statusstring
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
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HSEHelper.ActionIncidentAdmin)]
        public async Task<IActionResult> CoordinateDetail(string id)
        {
            if (id == null)
                return NotFound();
            
            var result = await _incidentDetailRepository.IncidentDetail(
                         BaseSpTcmPLGet(), new ParameterSpTcmPL { PReportid = id });

            IncidentDetailViewModel incident = new IncidentDetailViewModel();

            if (result.PMessageType == IsOk)
            {
                var officeList = _selectTcmPLRepository.GetListOffice();
                var officeName = officeList.Where(o => o.DataValueField == result.POffice).Select(s => s.DataTextField).ToList();

                incident.Reportid = id;
                incident.Reportdate = result.PReportdate;
                incident.Yyyy = result.PYyyy;
                incident.Office = officeName[0];
                incident.Loc = result.PLoc;
                incident.Costcode = result.PCostcode;
                incident.Incdate = result.PIncdate;
                incident.Inctime = result.PInctime;
                incident.Inctype = result.PInctype;
                incident.Inctypename = result.PInctypename;
                incident.Nature = result.PNature;
                incident.Naturename = result.PNaturename;
                incident.Injuredparts = result.PInjuredparts;
                incident.Empno = result.PEmpno;
                incident.Empname = result.PEmpname;
                incident.Desg = result.PDesg;
                incident.Age = result.PAge;
                incident.Sex = result.PSex;
                incident.Subcontract = result.PSubcontract;
                incident.Subcontractname = result.PSubcontractname;
                incident.Aid = result.PAid;
                incident.Description = result.PDescription;
                incident.Causes = result.PCauses;
                incident.Action = result.PAction;
                incident.CorrectiveActions = result.PCorrectiveactions;
                incident.Closer = result.PCloser;
                incident.CloserDate = result.PCloserdate;
                incident.AttchmentLink = result.PAttchmentlink;
                incident.Mailsend = result.PMailsend;
                incident.Isactive = result.PIsactive;
                incident.Isdelete = result.PIsdelete;
            }

            ViewData["ReportId"] = id;
            return PartialView("_ModalCoordinateDetail", incident);           
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HSEHelper.ActionIncidentAdmin)]
        public async Task<IActionResult> CoordinateMailsend(string id)
        {
            if (id == null)
                return NotFound();

            IncidentMailsendViewModel incidentMailsendViewModel = new IncidentMailsendViewModel();

            incidentMailsendViewModel.Reportid = id;

            var incidentDetail = await _incidentDetailRepository.IncidentDetail(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PReportid = id
                });

            var incidentMailsend = await _incidentRecipientListRepository.IncidentRecipientList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PReportid = id
                });

            ViewData["ReportId"] = id;
            ViewData["InjuredPerson"] = incidentDetail.PEmpname;
            ViewData["IncidentMailsend"] = incidentMailsend;
            return PartialView("_ModalMailsend", incidentMailsendViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction,HSEHelper.ActionIncidentAdmin)]
        public async Task<IActionResult> CoordinateMailsend([FromForm] IncidentMailsendViewModel incidentMailsendViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _incidentRepository.IncidentMailsendAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PReportid = incidentMailsendViewModel.Reportid,
                            PRecipients = incidentMailsendViewModel.Recipients
                        });

                    if (result.PMessageType == "OK")
                    {
                        return Json(new { success = "OK", response = result.PMessageText });
                    }
                    else
                    {
                        throw new Exception(result.PMessageText.Replace("-", " "));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return Json(new { });
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HSEHelper.ActionIncidentAdmin)]
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var result = await _incidentRepository.IncidentDeleteAsync(BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PReportid = id
                        });

                if (result.PMessageType == "OK")
                {
                    return Json(new { success = "OK", response = result.PMessageText });
                }
                else
                {
                    throw new Exception(result.PMessageText.Replace("-", " "));
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HSEHelper.ActionIncidentAdmin)]
        public IActionResult CloseIncident(string id)
        {
            IncidentCloseViewModel incidentCloseViewModel = new IncidentCloseViewModel();
            incidentCloseViewModel.Reportid = id;            
            return PartialView("_ModalClose", incidentCloseViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HSEHelper.ActionIncidentAdmin)]
        public async Task<IActionResult> CloseIncident([FromForm] IncidentCloseViewModel incidentCloseViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _incidentRepository.IncidentCloseAsync(BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PReportid = incidentCloseViewModel.Reportid,
                            PCorrectiveactions = incidentCloseViewModel.CorrectiveActions,
                            PCloser = incidentCloseViewModel.Closer,
                            PCloserdate = incidentCloseViewModel.CloserDate,
                            PAttchmentlink = incidentCloseViewModel.AttchmentLink ?? " "
                        });

                    if (result.PMessageType == "OK")
                    {
                        Notify("Success", result.PMessageText, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", result.PMessageText, "toaster", NotificationType.error);
                    }                    
                }                
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }

            return Json(new { });            
        }

        #endregion Coordinate

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

                return Json(new { success = result.OutPSuccess == "OK", response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> FilterGet()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCoordinateIndex
            });

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            if(filterDataModel.StatusString == null) 
                filterDataModel.StatusString = "In Process";

            return PartialView("_FilterSetPartial", filterDataModel);
        }

        [HttpPost]
        public async Task <IActionResult> FilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;

                jsonFilter = JsonConvert.SerializeObject(new { StatusString = filterDataModel.StatusString });

                var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterCoordinateIndex,
                    PFilterJson = jsonFilter
                });

                return Json(new { success = true, statusString = filterDataModel.StatusString });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter
    }
}