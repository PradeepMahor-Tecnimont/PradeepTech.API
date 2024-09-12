using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [Area("HRMasters")]
    public class HRMISController : BaseController
    {
        private const string ConstPrimaryReasonNSecondaryReasonAsOther = "19";
        private const string ConstResignStatusAsNo = "01";
        private const string ConstXLDownloadTypeInternalTransfer = "InternalTransfer";
        private const string ConstXLDownloadTypeResignedEmployee = "ResignedEmployee";
        private const string ConstXLDownloadTypeProspectiveEmployees = "ProspectiveEmployees";
        private const string ConstXLDownloadTypeJoinResignList = "JoinResignList";

        private const string ConstFilterInternalTransferIndex = "InternalTransferIndex";
        private const string ConstFilterResignedEmployeeIndex = "ResignedEmployeeIndex";
        private const string ConstFilterProspectiveEmployeesIndex = "ProspectiveEmployeesIndex";
        private readonly IFilterRepository _filterRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IUtilityRepository _utilityRepository;

        private readonly IInternalTransfersDataTableListRepository _internalTransfersDataTableListRepository;
        private readonly IInternalTransfersXLDataTableListRepository _internalTransfersXLDataTableListRepository;

        private readonly IInternalTransferRepository _internalTransferRepository;
        private readonly IInternalTransferDetailRepository _internalTransferDetailRepository;

        private readonly IProspectiveEmployeesDataTableListRepository _prospectiveEmployeesDataTableListRepository;
        private readonly IProspectiveEmployeesXLDataTableListRepository _prospectiveEmployeesXLDataTableListRepository;
        private readonly IProspectiveEmployeesRepository _prospectiveEmployeesRepository;
        private readonly IProspectiveEmployeesDetailRepository _prospectiveEmployeesDetailRepository;

        private readonly IResignedEmployeeDataTableListRepository _resignedEmployeeDataTableListRepository;
        private readonly IResignedEmployeeXLDataTableListRepository _resignedEmployeeXLDataTableListRepository;
        private readonly IResignedEmployeeRepository _resignedEmployeeRepository;
        private readonly IResignedEmployeeDetailRepository _resignedEmployeeDetailRepository;
        private readonly IEmployeeDetailRepository _employeeDetailRepository;

        public HRMISController(IFilterRepository filterRepository,
            IInternalTransfersDataTableListRepository internalTransfersDataTableListRepository,
            IInternalTransfersXLDataTableListRepository internalTransfersXLDataTableListRepository,

            ISelectTcmPLRepository selectTcmPLRepository,
            IInternalTransferRepository internalTransferRepository,
            IProspectiveEmployeesDataTableListRepository prospectiveEmployeesDataTableListRepository,
            IProspectiveEmployeesXLDataTableListRepository prospectiveEmployeesXLDataTableListRepository,
            IProspectiveEmployeesRepository prospectiveEmployeesRepository,
            IResignedEmployeeDataTableListRepository resignedEmployeeDataTableListRepository,
            IResignedEmployeeXLDataTableListRepository resignedEmployeeXLDataTableListRepository,
            IResignedEmployeeRepository resignedEmployeeRepository,
            IResignedEmployeeDetailRepository resignedEmployeeDetailRepository,
            IEmployeeDetailRepository employeeDetailRepository,
            IInternalTransferDetailRepository internalTransferDetailRepository,
            IProspectiveEmployeesDetailRepository prospectiveEmployeesDetailRepository,
            IUtilityRepository utilityRepository
            )
        {
            _filterRepository = filterRepository;
            _internalTransfersDataTableListRepository = internalTransfersDataTableListRepository;
            _internalTransfersXLDataTableListRepository = internalTransfersXLDataTableListRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _internalTransferRepository = internalTransferRepository;
            _prospectiveEmployeesDataTableListRepository = prospectiveEmployeesDataTableListRepository;
            _prospectiveEmployeesXLDataTableListRepository = prospectiveEmployeesXLDataTableListRepository;
            _prospectiveEmployeesRepository = prospectiveEmployeesRepository;
            _resignedEmployeeDataTableListRepository = resignedEmployeeDataTableListRepository;
            _resignedEmployeeXLDataTableListRepository = resignedEmployeeXLDataTableListRepository;
            _resignedEmployeeRepository = resignedEmployeeRepository;
            _resignedEmployeeDetailRepository = resignedEmployeeDetailRepository;
            _employeeDetailRepository = employeeDetailRepository;
            _internalTransferDetailRepository = internalTransferDetailRepository;
            _prospectiveEmployeesDetailRepository = prospectiveEmployeesDetailRepository;
            _utilityRepository = utilityRepository;
        }

        #region ProspectiveEmployees

        public async Task<IActionResult> ProspectiveEmployeesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterProspectiveEmployeesIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ProspectiveEmployeesViewModel prospectiveEmployeesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            ViewData["XLDownloadType"] = ConstXLDownloadTypeProspectiveEmployees;
            return View(prospectiveEmployeesViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveReadAll)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsProspectiveEmployees(string paramJson)
        {
            DTResult<ProspectiveEmployeesDataTableList> result = new();

            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<ProspectiveEmployeesDataTableList> data = await _prospectiveEmployeesDataTableListRepository.ProspectiveEmployeesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        //PStartDate = param.StartDate,
                        //PEndDate = param.EndDate,
                        //POfficeCode = param.OfficeCode,
                        //PCostcode = param.Costcode,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveUpdate)]
        public async Task<IActionResult> ProspectiveEmployeesCreate()
        {
            ProspectiveEmployeesCreateViewModel prospectiveEmployeesCreateViewModel = new();

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> joiningStatusList = await _selectTcmPLRepository.HRMISJoiningStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["JoiningStatusList"] = new SelectList(joiningStatusList, "DataValueField", "DataTextField");

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> designationList = await _selectTcmPLRepository.HrMisDesignationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["DesignationList"] = new SelectList(designationList, "DataValueField", "DataTextField");

            IEnumerable<DataField> employmentTypeList = await _selectTcmPLRepository.HrMisEmpTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmploymentTypeList"] = new SelectList(employmentTypeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> sourcesOfCandidateList = await _selectTcmPLRepository.HrMisSourcesOfCandidateList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SourcesOfCandidateList"] = new SelectList(sourcesOfCandidateList, "DataValueField", "DataTextField");

            return PartialView("_ModalProspectiveEmployeesCreatePartial", prospectiveEmployeesCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProspectiveEmployeesCreate([FromForm] ProspectiveEmployeesCreateViewModel prospectiveEmployeesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _prospectiveEmployeesRepository.ProspectiveEmployeesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = prospectiveEmployeesCreateViewModel.Empno,
                            PEmpName = prospectiveEmployeesCreateViewModel.EmpName,
                            PCostcode = prospectiveEmployeesCreateViewModel.Costcode,
                            POfficeLocationCode = prospectiveEmployeesCreateViewModel.OfficeLocationCode,
                            PProposedDoj = prospectiveEmployeesCreateViewModel.ProposedDoj,
                            PJoinStatusCode = prospectiveEmployeesCreateViewModel.JoinStatusCode,

                            PGrade = prospectiveEmployeesCreateViewModel.Grade,
                            PDesignation = prospectiveEmployeesCreateViewModel.Designation,
                            PEmploymentType = prospectiveEmployeesCreateViewModel.EmploymentType,
                            PSourcesOfCandidate = prospectiveEmployeesCreateViewModel.SourcesOfCandidate,
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", prospectiveEmployeesCreateViewModel.Costcode);

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", prospectiveEmployeesCreateViewModel.OfficeLocationCode);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> joiningStatusList = await _selectTcmPLRepository.HRMISJoiningStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["JoiningStatusList"] = new SelectList(joiningStatusList, "DataValueField", "DataTextField", prospectiveEmployeesCreateViewModel.JoinStatusCode);

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField", prospectiveEmployeesCreateViewModel.Grade);

            IEnumerable<DataField> designationList = await _selectTcmPLRepository.HrMisDesignationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["DesignationList"] = new SelectList(designationList, "DataValueField", "DataTextField", prospectiveEmployeesCreateViewModel.Designation);

            IEnumerable<DataField> employmentTypeList = await _selectTcmPLRepository.HrMisEmpTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmploymentTypeList"] = new SelectList(employmentTypeList, "DataValueField", "DataTextField", prospectiveEmployeesCreateViewModel.EmploymentType);

            IEnumerable<DataField> sourcesOfCandidateList = await _selectTcmPLRepository.HrMisSourcesOfCandidateList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SourcesOfCandidateList"] = new SelectList(sourcesOfCandidateList, "DataValueField", "DataTextField", prospectiveEmployeesCreateViewModel.SourcesOfCandidate);

            return PartialView("_ModalProspectiveEmployeesCreatePartial", prospectiveEmployeesCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveUpdate)]
        public async Task<IActionResult> ProspectiveEmployeesEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ProspectiveEmployeesDetails result = await _prospectiveEmployeesDetailRepository.ProspectiveEmployeesDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                ProspectiveEmployeesUpdateViewModel prospectiveEmployeesUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    prospectiveEmployeesUpdateViewModel.KeyId = id;
                    prospectiveEmployeesUpdateViewModel.Costcode = result.PCostcode;
                    prospectiveEmployeesUpdateViewModel.EmpName = result.PEmpName;
                    prospectiveEmployeesUpdateViewModel.OfficeLocationCode = result.POfficeLocationCode;
                    prospectiveEmployeesUpdateViewModel.ProposedDoj = result.PProposedDoj;
                    prospectiveEmployeesUpdateViewModel.RevisedDoj = result.PRevisedDoj;
                    prospectiveEmployeesUpdateViewModel.JoinStatusCode = result.PJoinStatusCode;
                    prospectiveEmployeesUpdateViewModel.Empno = result.PEmpno;
                }

                IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.OfficeLocationCode);

                IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Costcode);

                IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Empno);

                IEnumerable<DataField> joiningStatusList = await _selectTcmPLRepository.HRMISJoiningStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["JoiningStatusList"] = new SelectList(joiningStatusList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.JoinStatusCode);

                return PartialView("_ModalProspectiveEmployeesUpdatePartial", prospectiveEmployeesUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProspectiveEmployeesEdit([FromForm] ProspectiveEmployeesUpdateViewModel prospectiveEmployeesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _prospectiveEmployeesRepository.ProspectiveEmployeesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = prospectiveEmployeesUpdateViewModel.KeyId,
                            PCostcode = prospectiveEmployeesUpdateViewModel.Costcode,
                            PEmpName = prospectiveEmployeesUpdateViewModel.EmpName,
                            POfficeLocationCode = prospectiveEmployeesUpdateViewModel.OfficeLocationCode,
                            PRevisedDoj = prospectiveEmployeesUpdateViewModel.RevisedDoj,
                            PJoinStatusCode = prospectiveEmployeesUpdateViewModel.JoinStatusCode,
                            PEmpno = prospectiveEmployeesUpdateViewModel.Empno
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.OfficeLocationCode);

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Costcode);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Empno);

            IEnumerable<DataField> joiningStatusList = await _selectTcmPLRepository.HRMISJoiningStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["JoiningStatusList"] = new SelectList(joiningStatusList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.JoinStatusCode);

            return PartialView("_ModalProspectiveEmployeesUpdatePartial", prospectiveEmployeesUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveUpdate)]
        public async Task<IActionResult> ProspectiveEmployeesDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _prospectiveEmployeesRepository.ProspectiveEmployeesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveUpdate)]
        public async Task<IActionResult> ProspectiveEmployeesDetailsGet(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ProspectiveEmployeesDetails result = await _prospectiveEmployeesDetailRepository.ProspectiveEmployeesDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                ProspectiveEmployeesUpdateViewModel prospectiveEmployeesUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    prospectiveEmployeesUpdateViewModel.KeyId = id;
                    prospectiveEmployeesUpdateViewModel.Costcode = result.PCostcode;
                    prospectiveEmployeesUpdateViewModel.EmpName = result.PEmpName;
                    prospectiveEmployeesUpdateViewModel.OfficeLocationCode = result.POfficeLocationCode;
                    prospectiveEmployeesUpdateViewModel.ProposedDoj = result.PProposedDoj;
                    prospectiveEmployeesUpdateViewModel.RevisedDoj = result.PRevisedDoj;
                    prospectiveEmployeesUpdateViewModel.JoinStatusCode = result.PJoinStatusCode;
                    prospectiveEmployeesUpdateViewModel.Empno = result.PEmpno;

                    prospectiveEmployeesUpdateViewModel.Grade = result.PGrade;
                    prospectiveEmployeesUpdateViewModel.Designation = result.PDesignation;
                    prospectiveEmployeesUpdateViewModel.EmploymentType = result.PEmploymentType;
                    prospectiveEmployeesUpdateViewModel.SourcesOfCandidate = result.PSourcesOfCandidate;

                    prospectiveEmployeesUpdateViewModel.PreEmploymentMedicalTest = result.PPreEmplmntMedclTest;
                    prospectiveEmployeesUpdateViewModel.MedicalRequestDate = result.PMedclRequestDate;
                    prospectiveEmployeesUpdateViewModel.ActualAppointmentDate = result.PActualApptDate;
                    prospectiveEmployeesUpdateViewModel.MedicalFitnessCertificate = result.PMedclFitnessCert;
                    prospectiveEmployeesUpdateViewModel.RemarkPreEmploymentMedicalTest = result.PRePreEmplmntMedclTest;
                    prospectiveEmployeesUpdateViewModel.RecommendationForAppointment = result.PRecForAppt;
                    prospectiveEmployeesUpdateViewModel.RecommendationIssued = result.PRecIssued;
                    prospectiveEmployeesUpdateViewModel.RecommendationReceived = result.PRecReceived;
                    prospectiveEmployeesUpdateViewModel.RemarkRecommendationForAppointment = result.PReRecAppt;
                    prospectiveEmployeesUpdateViewModel.OfferLetter = result.POfferLetter;
                }

                IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.OfficeLocationCode);

                IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Costcode);

                IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Empno);

                IEnumerable<DataField> joiningStatusList = await _selectTcmPLRepository.HRMISJoiningStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["JoiningStatusList"] = new SelectList(joiningStatusList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.JoinStatusCode);

                IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Grade);

                IEnumerable<DataField> designationList = await _selectTcmPLRepository.HrMisDesignationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["DesignationList"] = new SelectList(designationList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Designation);

                IEnumerable<DataField> employmentTypeList = await _selectTcmPLRepository.HrMisEmpTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["EmploymentTypeList"] = new SelectList(employmentTypeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.EmploymentType);

                IEnumerable<DataField> sourcesOfCandidateList = await _selectTcmPLRepository.HrMisSourcesOfCandidateList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["SourcesOfCandidateList"] = new SelectList(sourcesOfCandidateList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.SourcesOfCandidate);

                IEnumerable<DataField> preEmploymentMedicalTestList = await _selectTcmPLRepository.HrMisPreEmpMedicalTestList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["PreEmploymentMedicalTestList"] = new SelectList(preEmploymentMedicalTestList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.PreEmploymentMedicalTest);

                IEnumerable<DataField> recommendationForAppointmentList = _selectTcmPLRepository.GetListOkKoYesNo();
                ViewData["RecommendationForAppointmentList"] = new SelectList(recommendationForAppointmentList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.RecommendationForAppointment);

                IEnumerable<DataField> offerLetterList = _selectTcmPLRepository.GetListOkKoYesNo();
                ViewData["OfferLetterList"] = new SelectList(offerLetterList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.OfferLetter);

                return View("ProspectiveEmployeesDetail", prospectiveEmployeesUpdateViewModel);
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }
            return RedirectToAction("ProspectiveEmployeesIndex");
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISProspectiveUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ProspectiveEmployeesDetailsEdit([FromForm] ProspectiveEmployeesUpdateViewModel prospectiveEmployeesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _prospectiveEmployeesRepository.ProspectiveEmployeesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = prospectiveEmployeesUpdateViewModel.KeyId,
                            PCostcode = prospectiveEmployeesUpdateViewModel.Costcode,
                            PEmpName = prospectiveEmployeesUpdateViewModel.EmpName,
                            POfficeLocationCode = prospectiveEmployeesUpdateViewModel.OfficeLocationCode,
                            PRevisedDoj = prospectiveEmployeesUpdateViewModel.RevisedDoj,
                            PJoinStatusCode = prospectiveEmployeesUpdateViewModel.JoinStatusCode,
                            PEmpno = prospectiveEmployeesUpdateViewModel.Empno,

                            PGrade = prospectiveEmployeesUpdateViewModel.Grade,
                            PDesignation = prospectiveEmployeesUpdateViewModel.Designation,
                            PEmploymentType = prospectiveEmployeesUpdateViewModel.EmploymentType,
                            PSourcesOfCandidate = prospectiveEmployeesUpdateViewModel.SourcesOfCandidate,

                            PPreEmplmntMedclTest = prospectiveEmployeesUpdateViewModel.PreEmploymentMedicalTest,
                            PMedclRequestDate = prospectiveEmployeesUpdateViewModel.MedicalRequestDate,
                            PActualApptDate = prospectiveEmployeesUpdateViewModel.ActualAppointmentDate,
                            PMedclFitnessCert = prospectiveEmployeesUpdateViewModel.MedicalFitnessCertificate,
                            PRePreEmplmntMedclTest = prospectiveEmployeesUpdateViewModel.RemarkPreEmploymentMedicalTest,

                            PRecForAppt = prospectiveEmployeesUpdateViewModel.RecommendationForAppointment,
                            PRecIssued = prospectiveEmployeesUpdateViewModel.RecommendationIssued,
                            PRecReceived = prospectiveEmployeesUpdateViewModel.RecommendationReceived,
                            PReRecAppt = prospectiveEmployeesUpdateViewModel.RemarkRecommendationForAppointment,

                            POfferLetter = prospectiveEmployeesUpdateViewModel.OfferLetter,
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error",
                            StringHelper.CleanExceptionMessage(result.PMessageText), "",
                            result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.OfficeLocationCode);

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Costcode);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Empno);

            IEnumerable<DataField> joiningStatusList = await _selectTcmPLRepository.HRMISJoiningStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["JoiningStatusList"] = new SelectList(joiningStatusList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.JoinStatusCode);

            IEnumerable<DataField> gradeList = await _selectTcmPLRepository.HrMisGradeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["GradeList"] = new SelectList(gradeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Grade);

            IEnumerable<DataField> designationList = await _selectTcmPLRepository.HrMisDesignationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["DesignationList"] = new SelectList(designationList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.Designation);

            IEnumerable<DataField> employmentTypeList = await _selectTcmPLRepository.HrMisEmpTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmploymentTypeList"] = new SelectList(employmentTypeList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.EmploymentType);

            IEnumerable<DataField> sourcesOfCandidateList = await _selectTcmPLRepository.HrMisSourcesOfCandidateList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["SourcesOfCandidateList"] = new SelectList(sourcesOfCandidateList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.SourcesOfCandidate);

            IEnumerable<DataField> preEmploymentMedicalTestList = await _selectTcmPLRepository.HrMisPreEmpMedicalTestList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["PreEmploymentMedicalTestList"] = new SelectList(preEmploymentMedicalTestList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.PreEmploymentMedicalTest);

            IEnumerable<DataField> recommendationForAppointmentList = _selectTcmPLRepository.GetListOkKoYesNo();
            ViewData["RecommendationForAppointmentList"] = new SelectList(recommendationForAppointmentList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.RecommendationForAppointment);

            IEnumerable<DataField> offerLetterList = _selectTcmPLRepository.GetListOkKoYesNo();
            ViewData["OfferLetterList"] = new SelectList(offerLetterList, "DataValueField", "DataTextField", prospectiveEmployeesUpdateViewModel.OfferLetter);

            return View("ProspectiveEmployeesDetail", prospectiveEmployeesUpdateViewModel);
        }

        #endregion ProspectiveEmployees

        #region InternalTransfers

        public async Task<IActionResult> InternalTransfersIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterInternalTransferIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InternalTransferViewModel internalTransfersViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            ViewData["XLDownloadType"] = ConstXLDownloadTypeInternalTransfer;

            return View(internalTransfersViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISTransfersReadAll)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInternalTransfer(string paramJson)
        {
            DTResult<InternalTransferDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InternalTransferDataTableList> data = await _internalTransfersDataTableListRepository.InternalTransferDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        //PStartDate = param.StartDate,
                        //PEndDate = param.EndDate,
                        //PFromDept = param.FromDept,
                        //PToDept = param.ToDept,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISTransfersUpdate)]
        public async Task<IActionResult> InternalTransferCreate()
        {
            InternalTransferCreateViewModel internalTransferCreateViewModel = new();
            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            return PartialView("_ModalInternalTransferCreatePartial", internalTransferCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISTransfersUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InternalTransferCreate([FromForm] InternalTransferCreateViewModel internalTransferCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _internalTransferRepository.InternalTransferCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = internalTransferCreateViewModel.Empno,
                            PFromCostcode = internalTransferCreateViewModel.FromCostcode,
                            PToCostcode = internalTransferCreateViewModel.ToCostcode,
                            PTransferDate = internalTransferCreateViewModel.TransferDate
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", internalTransferCreateViewModel.ToCostcode);

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", internalTransferCreateViewModel.Empno);

            return PartialView("_ModalInternalTransferCreatePartial", internalTransferCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISTransfersUpdate)]
        public async Task<IActionResult> InternalTransferEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                InternalTransferDetails result = await _internalTransferDetailRepository.InternalTransferDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                InternalTransferUpdateViewModel internalTransferUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    internalTransferUpdateViewModel.KeyId = id;
                    internalTransferUpdateViewModel.Empno = result.PEmpno;
                    internalTransferUpdateViewModel.EmployeeName = result.PEmployeeName;
                    internalTransferUpdateViewModel.TransferDate = result.PTransferDate;
                    internalTransferUpdateViewModel.FromCostcode = result.PFromCostcode;
                    internalTransferUpdateViewModel.ToCostcode = result.PToCostcode;
                }

                IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", internalTransferUpdateViewModel.ToCostcode);

                IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", internalTransferUpdateViewModel.Empno);

                return PartialView("_ModalInternalTransferUpdatePartial", internalTransferUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISTransfersUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InternalTransferEdit([FromForm] InternalTransferUpdateViewModel internalTransferUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _internalTransferRepository.InternalTransferEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = internalTransferUpdateViewModel.KeyId,
                            PEmpno = internalTransferUpdateViewModel.Empno,
                            PTransferDate = internalTransferUpdateViewModel.TransferDate,
                            PToCostcode = internalTransferUpdateViewModel.ToCostcode
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField", internalTransferUpdateViewModel.ToCostcode);

            return PartialView("_ModalInternalTransferUpdatePartial", internalTransferUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISTransfersUpdate)]
        public async Task<IActionResult> InternalTransferDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _internalTransferRepository.InternalTransferDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        //[HttpPost]
        //public async Task<IActionResult> InternalTransferExcelDownload(DateTime startDate, DateTime endDate)
        //{
        //    try
        //    {
        //        var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
        //        {
        //            PModuleName = CurrentUserIdentity.CurrentModule,
        //            PMetaId = CurrentUserIdentity.MetaId,
        //            PPersonId = CurrentUserIdentity.EmployeeId,
        //            PMvcActionName = ConstFilterInternalTransferIndex
        //        });
        //        FilterDataModel filterDataModel = new FilterDataModel();
        //        if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
        //            filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

        // string StrFimeName;

        // var timeStamp = DateTime.Now.ToFileTime(); StrFimeName = "Internal Transfer_" + timeStamp.ToString();

        // string strUser = User.Identity.Name;

        // IEnumerable<InternalTransferDataTableList> data = await
        // _internalTransfersDataTableListRepository.InternalTransferDataTableListForExcelAsync(
        // BaseSpTcmPLGet(), new ParameterSpTcmPL { });

        // if (data == null) { return NotFound(); }

        // var json = JsonConvert.SerializeObject(data);

        // IEnumerable<InternalTransferDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<InternalTransferDataTableExcel>>(json);

        // byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Internal
        // Transfer List", "Internal Transfer List");

        //        return File(byteContent,
        //                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        //                    StrFimeName + ".xlsx");
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
        //    }
        //}

        #endregion InternalTransfers

        #region ResignedEmployee

        public async Task<IActionResult> ResignedEmployeeIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterResignedEmployeeIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            ResignedEmployeeViewModel resignedEmployeeViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            ViewData["XLDownloadType"] = ConstXLDownloadTypeResignedEmployee;
            return View(resignedEmployeeViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISResignedReadAll)]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsResignedEmployee(string paramJson)
        {
            DTResult<ResignedEmployeeDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<ResignedEmployeeDataTableList> data = await _resignedEmployeeDataTableListRepository.ResignedEmployeeDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISResignedUpdate)]
        public async Task<IActionResult> ResignedEmployeeCreate()
        {
            ResignedEmployeeCreateViewModel resignedEmployeeCreateViewModel = new();

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> primaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["PrimaryReasonTypeList"] = new SelectList(primaryReasonTypeList, "DataValueField", "DataTextField", ConstPrimaryReasonNSecondaryReasonAsOther);

            IEnumerable<DataField> secondaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["SecondaryReasonTypeList"] = new SelectList(secondaryReasonTypeList, "DataValueField", "DataTextField", ConstPrimaryReasonNSecondaryReasonAsOther);

            IEnumerable<DataField> resignStatusList = await _selectTcmPLRepository.HRMISResignStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["ResignStatusList"] = new SelectList(resignStatusList, "DataValueField", "DataTextField", ConstResignStatusAsNo);

            IEnumerable<DataField> currResidentialLocation = await _selectTcmPLRepository.HRMISCurrResidentialLocation(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["CurrResidentialLocationList"] = new SelectList(currResidentialLocation, "DataValueField", "DataTextField");

            resignedEmployeeCreateViewModel.AdditionalFeedback = "-";
            resignedEmployeeCreateViewModel.EmpResignReason = "-";
            resignedEmployeeCreateViewModel.ExitInterviewComplete = "KO";
            resignedEmployeeCreateViewModel.IsEmailSent = "KO";

            return PartialView("_ModalResignedEmployeeCreatePartial", resignedEmployeeCreateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISResignedUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResignedEmployeeCreate([FromForm] ResignedEmployeeCreateViewModel resignedEmployeeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _resignedEmployeeRepository.ResignedEmployeeCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = resignedEmployeeCreateViewModel.Empno,
                            PEmpResignDate = resignedEmployeeCreateViewModel.EmpResignDate,
                            PHrReceiptDate = resignedEmployeeCreateViewModel.HrReceiptDate,
                            PDateOfRelieving = resignedEmployeeCreateViewModel.DateOfRelieving,
                            PEmpResignReason = resignedEmployeeCreateViewModel.EmpResignReason,
                            PPrimaryReason = resignedEmployeeCreateViewModel.PrimaryReason,
                            PSecondaryReason = resignedEmployeeCreateViewModel.SecondaryReason,
                            PAdditionalFeedback = resignedEmployeeCreateViewModel.AdditionalFeedback,
                            PInterviewComplete = resignedEmployeeCreateViewModel.ExitInterviewComplete,
                            PEmailSent = resignedEmployeeCreateViewModel.IsEmailSent,
                            PPercentIncrease = resignedEmployeeCreateViewModel.PercentIncrease,
                            PMovingToLocation = resignedEmployeeCreateViewModel.MovingToLocation,
                            PCurrentLocation = resignedEmployeeCreateViewModel.CurrentLocation,
                            PResignStatus = resignedEmployeeCreateViewModel.ResignStatusCode,
                            PCommitmentOnrollback = resignedEmployeeCreateViewModel.CommitmentOnRollback,
                            PLastDateInOffice = resignedEmployeeCreateViewModel.ActualLastDateInOffice
                        });

                    return result.PMessageType == NotOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.HRMISEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", resignedEmployeeCreateViewModel.Empno);

            IEnumerable<DataField> primaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["PrimaryReasonTypeList"] = new SelectList(primaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeCreateViewModel.PrimaryReason);

            IEnumerable<DataField> secondaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["SecondaryReasonTypeList"] = new SelectList(secondaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeCreateViewModel.SecondaryReason);

            IEnumerable<DataField> resignStatusList = await _selectTcmPLRepository.HRMISResignStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            IEnumerable<DataField> stateList = await _selectTcmPLRepository.StateListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["StateList"] = new SelectList(stateList, "DataValueField", "DataTextField", resignedEmployeeCreateViewModel.CurrentLocation);

            ViewData["ResignStatusList"] = new SelectList(resignStatusList, "DataValueField", "DataTextField", resignedEmployeeCreateViewModel.ResignStatusCode);

            return PartialView("_ModalResignedEmployeeCreatePartial", resignedEmployeeCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISResignedUpdate)]
        public async Task<IActionResult> ResignedEmployeeEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                ResignedEmployeeDetails result = await _resignedEmployeeDetailRepository.ResignedEmployeeDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                ResignedEmployeeUpdateViewModel resignedEmployeeUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    resignedEmployeeUpdateViewModel.KeyId = id;
                    resignedEmployeeUpdateViewModel.Empno = result.PEmpno;
                    resignedEmployeeUpdateViewModel.EmployeeName = result.PEmployeeName;
                    resignedEmployeeUpdateViewModel.EmpResignDate = result.PEmpResignDate;
                    resignedEmployeeUpdateViewModel.HrReceiptDate = result.PHrReceiptDate;
                    resignedEmployeeUpdateViewModel.DateOfRelieving = result.PDateOfRelieving;
                    resignedEmployeeUpdateViewModel.EmpResignReason = result.PEmpResignReason;
                    resignedEmployeeUpdateViewModel.PrimaryReason = result.PPrimaryReason;
                    resignedEmployeeUpdateViewModel.SecondaryReason = result.PSecondaryReason;
                    resignedEmployeeUpdateViewModel.AdditionalFeedback = result.PAdditionalFeedback;

                    resignedEmployeeUpdateViewModel.PercentIncrease = result.PPercentIncrease;
                    resignedEmployeeUpdateViewModel.MovingToLocation = result.PMovingToLocation;
                    resignedEmployeeUpdateViewModel.CurrentLocation = result.PCurrentLocation;
                    resignedEmployeeUpdateViewModel.ResignStatusCode = result.PResignStatusCode;
                    resignedEmployeeUpdateViewModel.CommitmentOnRollback = result.PCommitmentOnRollback;
                    resignedEmployeeUpdateViewModel.ActualLastDateInOffice = result.PActualLastDateInOffice;

                    resignedEmployeeUpdateViewModel.Doj = result.PDoj;
                    resignedEmployeeUpdateViewModel.Grade = result.PGrade;
                    resignedEmployeeUpdateViewModel.Designation = result.PDesignation;
                    resignedEmployeeUpdateViewModel.Department = result.PDepartment;

                    if (result.PExitInterviewComplete == "Yes")
                    {
                        resignedEmployeeUpdateViewModel.ExitInterviewComplete = "OK";
                    }
                    else
                    {
                        resignedEmployeeUpdateViewModel.ExitInterviewComplete = "KO";
                    }

                    if (result.PEmailSent == "Yes")
                    {
                        resignedEmployeeUpdateViewModel.IsEmailSent = "OK";
                    }
                    else
                    {
                        resignedEmployeeUpdateViewModel.IsEmailSent = "KO";
                    }
                }

                //IEnumerable<DataField> employeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                //{
                //});
                //ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

                IEnumerable<DataField> primaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["PrimaryReasonTypeList"] = new SelectList(primaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.PrimaryReason);

                IEnumerable<DataField> secondaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["SecondaryReasonTypeList"] = new SelectList(secondaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.SecondaryReason);

                IEnumerable<DataField> resignStatusList = await _selectTcmPLRepository.HRMISResignStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["ResignStatusList"] = new SelectList(resignStatusList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.ResignStatusCode);

                IEnumerable<DataField> yesNoList = _selectTcmPLRepository.GetListOkKoYesNo();

                ViewData["YesNoList"] = new SelectList(yesNoList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.ExitInterviewComplete);

                ViewData["YesNoIsEmailSentList"] = new SelectList(yesNoList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.IsEmailSent);

                IEnumerable<DataField> currResidentialLocation = await _selectTcmPLRepository.HRMISCurrResidentialLocation(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });
                ViewData["CurrResidentialLocationList"] = new SelectList(currResidentialLocation, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.CurrentLocation);

                return PartialView("_ModalResignedEmployeeUpdatePartial", resignedEmployeeUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISResignedUpdate)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResignedEmployeeEdit([FromForm] ResignedEmployeeUpdateViewModel resignedEmployeeUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _resignedEmployeeRepository.ResignedEmployeeEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = resignedEmployeeUpdateViewModel.KeyId,
                            PEmpno = resignedEmployeeUpdateViewModel.Empno,
                            PEmpResignDate = resignedEmployeeUpdateViewModel.EmpResignDate,
                            PHrReceiptDate = resignedEmployeeUpdateViewModel.HrReceiptDate,
                            PDateOfRelieving = resignedEmployeeUpdateViewModel.DateOfRelieving,
                            PEmpResignReason = resignedEmployeeUpdateViewModel.EmpResignReason,
                            PPrimaryReason = resignedEmployeeUpdateViewModel.PrimaryReason,
                            PSecondaryReason = resignedEmployeeUpdateViewModel.SecondaryReason,
                            PAdditionalFeedback = resignedEmployeeUpdateViewModel.AdditionalFeedback,
                            PInterviewComplete = resignedEmployeeUpdateViewModel.ExitInterviewComplete,
                            PEmailSent = resignedEmployeeUpdateViewModel.IsEmailSent,
                            PPercentIncrease = resignedEmployeeUpdateViewModel.PercentIncrease,
                            PMovingToLocation = resignedEmployeeUpdateViewModel.MovingToLocation,
                            PCurrentLocation = resignedEmployeeUpdateViewModel.CurrentLocation,
                            PResignStatus = resignedEmployeeUpdateViewModel.ResignStatusCode,
                            PCommitmentOnrollback = resignedEmployeeUpdateViewModel.CommitmentOnRollback,
                            PLastDateInOffice = resignedEmployeeUpdateViewModel.ActualLastDateInOffice
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IEnumerable<DataField> primaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["PrimaryReasonTypeList"] = new SelectList(primaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.PrimaryReason);

            IEnumerable<DataField> secondaryReasonTypeList = await _selectTcmPLRepository.HRMISResignReasonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["SecondaryReasonTypeList"] = new SelectList(secondaryReasonTypeList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.SecondaryReason);

            IEnumerable<DataField> resignStatusList = await _selectTcmPLRepository.HRMISResignStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["ResignStatusList"] = new SelectList(resignStatusList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.ResignStatusCode);

            IEnumerable<DataField> yesNoList = _selectTcmPLRepository.GetListOkKoYesNo();

            ViewData["YesNoList"] = new SelectList(yesNoList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.ExitInterviewComplete);

            ViewData["YesNoIsEmailSentList"] = new SelectList(yesNoList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.IsEmailSent);

            IEnumerable<DataField> stateList = await _selectTcmPLRepository.StateListAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            ViewData["StateList"] = new SelectList(stateList, "DataValueField", "DataTextField", resignedEmployeeUpdateViewModel.CurrentLocation);

            return PartialView("_ModalResignedEmployeeUpdatePartial", resignedEmployeeUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionHRMISResignedUpdate)]
        public async Task<IActionResult> ResignedEmployeeDelete(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _resignedEmployeeRepository.ResignedEmployeeDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ResignedEmployeeDetail(string id)
        {
            try
            {
                if (string.IsNullOrEmpty(id))
                {
                    return NotFound();
                }

                ResignedEmployeeDetails result = await _resignedEmployeeDetailRepository.ResignedEmployeeDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                ResignedEmployeeDetailViewModel resignedEmployeeDetailViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    resignedEmployeeDetailViewModel.KeyId = id;
                    resignedEmployeeDetailViewModel.Empno = result.PEmpno;
                    resignedEmployeeDetailViewModel.EmployeeName = result.PEmployeeName;
                    resignedEmployeeDetailViewModel.EmpResignDate = result.PEmpResignDate;
                    resignedEmployeeDetailViewModel.HrReceiptDate = result.PHrReceiptDate;
                    resignedEmployeeDetailViewModel.DateOfRelieving = result.PDateOfRelieving;
                    resignedEmployeeDetailViewModel.EmpResignReason = result.PEmpResignReason;
                    resignedEmployeeDetailViewModel.PrimaryReason = result.PPrimaryReason;
                    resignedEmployeeDetailViewModel.PrimaryReasonDesc = result.PPrimaryReasonDesc;
                    resignedEmployeeDetailViewModel.SecondaryReason = result.PSecondaryReason;
                    resignedEmployeeDetailViewModel.SecondaryReasonDesc = result.PSecondaryReasonDesc;

                    resignedEmployeeDetailViewModel.AdditionalFeedback = result.PAdditionalFeedback;
                    resignedEmployeeDetailViewModel.ExitInterviewComplete = result.PExitInterviewComplete;
                    resignedEmployeeDetailViewModel.PercentIncrease = result.PPercentIncrease;
                    resignedEmployeeDetailViewModel.MovingToLocation = result.PMovingToLocation;
                    resignedEmployeeDetailViewModel.CurrentLocation = result.PCurrentLocation;
                    resignedEmployeeDetailViewModel.CurrentLocationDesc = result.PCurrentLocDesc;
                    resignedEmployeeDetailViewModel.ResignStatusCode = result.PResignStatusCode;
                    resignedEmployeeDetailViewModel.ResignStatusDesc = result.PResignStatusDesc;
                    resignedEmployeeDetailViewModel.CommitmentOnRollback = result.PCommitmentOnRollback;
                    resignedEmployeeDetailViewModel.ActualLastDateInOffice = result.PActualLastDateInOffice;

                    resignedEmployeeDetailViewModel.Doj = result.PDoj;
                    resignedEmployeeDetailViewModel.Grade = result.PGrade;
                    resignedEmployeeDetailViewModel.Designation = result.PDesignation;
                    resignedEmployeeDetailViewModel.Department = result.PDepartment;
                }

                return PartialView("_ModalResignedEmployeeDetails", resignedEmployeeDetailViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> EmployeeInfo(string empno)
        {
            try
            {
                if (string.IsNullOrEmpty(empno))
                {
                    return NotFound();
                }
                HrMisEmployeeDetails result = await _employeeDetailRepository.EmployeeDetail(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL
                       {
                           PEmpno = empno
                       });

                ResignedEmployeeDetailViewModel resignedEmployeeDetailViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    resignedEmployeeDetailViewModel.Empno = empno;
                    resignedEmployeeDetailViewModel.Doj = result.PDoj;
                    resignedEmployeeDetailViewModel.Grade = result.PGrade;
                    resignedEmployeeDetailViewModel.Designation = result.PDesignation;
                    resignedEmployeeDetailViewModel.Department = result.PDepartment;
                }

                return Json(new
                {
                    Success = result.PMessageType == IsOk,
                    Response = result.PMessageText,
                    Doj = result.PDoj?.ToString("dd-MMM-yyyy"),
                    Grade = result.PGrade,
                    Designation = result.PDesignation,
                    Department = result.PDepartment,
                });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion ResignedEmployee

        #region Filter

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

                return Json(new { success = result.OutPSuccess == IsOk, response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            Domain.Models.FilterCreate retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
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
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        public async Task<IActionResult> ProspectiveEmployeesFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterProspectiveEmployeesIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> officeList = await _selectTcmPLRepository.HRMISOfficeLocationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["OfficeList"] = new SelectList(officeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalProspectiveEmployeesFilterSet", filterDataModel);
        }

        public async Task<IActionResult> InternalTransferFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterInternalTransferIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            IEnumerable<DataField> costCodeList = await _selectTcmPLRepository.HRMISDeptList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CostCodeList"] = new SelectList(costCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalInternalTransferFilterSet", filterDataModel);
        }

        public async Task<IActionResult> ResignedEmployeeFilterGet()
        {
            Domain.Models.FilterRetrieve retVal = await RetriveFilter(ConstFilterResignedEmployeeIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            IEnumerable<DataField> resignStatusCodeList = await _selectTcmPLRepository.HRMISResignStatusList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["ResignStatusCodeList"] = new SelectList(resignStatusCodeList, "DataValueField", "DataTextField");

            return PartialView("_ModalResignedEmployeeFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> ProspectiveEmployeesFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            StartDate = filterDataModel.StartDate,
                            EndDate = filterDataModel.EndDate,
                            OfficeCode = filterDataModel.OfficeLocationCode,
                            Costcode = filterDataModel.Costcode
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterProspectiveEmployeesIndex);

                return Json(new
                {
                    success = true,
                    startDate = filterDataModel.StartDate,
                    endDate = filterDataModel.EndDate,
                    officeCode = filterDataModel.OfficeLocationCode,
                    costcode = filterDataModel.Costcode
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        public async Task<IActionResult> InternalTransferFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.StartDate,
                            filterDataModel.EndDate,
                            filterDataModel.FromDept,
                            filterDataModel.ToDept
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterInternalTransferIndex);

                return Json(new
                {
                    success = true,
                    startDate = filterDataModel.StartDate,
                    endDate = filterDataModel.EndDate,
                    fromDept = filterDataModel.FromDept,
                    toDept = filterDataModel.ToDept
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        public async Task<IActionResult> ResignedEmployeeFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.StartDate,
                            filterDataModel.EndDate,
                            filterDataModel.ResignStatusCode
                        });

                Domain.Models.FilterCreate retVal = await CreateFilter(jsonFilter, ConstFilterResignedEmployeeIndex);

                return Json(new
                {
                    success = true,
                    startDate = filterDataModel.StartDate,
                    endDate = filterDataModel.EndDate,
                    resignStatusCode = filterDataModel.ResignStatusCode
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter

        #region XLDownload

        public IActionResult HRMISExcelDownload(string typeId)
        {
            if (typeId == null)
            {
                return NotFound();
            }

            FilterDataModel filterDataModel = new();

            ViewData["XLDownloadType"] = typeId;
            return PartialView("_ModalExportFilterSet", filterDataModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult HRMISExcelDownload(DateTime startDate, DateTime endDate, string typeId)
        {
            try
            {
                if (string.IsNullOrEmpty(typeId))
                {
                    throw new Exception("Invalid request..");
                }

                if (startDate > endDate)
                {
                    throw new Exception("End date should be greater than start date");
                }

                if (typeId == ConstXLDownloadTypeProspectiveEmployees)
                {
                    return RedirectToAction("ProspectiveEmplXL", new { startDate, endDate });
                }

                if (typeId == ConstXLDownloadTypeInternalTransfer)
                {
                    return RedirectToAction("InternalTransferExcel", new { startDate, endDate });
                }

                if (typeId == ConstXLDownloadTypeResignedEmployee)
                {
                    return RedirectToAction("ResignedEmployeeExcel", new { startDate, endDate });
                }
                if (typeId == ConstXLDownloadTypeJoinResignList)
                {
                    return RedirectToAction("JoinResignListExcel", new { startDate, endDate });
                }

                FilterDataModel filterDataModel = new()
                {
                    StartDate = startDate,
                    EndDate = endDate
                };

                ViewBag["TypeId"] = typeId;

                return PartialView("_ModalExportFilterSet", filterDataModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ProspectiveEmplXL(DateTime startDate, DateTime endDate)
        {
            try
            {
                long timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Prospective Employees Details_" + timeStamp.ToString();
                string reportTitle = "Prospective Employees Details " + startDate.ToString("dd-MMM-yyyy") + " To " + endDate.ToString("dd-MMM-yyyy");
                string sheetName = "Prospective Employees Details";

                string strUser = User.Identity.Name;

                IEnumerable<ProspectiveEmployeesXLDataTableList> data = await _prospectiveEmployeesXLDataTableListRepository.ProspectiveEmployeesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                    });

                if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> InternalTransferExcel(DateTime startDate, DateTime endDate)
        {
            try
            {
                long timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Internal Transfer Details_" + timeStamp.ToString();
                string reportTitle = "Internal Transfer Details " + startDate.ToString("dd-MMM-yyyy") + " To " + endDate.ToString("dd-MMM-yyyy");
                string sheetName = "Internal Transfer Details";

                IEnumerable<InternalTransferDataTableExcel> data = await _internalTransfersXLDataTableListRepository.InternalTransferDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                    });

                if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

                string json = JsonConvert.SerializeObject(data);

                IEnumerable<InternalTransferDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<InternalTransferDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> ResignedEmployeeExcel(DateTime startDate, DateTime endDate)
        {
            try
            {
                long timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Resigned Employee Details_" + timeStamp.ToString();
                string reportTitle = "Resigned Employee Details " + startDate.ToString("dd-MMM-yyyy") + " To " + endDate.ToString("dd-MMM-yyyy");
                string sheetName = "Resigned Employee Details";

                IEnumerable<ResignedEmployeeXLDataTableList> data = await _resignedEmployeeXLDataTableListRepository.ResignedEmployeeXLDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                    });

                if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

                //var json = JsonConvert.SerializeObject(data);

                //IEnumerable<ResignedEmployeeDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<ResignedEmployeeDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> JoinResignListExcel(DateTime startDate, DateTime endDate)
        {
            try
            {
                long timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Joining + Resign Details_" + timeStamp.ToString();
                string reportTitle = "Joining + Resign Details " + startDate.ToString("dd-MMM-yyyy") + " To " + endDate.ToString("dd-MMM-yyyy");
                string sheetName = "Joining + Resign Details";

                IEnumerable<ResignedEmployeeXLDataTableList> data = await _resignedEmployeeXLDataTableListRepository.ResignedEmployeeXLDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                    });

                if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion XLDownload
    }
}