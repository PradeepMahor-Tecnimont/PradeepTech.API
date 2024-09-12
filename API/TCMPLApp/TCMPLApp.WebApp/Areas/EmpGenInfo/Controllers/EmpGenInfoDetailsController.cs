using ClosedXML.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.EmpGenInfo.Controllers
{
    [Authorize]
    [Area("EmpGenInfo")]
    public class EmpGenInfoDetailsController : BaseController
    {
        private const string ConstFilterLockStatusIndex = "EmpGenInfoLockStatusDetails";
        private const string ConstFilterLoAAddendumAppointmentIndex = "LoAAddendumAppointmentIndex";
        private const string ConstFilterEmpRelativesAsColleaguesIndex = "EmpRelativesAsColleaguesIndex";
        private const string ConstFileTypePassport = "PP";
        private const string ConstFileTypeAadhaarCard = "AC";
        private const string ConstFileTypeGTLI = "GT";
        private const string ConstFileTypeNO = "NO";
        private const string ConstRelationSelf = "5";
        private decimal? _Ok = 1;

        private readonly IEmployeeDetailsRepository _employeeDetailsRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;

        private readonly IGratuityDetailsDataTableListRepository _gratuityDetailsDataTableListRepository;
        private readonly ISuperannuationDetailsDataTableListRepository _superannuationDetailsDataTableListRepository;
        private readonly IEmpProFundDetailsDataTableListRepository _empProFundDetailsDataTableListRepository;
        private readonly IEmpPensionFundMarriedDetailsDataTableListRepository _empPensionFundMarriedDetailsDataTableListRepository;
        private readonly IEmpPensionFundDetailsDataTableListRepository _empPensionFundDetailsDataTableListRepository;
        private readonly IEmpGenInfoMediclaimDetailsDataTableListRepository _empGenInfoMediclaimDetailsDataTableListRepository;
        private readonly IGTLIDetailsDataTableListRepository _gTLIDetailsDataTableListRepository;

        private readonly IGratuityNominationRepository _gratuityNominationRepository;
        private readonly ISupperannuationNominationRepository _supperannuationNominationRepository;
        private readonly IEmpProFundNominationRepository _empProFundNominationRepository;
        private readonly IMediclaimNominationRepository _mediclaimNominationRepository;
        private readonly IMediclaimNominationDetailRepository _mediclaimNominationDetailRepository;

        private readonly IGratuityNominationDetailRepository _gratuityNominationDetailRepository;
        private readonly ISupperannuationNominationDetailRepository _supperannuationNominationDetailRepository;
        private readonly IEmpPensionFundMarriedMemRepository _empPensionFundMarriedMemRepository;
        private readonly IEmpPensionFundMarriedMemDetailRepository _empPensionFundMarriedMemDetailRepository;
        private readonly IEmpPensionFundMemberRepository _empPensionFundMemberRepository;
        private readonly IEmpPensionFundDetailRepository _empPensionFundDetailRepository;
        private readonly IEmpProvidentFundDetailRepository _empProvidentFundDetailRepository;
        private readonly IEmpGtliNominationRepository _empGTLINominationRepository;
        private readonly IGTLINominationDetailRepository _gTLINominationDetailRepository;
        private readonly IEmployeeSecondaryDetailsRepository _employeeSecondaryDetailsRepository;
        private readonly IEmployeePrimaryDetailsRepository _employeePrimaryDetailsRepository;
        private readonly ILockStatusDetailsDataTableListRepository _lockStatusDetailsDataTableListRepository;
        private readonly IEmpDetailsLockStatusRepository _empDetailsLockStatusRepository;
        private readonly IAadharDetailsRepository _aadharDetailsRepository;
        private readonly IPassportDetailsRepository _passportDetailsRepository;
        private readonly IBulkActionsRepository _bulkActionsRepository;

        private readonly IEmpPrimaryDetailsRepository _empPrimaryDetailsRepository;
        private readonly IEmpSecondaryDetailsRepository _empSecondaryDetailsRepository;
        private readonly IEmpAadhaarDetailsRepository _empAadhaarDetailsRepository;
        private readonly IEmpPassportDetailsRepository _empPassportDetailsRepository;
        private readonly IEmpGenInfoGetDescripancyDetailsRepository _empGenInfoGetDescripancyDetailsRepository;
        private readonly IEmpGenInfoGetLockStatusDetailsRepository _empGenInfoGetLockStatusDetailsRepository;
        private readonly IScanFileRepository _scanFileRepository;
        private readonly IEmpScanFileDetailsRepository _empScanFileDetailsRepository;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly ILoAAddendumConsentDetailsRepository _loAAddendumConsentDetailsAsync;
        private readonly ILoAAddendumConsentUpdateRepository _loAAddendumConsentUpdateRepository;
        private readonly IEmploymentOfficeRelativesRepository _employmentOfficeRelativesRepository;
        private readonly IHttpClientWebApi _httpClientWebApi;
        private readonly IEmployeeRelativesDataTableListRepository _employeeRelativesDataTableListRepository;
        private readonly IEmployeeRelativeRepository _employeeRelativeRepository;
        private readonly ILoAAddendumAppointmentDataTableListRepository _loAAddendumAppointmentDataTableListRepository;
        private readonly IEmpRelativesAsColleaguesDataTableListRepository _empRelativesAsColleaguesDataTableListRepository;
        private readonly IEmpRelativesDeclStatusDetailsRepository _empRelativesDeclStatusDetailsRepository;
        private readonly IEmployeeRelativesDataTableListExcelViewRepository _employeeRelativesDataTableListExcelViewRepository;
        private readonly IEmpRelativesAsColleaguesDataTableListExcelViewRepository _empRelativesAsColleaguesDataTableListExcelViewRepository;

        public EmpGenInfoDetailsController(
            IEmployeeDetailsRepository employeeDetailsRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IFilterRepository filterRepository,

            IGratuityDetailsDataTableListRepository gratuityDetailsDataTableListRepository,
            ISuperannuationDetailsDataTableListRepository superannuationDetailsDataTableListRepository,
            IEmpProFundDetailsDataTableListRepository empProFundDetailsDataTableListRepository,
            IGratuityNominationRepository gratuityNominationRepository,
            IGTLIDetailsDataTableListRepository gTLIDetailsDataTableListRepository,
            ISupperannuationNominationRepository supperannuationNominationRepository,
            IEmpProFundNominationRepository empProFundNominationRepository,
            IEmpPrimaryDetailsRepository empPrimaryDetailsRepository,
            IEmpSecondaryDetailsRepository empSecondaryDetailsRepository,
            IEmpPensionFundMarriedDetailsDataTableListRepository empPensionFundMarriedDetailsDataTableListRepository,
            IEmpPensionFundDetailsDataTableListRepository empPensionFundDetailsDataTableListRepository,
            IEmpGenInfoGetDescripancyDetailsRepository empGenInfoGetDescripancyDetailsRepository,
            IEmpGenInfoGetLockStatusDetailsRepository empGenInfoGetLockStatusDetailsRepository,
            IEmpGenInfoMediclaimDetailsDataTableListRepository empGenInfoMediclaimDetailsDataTableListRepository,
            IGratuityNominationDetailRepository gratuityNominationDetailRepository,
            ISupperannuationNominationDetailRepository supperannuationNominationDetailRepository,
            IEmpPensionFundMarriedMemRepository empPensionFundMarriedMemRepository,
            IEmpPensionFundMarriedMemDetailRepository empPensionFundMarriedMemDetailRepository,
            IEmpPensionFundMemberRepository empPensionFundMemberRepository,
            IEmpPensionFundDetailRepository empPensionFundDetailRepository,
            IEmpProvidentFundDetailRepository empProvidentFundDetailRepository,
            IMediclaimNominationRepository mediclaimNominationRepository,
            IMediclaimNominationDetailRepository mediclaimNominationDetailRepository,
            IEmpAadhaarDetailsRepository empAadhaarDetailsRepository,
            IEmpPassportDetailsRepository empPassportDetailsRepository,
            IEmpGtliNominationRepository empGTLINominationRepository,
            IGTLINominationDetailRepository gTLINominationDetailRepository,
            IEmployeeSecondaryDetailsRepository employeeSecondaryDetailsRepository,
            IEmployeePrimaryDetailsRepository employeePrimaryDetailsRepository,
            ILockStatusDetailsDataTableListRepository lockStatusDetailsDataTableListRepository,
            IEmpDetailsLockStatusRepository empDetailsLockStatusRepository,
            IAadharDetailsRepository aadharDetailsRepository,
            IPassportDetailsRepository passportDetailsRepository,
            IBulkActionsRepository bulkActionsRepository,
            IScanFileRepository scanFileRepository,
            IEmpScanFileDetailsRepository empScanFileDetailsRepository,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            ILoAAddendumConsentDetailsRepository loAAddendumConsentDetailsAsync,
            ILoAAddendumConsentUpdateRepository loAAddendumConsentUpdateRepository,
            IEmploymentOfficeRelativesRepository employmentOfficeRelativesRepository,
            IHttpClientWebApi httpClientWebApi,
            IEmployeeRelativesDataTableListRepository employeeRelativesDataTableListRepository,
            IEmployeeRelativeRepository employeeRelativeRepository,
            ILoAAddendumAppointmentDataTableListRepository loAAddendumAppointmentDataTableListRepository,
            IEmpRelativesAsColleaguesDataTableListRepository empRelativesAsColleaguesDataTableListRepository,
            IEmpRelativesDeclStatusDetailsRepository empRelativesDeclStatusDetailsRepository,
            IEmployeeRelativesDataTableListExcelViewRepository employeeRelativesDataTableListExcelViewRepository,
            IEmpRelativesAsColleaguesDataTableListExcelViewRepository empRelativesAsColleaguesDataTableListExcelViewRepository)
        {
            _filterRepository = filterRepository;
            _employeeDetailsRepository = employeeDetailsRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _gratuityDetailsDataTableListRepository = gratuityDetailsDataTableListRepository;
            _superannuationDetailsDataTableListRepository = superannuationDetailsDataTableListRepository;
            _empProFundDetailsDataTableListRepository = empProFundDetailsDataTableListRepository;
            _gratuityNominationRepository = gratuityNominationRepository;
            _gTLIDetailsDataTableListRepository = gTLIDetailsDataTableListRepository;
            _supperannuationNominationRepository = supperannuationNominationRepository;
            _empProFundNominationRepository = empProFundNominationRepository;
            _empPensionFundMarriedDetailsDataTableListRepository = empPensionFundMarriedDetailsDataTableListRepository;
            _empPensionFundDetailsDataTableListRepository = empPensionFundDetailsDataTableListRepository;
            _empPrimaryDetailsRepository = empPrimaryDetailsRepository;
            _empSecondaryDetailsRepository = empSecondaryDetailsRepository;
            _empGenInfoGetDescripancyDetailsRepository = empGenInfoGetDescripancyDetailsRepository;
            _empGenInfoGetLockStatusDetailsRepository = empGenInfoGetLockStatusDetailsRepository;
            _empGenInfoMediclaimDetailsDataTableListRepository = empGenInfoMediclaimDetailsDataTableListRepository;
            _empPensionFundMarriedMemDetailRepository = empPensionFundMarriedMemDetailRepository;
            _gratuityNominationDetailRepository = gratuityNominationDetailRepository;
            _supperannuationNominationDetailRepository = supperannuationNominationDetailRepository;
            _empPensionFundMarriedMemRepository = empPensionFundMarriedMemRepository;
            _empPensionFundMemberRepository = empPensionFundMemberRepository;
            _empPensionFundDetailRepository = empPensionFundDetailRepository;
            _empProvidentFundDetailRepository = empProvidentFundDetailRepository;
            _mediclaimNominationRepository = mediclaimNominationRepository;
            _mediclaimNominationDetailRepository = mediclaimNominationDetailRepository;
            _empAadhaarDetailsRepository = empAadhaarDetailsRepository;
            _empPassportDetailsRepository = empPassportDetailsRepository;
            _empGTLINominationRepository = empGTLINominationRepository;
            _gTLINominationDetailRepository = gTLINominationDetailRepository;
            _employeeSecondaryDetailsRepository = employeeSecondaryDetailsRepository;
            _employeePrimaryDetailsRepository = employeePrimaryDetailsRepository;
            _lockStatusDetailsDataTableListRepository = lockStatusDetailsDataTableListRepository;
            _empDetailsLockStatusRepository = empDetailsLockStatusRepository;
            _aadharDetailsRepository = aadharDetailsRepository;
            _passportDetailsRepository = passportDetailsRepository;
            _bulkActionsRepository = bulkActionsRepository;

            _scanFileRepository = scanFileRepository;
            _empScanFileDetailsRepository = empScanFileDetailsRepository;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _loAAddendumConsentDetailsAsync = loAAddendumConsentDetailsAsync;
            _loAAddendumConsentUpdateRepository = loAAddendumConsentUpdateRepository;
            _employmentOfficeRelativesRepository = employmentOfficeRelativesRepository;
            _httpClientWebApi = httpClientWebApi;
            _employeeRelativesDataTableListRepository = employeeRelativesDataTableListRepository;
            _employeeRelativeRepository = employeeRelativeRepository;
            _loAAddendumAppointmentDataTableListRepository = loAAddendumAppointmentDataTableListRepository;
            _empRelativesAsColleaguesDataTableListRepository = empRelativesAsColleaguesDataTableListRepository;
            _empRelativesDeclStatusDetailsRepository = empRelativesDeclStatusDetailsRepository;
            _employeeRelativesDataTableListExcelViewRepository = employeeRelativesDataTableListExcelViewRepository;
            _empRelativesAsColleaguesDataTableListExcelViewRepository = empRelativesAsColleaguesDataTableListExcelViewRepository;
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpGenInformationIndex()
        {
            EmpGenInfoPrimaryDetailsViewModel empGenInformationViewModel = new();
            PrimaryDetailViewModel primaryDetails = new();

            empGenInformationViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            //empGenInformationViewModel.DescripancyDetailViewModel = await GetDescripancyDetailAsync();
            try
            {
                EmpPrimaryDetailOut result = await _empPrimaryDetailsRepository.EmpPrimaryDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL());

                if (result.PMessageType == IsOk)
                {
                    primaryDetails.Assign = result.PAssign;
                    primaryDetails.AssignName = result.PAssignName;
                    primaryDetails.CostName = result.PCostName;
                    primaryDetails.DesgCode = result.PDesgCode;
                    primaryDetails.DesgName = result.PDesgName;
                    primaryDetails.Doj = result.PDoj;
                    primaryDetails.Dob = result.PDob;
                    primaryDetails.Name = result.PEmpName;
                    primaryDetails.EmpType = result.PEmptype;
                    primaryDetails.Grade = result.PGrade;
                    primaryDetails.Gender = result.PGender;
                    primaryDetails.HoD = result.PHod;
                    primaryDetails.HoDName = result.PHodName;
                    primaryDetails.Parent = result.PParent;
                    primaryDetails.Secretary = result.PSecretary;
                    primaryDetails.SecName = result.PSecretaryName;
                }
                primaryDetails.Empno = CurrentUserIdentity.EmpNo;
                empGenInformationViewModel.PrimaryDetails = primaryDetails;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return RedirectToAction("Index", "Home");
            }

            return View("EmpGenInformationIndex", empGenInformationViewModel);
        }

        #region PrimaryDetails

        protected async Task<EmpPrimaryDetailOut> cmnGetPrimaryDetails(string empno = null)
        {
            EmployeePrimaryDetailsEditViewModel primaryDetails = new EmployeePrimaryDetailsEditViewModel();
            EmpPrimaryDetailOut empPrimaryDetailOut = new EmpPrimaryDetailOut();

            if (String.IsNullOrEmpty(empno))
            {
                empPrimaryDetailOut = await _empPrimaryDetailsRepository.EmpPrimaryDetailsAsync(
                                                            BaseSpTcmPLGet(),
                                                            new ParameterSpTcmPL()
                                                            );
            }
            else
            {
                empPrimaryDetailOut = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL { PEmpno = empno }
                                            );
            }

            return empPrimaryDetailOut;
        }

        protected async Task<EmployeePrimaryDetailsEditViewModel> cmnGetPrimaryDetailsViewModel(string empno = null)
        {
            EmployeePrimaryDetailsEditViewModel primaryDetails = new EmployeePrimaryDetailsEditViewModel();
            EmpPrimaryDetailOut empPrimaryDetailOut = new EmpPrimaryDetailOut();

            if (String.IsNullOrEmpty(empno))
            {
                empPrimaryDetailOut = await _empPrimaryDetailsRepository.EmpPrimaryDetailsAsync(
                                                            BaseSpTcmPLGet(),
                                                            new ParameterSpTcmPL()
                                                            );
            }
            else
            {
                empPrimaryDetailOut = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                                            BaseSpTcmPLGet(),
                                            new ParameterSpTcmPL { PEmpno = empno }
                                            );
            }
            if (empPrimaryDetailOut.PMessageType == IsOk)
            {
                #region Employee Primary Details Edit Model

                primaryDetails.FirstName = empPrimaryDetailOut.PFirstName;
                primaryDetails.Surname = empPrimaryDetailOut.PSurname;
                primaryDetails.FatherName = empPrimaryDetailOut.PFatherName;

                #region Permanent Address

                primaryDetails.PAdd1 = empPrimaryDetailOut.PPAdd;
                primaryDetails.PHouseNo = empPrimaryDetailOut.PPHouseNo;
                primaryDetails.PCity = empPrimaryDetailOut.PPCity;
                primaryDetails.PDistrict = empPrimaryDetailOut.PPDistrict;
                primaryDetails.PPincode = empPrimaryDetailOut.PPPincode;
                primaryDetails.PState = empPrimaryDetailOut.PPState;
                primaryDetails.PCountry = empPrimaryDetailOut.PPCountry;

                #endregion Permanent Address

                #region Additional Information

                primaryDetails.PlaceOfBirth = empPrimaryDetailOut.PPlaceOfBirth;
                primaryDetails.CountryOfBirth = empPrimaryDetailOut.PCountryOfBirth;
                primaryDetails.Nationality = empPrimaryDetailOut.PNationality;
                primaryDetails.PPhone = empPrimaryDetailOut.PPPhone;
                primaryDetails.PMobile = empPrimaryDetailOut.PPMobile;
                primaryDetails.NoDadHusbInName = (empPrimaryDetailOut.PNoDadHusbInName == "1" ? true : false);
                primaryDetails.PersonalEmail = empPrimaryDetailOut.PPersonalEmail;
                primaryDetails.NoOfChild = empPrimaryDetailOut.PNoOfChild;

                #endregion Additional Information

                #endregion Employee Primary Details Edit Model
            }

            return primaryDetails;
        }

        protected async Task<SelectList> cmnGetCountryList(object country)
        {
            IEnumerable<DataField> countries = await _selectTcmPLRepository.CountryList(BaseSpTcmPLGet(), null);

            return new SelectList(countries, "DataValueField", "DataTextField", country);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmployeePrimaryDetailIndex()
        {
            var lockDetails = await GetLockStatusDetailAsync();

            var empPrimaryDetails = await cmnGetPrimaryDetailsViewModel();

            ViewData["CountriesList"] = await cmnGetCountryList(empPrimaryDetails.CountryOfBirth);

            var viewName = lockDetails.IsPrimaryOpen == IsOk ? "_EmpPrimaryDetailsEditPartial" : "_EmpPrimaryDetailsPartial";

            return PartialView(viewName, empPrimaryDetails);
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmployeePrimaryDetailsEdit([FromForm] EmployeePrimaryDetailsEditViewModel employeePrimaryDetailsEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();

                    if (lockStatusDetail.IsPrimaryOpen != IsOk)
                    {
                        Notify("Error", StringHelper.CleanExceptionMessage("Primary Details Are Locked."), "", NotificationType.error);
                        return PartialView("_EmpPrimaryDetailsPartial", employeePrimaryDetailsEditViewModel);
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _employeePrimaryDetailsRepository.EmployeePrimaryDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PFirstName = employeePrimaryDetailsEditViewModel.FirstName,
                            PSurname = employeePrimaryDetailsEditViewModel.Surname,
                            PFatherName = employeePrimaryDetailsEditViewModel.FatherName,
                            PPAdd1 = employeePrimaryDetailsEditViewModel.PAdd1,
                            PPHouseNo = employeePrimaryDetailsEditViewModel.PHouseNo,
                            PPCity = employeePrimaryDetailsEditViewModel.PCity,
                            PPDistrict = employeePrimaryDetailsEditViewModel.PDistrict,
                            PPState = employeePrimaryDetailsEditViewModel.PState,
                            PPPincode = decimal.Parse(employeePrimaryDetailsEditViewModel.PPincode),
                            PPCountry = employeePrimaryDetailsEditViewModel.PCountry,
                            PPlaceOfBirth = employeePrimaryDetailsEditViewModel.PlaceOfBirth,
                            PCountryOfBirth = employeePrimaryDetailsEditViewModel.CountryOfBirth,
                            PNationality = employeePrimaryDetailsEditViewModel.Nationality,
                            PPPhone = employeePrimaryDetailsEditViewModel.PPhone,
                            PNoOfChild = decimal.Parse(employeePrimaryDetailsEditViewModel.NoOfChild),
                            PPersonalEmail = employeePrimaryDetailsEditViewModel.PersonalEmail,
                            PPMobile = employeePrimaryDetailsEditViewModel.PMobile,
                            PNoDadHusbInName = (employeePrimaryDetailsEditViewModel.NoDadHusbInName == true ? 1 : 0)
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", StringHelper.CleanExceptionMessage(result.PMessageText), "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IEnumerable<DataField> countries = await _selectTcmPLRepository.CountryList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField", employeePrimaryDetailsEditViewModel.CountryOfBirth);

            return PartialView("_EmpPrimaryDetailsEditPartial", employeePrimaryDetailsEditViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> OnBehalfEmployeePrimaryDetailsEdit([FromForm] EmployeePrimaryDetailsEditViewModel employeePrimaryDetailsEditViewModel)
        {
            try
            {
                if (employeePrimaryDetailsEditViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(employeePrimaryDetailsEditViewModel.Empno);

                    if (lockStatusDetail.IsPrimaryOpen != IsOk)
                    {
                        Notify("Error", StringHelper.CleanExceptionMessage("Primary Details Are Locked."), "", NotificationType.error);
                        return PartialView("_EmpPrimaryDetailsPartial", employeePrimaryDetailsEditViewModel);
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _employeePrimaryDetailsRepository.HREmployeePrimaryDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = employeePrimaryDetailsEditViewModel.Empno,
                            PFirstName = employeePrimaryDetailsEditViewModel.FirstName,
                            PSurname = employeePrimaryDetailsEditViewModel.Surname,
                            PFatherName = employeePrimaryDetailsEditViewModel.FatherName,
                            PPAdd1 = employeePrimaryDetailsEditViewModel.PAdd1,
                            PPHouseNo = employeePrimaryDetailsEditViewModel.PHouseNo,
                            PPCity = employeePrimaryDetailsEditViewModel.PCity,
                            PPDistrict = employeePrimaryDetailsEditViewModel.PDistrict,
                            PPState = employeePrimaryDetailsEditViewModel.PState,
                            PPPincode = decimal.Parse(employeePrimaryDetailsEditViewModel.PPincode),
                            PPCountry = employeePrimaryDetailsEditViewModel.PCountry,
                            PPlaceOfBirth = employeePrimaryDetailsEditViewModel.PlaceOfBirth,
                            PCountryOfBirth = employeePrimaryDetailsEditViewModel.CountryOfBirth,
                            PNationality = employeePrimaryDetailsEditViewModel.Nationality,
                            PPPhone = employeePrimaryDetailsEditViewModel.PPhone,
                            PNoOfChild = decimal.Parse(employeePrimaryDetailsEditViewModel.NoOfChild),
                            PPersonalEmail = employeePrimaryDetailsEditViewModel.PersonalEmail,
                            PPMobile = employeePrimaryDetailsEditViewModel.PMobile,
                            PNoDadHusbInName = (employeePrimaryDetailsEditViewModel.NoDadHusbInName == true ? 1 : 0)
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", StringHelper.CleanExceptionMessage(result.PMessageText), "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IEnumerable<DataField> countries = await _selectTcmPLRepository.CountryList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CountriesList"] = new SelectList(countries, "DataValueField", "DataTextField", employeePrimaryDetailsEditViewModel.CountryOfBirth);

            return PartialView("_EmpPrimaryDetailsEditPartial", employeePrimaryDetailsEditViewModel);
        }

        #endregion PrimaryDetails

        #region SecondaryDetails

        protected async Task<EmployeeSecondaryDetailsViewModel> cmnGetSecondaryDetails(string empno = null)
        {
            EmployeeSecondaryDetailsViewModel employeeSecondaryDetailsViewModel = new();

            EmpSecondaryDetailOut secondaryDetailOut = new();
            if (empno == null)
            {
                secondaryDetailOut = await _empSecondaryDetailsRepository.EmpSecondaryDetailsAsync(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL()
                                                );
            }
            else
            {
                secondaryDetailOut = await _empSecondaryDetailsRepository.HREmpSecondaryDetailsAsync(
                                                BaseSpTcmPLGet(),
                                                new ParameterSpTcmPL { PEmpno = empno }
                                                );
            }
            if (secondaryDetailOut.PMessageType == IsOk)
            {
                employeeSecondaryDetailsViewModel.BloodGroup = secondaryDetailOut.PBloodGroup;
                employeeSecondaryDetailsViewModel.Religion = secondaryDetailOut.PReligion;
                employeeSecondaryDetailsViewModel.MaritalStatus = secondaryDetailOut.PMaritalStatus;

                #region Residential Address (Current Mumbai Address)

                employeeSecondaryDetailsViewModel.RAdd1 = secondaryDetailOut.PRAdd;
                employeeSecondaryDetailsViewModel.RHouseNo = secondaryDetailOut.PRHouseNo;
                employeeSecondaryDetailsViewModel.RCity = secondaryDetailOut.PRCity;
                employeeSecondaryDetailsViewModel.RDistrict = secondaryDetailOut.PRDistrict;
                employeeSecondaryDetailsViewModel.RState = secondaryDetailOut.PRState;
                employeeSecondaryDetailsViewModel.RPincode = secondaryDetailOut.PRPincode;
                employeeSecondaryDetailsViewModel.RCountry = secondaryDetailOut.PRCountry;

                employeeSecondaryDetailsViewModel.PhoneRes = secondaryDetailOut.PPhoneRes;
                employeeSecondaryDetailsViewModel.MobileRes = secondaryDetailOut.PMobileRes;

                #endregion Residential Address (Current Mumbai Address)

                #region Name / Address of Relative / Friend (To be contacted in case of EMERGENCY)

                employeeSecondaryDetailsViewModel.RefPersonName = secondaryDetailOut.PRefPersonName;
                employeeSecondaryDetailsViewModel.FAdd1 = secondaryDetailOut.PFAdd;
                employeeSecondaryDetailsViewModel.FHouseNo = secondaryDetailOut.PFHouseNo;
                employeeSecondaryDetailsViewModel.FCity = secondaryDetailOut.PFCity;
                employeeSecondaryDetailsViewModel.FDistrict = secondaryDetailOut.PFDistrict;
                employeeSecondaryDetailsViewModel.FState = secondaryDetailOut.PFState;
                employeeSecondaryDetailsViewModel.FPincode = secondaryDetailOut.PFPincode;
                employeeSecondaryDetailsViewModel.FCountry = secondaryDetailOut.PFCountry;

                employeeSecondaryDetailsViewModel.RefPersonPhone = secondaryDetailOut.PRefPersonPhone;

                #endregion Name / Address of Relative / Friend (To be contacted in case of EMERGENCY)

                #region Additional Information

                employeeSecondaryDetailsViewModel.CoBus = secondaryDetailOut.PCoBusVal;
                employeeSecondaryDetailsViewModel.CoBusText = secondaryDetailOut.PCoBusText;
                employeeSecondaryDetailsViewModel.PickUpPoint = secondaryDetailOut.PPickUpPoint;
                employeeSecondaryDetailsViewModel.MobileOff = secondaryDetailOut.PMobileOff;
                employeeSecondaryDetailsViewModel.Fax = secondaryDetailOut.PFax;
                employeeSecondaryDetailsViewModel.Voip = secondaryDetailOut.PVoip;

                #endregion Additional Information
            }
            return employeeSecondaryDetailsViewModel;
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmployeeSecondaryDetails()
        {
            EmployeeSecondaryDetailsViewModel employeeSecondaryDetailsViewModel = await cmnGetSecondaryDetails();
            var lockDetails = await GetLockStatusDetailAsync();

            string viewName = "";

            if (lockDetails.IsSecondaryOpen == IsOk)
            {
                IEnumerable<DataField> bloodGroupList = await _selectTcmPLRepository.BloodGroupListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["BloodGroupList"] = new SelectList(bloodGroupList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.BloodGroup);

                IEnumerable<DataField> companyBusList = await _selectTcmPLRepository.BusListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["CompanyBusList"] = new SelectList(companyBusList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.CoBus);

                viewName = "_EmpSecondaryDetailsEditPartial";
            }
            else
            {
                viewName = "_EmpSecondaryDetailsPartial";
            }

            return PartialView(viewName, employeeSecondaryDetailsViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmployeeSecondaryDetailsEdit([FromForm] EmployeeSecondaryDetailsViewModel employeeSecondaryDetailsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();

                    if (lockStatusDetail.IsSecondaryOpen != IsOk)
                    {
                        Notify("Error", StringHelper.CleanExceptionMessage("Secondary Details Are Locked."), "", NotificationType.error);
                        return PartialView("_EmpSecondaryDetailsPartial", employeeSecondaryDetailsViewModel);
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _employeeSecondaryDetailsRepository.EmployeeSecondaryDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PBloodGroup = employeeSecondaryDetailsViewModel.BloodGroup,
                            PReligion = employeeSecondaryDetailsViewModel.Religion,
                            PMaritalStatus = employeeSecondaryDetailsViewModel.MaritalStatus,
                            PRAdd1 = employeeSecondaryDetailsViewModel.RAdd1,
                            PRHouseNo = employeeSecondaryDetailsViewModel.RHouseNo,
                            PRCity = employeeSecondaryDetailsViewModel.RCity,
                            PRDistrict = employeeSecondaryDetailsViewModel.RDistrict,
                            PRState = employeeSecondaryDetailsViewModel.RState,
                            PRCountry = employeeSecondaryDetailsViewModel.RCountry,
                            PRPincode = decimal.Parse(employeeSecondaryDetailsViewModel.RPincode),
                            PPhoneRes = employeeSecondaryDetailsViewModel.PhoneRes,
                            PMobileRes = employeeSecondaryDetailsViewModel.MobileRes,
                            PRefPersonName = employeeSecondaryDetailsViewModel.RefPersonName,
                            PRefPersonPhone = employeeSecondaryDetailsViewModel.RefPersonPhone,
                            PFAdd1 = employeeSecondaryDetailsViewModel.FAdd1,
                            PFHouseNo = employeeSecondaryDetailsViewModel.FHouseNo,
                            PFCity = employeeSecondaryDetailsViewModel.FCity,
                            PFDistrict = employeeSecondaryDetailsViewModel.FDistrict,
                            PFState = employeeSecondaryDetailsViewModel.FState,
                            PFCountry = employeeSecondaryDetailsViewModel.FCountry,
                            PFPincode = decimal.Parse(employeeSecondaryDetailsViewModel.FPincode),
                            PCoBus = employeeSecondaryDetailsViewModel.CoBus,
                            PPickUpPoint = employeeSecondaryDetailsViewModel.PickUpPoint,
                            PMobileOff = employeeSecondaryDetailsViewModel.MobileOff,
                            PFax = employeeSecondaryDetailsViewModel.Fax,
                            PVoip = employeeSecondaryDetailsViewModel.Voip
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

            IEnumerable<DataField> bloodGroupList = await _selectTcmPLRepository.BloodGroupListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["BloodGroupList"] = new SelectList(bloodGroupList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.BloodGroup);

            IEnumerable<DataField> companyBusList = await _selectTcmPLRepository.BusListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CompanyBusList"] = new SelectList(companyBusList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.CoBus);

            return PartialView("_EmpSecondaryDetailsEditPartial", employeeSecondaryDetailsViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmployeeSecondaryDetails(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmployeeSecondaryDetailsViewModel employeeSecondaryDetailsViewModel = await cmnGetSecondaryDetails(id);
            employeeSecondaryDetailsViewModel.Empno = id;
            var lockDetails = await GetLockStatusDetailAsync(id);

            string viewName = "";

            if (lockDetails.IsSecondaryOpen == IsOk)
            {
                IEnumerable<DataField> bloodGroupList = await _selectTcmPLRepository.BloodGroupListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["BloodGroupList"] = new SelectList(bloodGroupList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.BloodGroup);

                IEnumerable<DataField> companyBusList = await _selectTcmPLRepository.BusListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["CompanyBusList"] = new SelectList(companyBusList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.CoBus);

                viewName = "_EmpSecondaryDetailsEditPartial";
            }
            else
            {
                viewName = "_EmpSecondaryDetailsPartial";
            }
            ViewData["isOnBehalf"] = IsOk;
            return PartialView(viewName, employeeSecondaryDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> OnBehalfEmployeeSecondaryDetailsEdit([FromForm] EmployeeSecondaryDetailsViewModel employeeSecondaryDetailsViewModel)
        {
            try
            {
                if (employeeSecondaryDetailsViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(employeeSecondaryDetailsViewModel.Empno);

                    if (lockStatusDetail.IsSecondaryOpen == NotOk)
                    {
                        Notify("Error", StringHelper.CleanExceptionMessage("Secondary Details Are Locked."), "", NotificationType.error);
                        return PartialView("_EmpSecondaryDetailsPartial", employeeSecondaryDetailsViewModel);
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _employeeSecondaryDetailsRepository.HREmployeeSecondaryDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = employeeSecondaryDetailsViewModel.Empno,
                            PBloodGroup = employeeSecondaryDetailsViewModel.BloodGroup,
                            PReligion = employeeSecondaryDetailsViewModel.Religion,
                            PMaritalStatus = employeeSecondaryDetailsViewModel.MaritalStatus,
                            PRAdd1 = employeeSecondaryDetailsViewModel.RAdd1,
                            PRHouseNo = employeeSecondaryDetailsViewModel.RHouseNo,
                            PRCity = employeeSecondaryDetailsViewModel.RCity,
                            PRDistrict = employeeSecondaryDetailsViewModel.RDistrict,
                            PRState = employeeSecondaryDetailsViewModel.RState,
                            PRCountry = employeeSecondaryDetailsViewModel.RCountry,
                            PRPincode = decimal.Parse(employeeSecondaryDetailsViewModel.RPincode),
                            PPhoneRes = employeeSecondaryDetailsViewModel.PhoneRes,
                            PMobileRes = employeeSecondaryDetailsViewModel.MobileRes,
                            PRefPersonName = employeeSecondaryDetailsViewModel.RefPersonName,
                            PRefPersonPhone = employeeSecondaryDetailsViewModel.RefPersonPhone,
                            PFAdd1 = employeeSecondaryDetailsViewModel.FAdd1,
                            PFHouseNo = employeeSecondaryDetailsViewModel.FHouseNo,
                            PFCity = employeeSecondaryDetailsViewModel.FCity,
                            PFDistrict = employeeSecondaryDetailsViewModel.FDistrict,
                            PFState = employeeSecondaryDetailsViewModel.FState,
                            PFCountry = employeeSecondaryDetailsViewModel.FCountry,
                            PFPincode = decimal.Parse(employeeSecondaryDetailsViewModel.FPincode),
                            PCoBus = employeeSecondaryDetailsViewModel.CoBus,
                            PPickUpPoint = employeeSecondaryDetailsViewModel.PickUpPoint,
                            PMobileOff = employeeSecondaryDetailsViewModel.MobileOff,
                            PFax = employeeSecondaryDetailsViewModel.Fax,
                            PVoip = employeeSecondaryDetailsViewModel.Voip
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

            IEnumerable<DataField> bloodGroupList = await _selectTcmPLRepository.BloodGroupListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["BloodGroupList"] = new SelectList(bloodGroupList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.BloodGroup);

            IEnumerable<DataField> companyBusList = await _selectTcmPLRepository.BusListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["CompanyBusList"] = new SelectList(companyBusList, "DataValueField", "DataTextField", employeeSecondaryDetailsViewModel.CoBus);
            ViewData["isOnBehalf"] = IsOk;

            return PartialView("_EmpSecondaryDetailsEditPartial", employeeSecondaryDetailsViewModel);
        }

        #endregion SecondaryDetails

        #region NominationDetails

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpGenInfoNominationDetailsIndex()
        {
            EmpGenInfoGratuityViewModel empGenInfoGratuityViewModel = new();

            empGenInfoGratuityViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            EmpPrimaryDetailOut result = await _empPrimaryDetailsRepository.EmpPrimaryDetailsAsync(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL());

            if (result.PMessageType == IsOk)
            {
                empGenInfoGratuityViewModel.FirstName = result.PFirstName;
                empGenInfoGratuityViewModel.Surname = result.PSurname;
                empGenInfoGratuityViewModel.FatherName = result.PFatherName;
                empGenInfoGratuityViewModel.Address = result.PPAdd;
                empGenInfoGratuityViewModel.Pincode = result.PPPincode;
                empGenInfoGratuityViewModel.NoDadHusbInName = (result.PNoDadHusbInName == "1" ? true : false);
            }

            return PartialView("_EmpNominationDetailsPartial", empGenInfoGratuityViewModel);
        }

        #region Gratuity Employee

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GratuityIndex()
        {
            EmpGenInfoGratuityViewModel empGenInfoGratuityViewModel = new();
            empGenInfoGratuityViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            return PartialView("_ModalEmpGenInfoGratuityDetailsEditPartial", empGenInfoGratuityViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<JsonResult> GetListsGratuity(string paramJson)
        {
            DTResult<GratuityDetailsDataTableList> result = new();

            //int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                result = await cmnGetGratuityList(param);

                //System.Collections.Generic.IEnumerable<GratuityDetailsDataTableList> data = await _gratuityDetailsDataTableListRepository.GratuityDetailsDataTableListAsync(
                //    BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PRowNumber = 0,
                //        PPageLength = 1000
                //    }
                //);

                //if (data.Any())
                //{
                //    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                //}

                //result.draw = param.Draw;
                //result.recordsTotal = totalRow;
                //result.recordsFiltered = totalRow;
                //result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GratuityNominationAdd()
        {
            try
            {
                GratuityNominationCreateViewModel gratuityNominationCreateViewModel = new();
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

                return PartialView("_ModalGratuityNominationCreatePartial", gratuityNominationCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GratuityNominationAdd([FromForm] GratuityNominationCreateViewModel gratuityNominationCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != "OK")
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _gratuityNominationRepository.GratuityNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PNomName = gratuityNominationCreateViewModel.NomName,
                            PNomAdd1 = gratuityNominationCreateViewModel.NomAdd1,
                            PRelation = gratuityNominationCreateViewModel.Relation,
                            PNomDob = gratuityNominationCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(gratuityNominationCreateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalGratuityNominationCreatePartial", gratuityNominationCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GratuityNominationEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                GratuityNominationDetails result = await _gratuityNominationDetailRepository.GratuityNominationDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                GratuityNominationUpdateViewModel gratuityNominationUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    gratuityNominationUpdateViewModel.KeyId = id;

                    gratuityNominationUpdateViewModel.Empno = result.PEmpno;
                    gratuityNominationUpdateViewModel.NomName = result.PNomName;
                    gratuityNominationUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    gratuityNominationUpdateViewModel.Relation = result.PRelation;
                    gratuityNominationUpdateViewModel.NomDob = result.PNomDob;
                    gratuityNominationUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", gratuityNominationUpdateViewModel.Relation);

                return PartialView("_ModalGratuityNominationEditPartial", gratuityNominationUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GratuityNominationEdit([FromForm] GratuityNominationUpdateViewModel gratuityNominationUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != "OK")
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _gratuityNominationRepository.GratuityNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = gratuityNominationUpdateViewModel.KeyId,
                            PNomName = gratuityNominationUpdateViewModel.NomName,
                            PNomAdd1 = gratuityNominationUpdateViewModel.NomAdd1,
                            PRelation = gratuityNominationUpdateViewModel.Relation,
                            PNomDob = gratuityNominationUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(gratuityNominationUpdateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", gratuityNominationUpdateViewModel.Relation);

            return PartialView("_ModalGratuityNominationEditPartial", gratuityNominationUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GratuityNominationDelete(string id)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync();
                if (lockStatusDetail.IsNominationOpen != "OK")
                {
                    throw new Exception("Nomination Details Are Locked.");
                }

                Domain.Models.Common.DBProcMessageOutput result = await _gratuityNominationRepository.GratuityNominationDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Gratuity Employee

        #region Gratuity Common

        protected async Task<DTResult<GratuityDetailsDataTableList>> cmnGetGratuityList(DTParameters param, string empno = null)
        {
            DTResult<GratuityDetailsDataTableList> result = new();
            IEnumerable<GratuityDetailsDataTableList> data = Enumerable.Empty<GratuityDetailsDataTableList>();
            if (empno != null)
            {
                data = await _gratuityDetailsDataTableListRepository.HRGratuityDetailsDataTableListAsync(
                                                                    BaseSpTcmPLGet(),
                                                                    new ParameterSpTcmPL
                                                                    {
                                                                        PEmpno = param.Empno,
                                                                        PRowNumber = 0,
                                                                        PPageLength = 1000
                                                                    }
                                                                );
            }
            else
            {
                data = await _gratuityDetailsDataTableListRepository.GratuityDetailsDataTableListAsync(
                                                                    BaseSpTcmPLGet(),
                                                                    new ParameterSpTcmPL
                                                                    {
                                                                        PRowNumber = 0,
                                                                        PPageLength = 1000
                                                                    }
                                                                );
            }
            int totalRow = 0;

            if (data.Any())
            {
                totalRow = (int)data.FirstOrDefault().TotalRow.Value;
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();
            return result;
        }

        #endregion Gratuity Common

        #region Gratuity OnBehalf

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGratuityIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpGenInfoGratuityViewModel empGenInfoGratuityViewModel = new();
            EmpPrimaryDetailOut result = new();

            empGenInfoGratuityViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);

            result = await cmnGetPrimaryDetails(id);

            if (result.PMessageType == "OK")
            {
                empGenInfoGratuityViewModel.FirstName = result.PFirstName;
                empGenInfoGratuityViewModel.Surname = result.PSurname;
                empGenInfoGratuityViewModel.FatherName = result.PFatherName;
                empGenInfoGratuityViewModel.Address = result.PPAdd;
                empGenInfoGratuityViewModel.Pincode = result.PPPincode;
                empGenInfoGratuityViewModel.NoDadHusbInName = (result.PNoDadHusbInName == "1" ? true : false);
            }
            empGenInfoGratuityViewModel.Empno = id;

            //empGenInfoGratuityViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalEmpGenInfoGratuityDetailsEditPartial", empGenInfoGratuityViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<JsonResult> OnBehalfGetListsGratuity(string paramJson)
        {
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            if (param.Empno == null)
            {
                return Json(new { error = "Employee not found." });
            }

            try
            {
                var result = await cmnGetGratuityList(param, param.Empno);
                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGratuityNominationAdd(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            GratuityNominationCreateViewModel gratuityNominationCreateViewModel = new();
            gratuityNominationCreateViewModel.Empno = id;
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalGratuityNominationCreatePartial", gratuityNominationCreateViewModel);
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGratuityNominationAdd([FromForm] GratuityNominationCreateViewModel gratuityNominationCreateViewModel)
        {
            try
            {
                if (gratuityNominationCreateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(gratuityNominationCreateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _gratuityNominationRepository.HRGratuityNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = gratuityNominationCreateViewModel.Empno,
                            PNomName = gratuityNominationCreateViewModel.NomName,
                            PNomAdd1 = gratuityNominationCreateViewModel.NomAdd1,
                            PRelation = gratuityNominationCreateViewModel.Relation,
                            PNomDob = gratuityNominationCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(gratuityNominationCreateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalGratuityNominationCreatePartial", gratuityNominationCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGratuityNominationEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            GratuityNominationDetails result = await _gratuityNominationDetailRepository.GratuityNominationDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            GratuityNominationUpdateViewModel gratuityNominationUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                gratuityNominationUpdateViewModel.KeyId = id;

                gratuityNominationUpdateViewModel.Empno = result.PEmpno;
                gratuityNominationUpdateViewModel.NomName = result.PNomName;
                gratuityNominationUpdateViewModel.NomAdd1 = result.PNomAdd1;
                gratuityNominationUpdateViewModel.Relation = result.PRelation;
                gratuityNominationUpdateViewModel.NomDob = result.PNomDob;
                gratuityNominationUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
            }
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", gratuityNominationUpdateViewModel.Relation);
            ViewData["isOnBehalf"] = IsOk;

            return PartialView("_ModalGratuityNominationEditPartial", gratuityNominationUpdateViewModel);
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGratuityNominationEdit([FromForm] GratuityNominationUpdateViewModel gratuityNominationUpdateViewModel)
        {
            try
            {
                if (gratuityNominationUpdateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(gratuityNominationUpdateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _gratuityNominationRepository.HRGratuityNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = gratuityNominationUpdateViewModel.KeyId,
                            PEmpno = gratuityNominationUpdateViewModel.Empno,
                            PNomName = gratuityNominationUpdateViewModel.NomName,
                            PNomAdd1 = gratuityNominationUpdateViewModel.NomAdd1,
                            PRelation = gratuityNominationUpdateViewModel.Relation,
                            PNomDob = gratuityNominationUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(gratuityNominationUpdateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", gratuityNominationUpdateViewModel.Relation);

            return PartialView("_ModalGratuityNominationEditPartial", gratuityNominationUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGratuityNominationDelete(string id, string empno)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync(empno);
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }

                Domain.Models.Common.DBProcMessageOutput result = await _gratuityNominationRepository.HRGratuityNominationDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id,
                        PEmpno = empno
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Gratuity OnBehalf

        #region Superannuation Employee

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> SuperannuationIndex()
        {
            EmpGenInfoSupperannuationViewModel empGenInfoSupperannuationViewModel = new();

            empGenInfoSupperannuationViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            return PartialView("_ModalSuperannuationDetailsEditPartial", empGenInfoSupperannuationViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<JsonResult> GetListsSuperannuation(string paramJson)
        {
            DTResult<SuperannuationDetailsDataTableList> result = new();

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                result = await cmnGetListsSuperannuation(param);

                //System.Collections.Generic.IEnumerable<SuperannuationDetailsDataTableList> data = await _superannuationDetailsDataTableListRepository.SuperannuationDetailsDataTableListAsync(
                //            BaseSpTcmPLGet(),
                //            new ParameterSpTcmPL
                //            {
                //                PRowNumber = 0,
                //                PPageLength = 1000
                //            });

                //if (data.Any())
                //{
                //    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                //}

                //result.draw = param.Draw;
                //result.recordsTotal = totalRow;
                //result.recordsFiltered = totalRow;
                //result.data = data.ToList();

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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> SupperannuationNominationAdd()
        {
            try
            {
                SupperannuationNominationCreateViewModel supperannuationNominationCreateViewModel = new();

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

                return PartialView("_ModalSupperannuationNominationCreatePartial", supperannuationNominationCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> SupperannuationNominationAdd([FromForm] SupperannuationNominationCreateViewModel supperannuationNominationCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _supperannuationNominationRepository.SupperannuationNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PNomName = supperannuationNominationCreateViewModel.NomName,
                            PNomAdd1 = supperannuationNominationCreateViewModel.NomAdd1,
                            PRelation = supperannuationNominationCreateViewModel.Relation,
                            PNomDob = supperannuationNominationCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(supperannuationNominationCreateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalSupperannuationNominationCreatePartial", supperannuationNominationCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> SupperannuationNominationEdit(string id)
        {
            try
            {
                SupperannuationNominationUpdateViewModel supperannuationNominationUpdateViewModel = new();

                if (id == null)
                {
                    return NotFound();
                }

                SupperannuationNominationDetails result = await _supperannuationNominationDetailRepository.SupperannuationNominationDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });
                if (result.PMessageType == IsOk)
                {
                    supperannuationNominationUpdateViewModel.KeyId = id;

                    supperannuationNominationUpdateViewModel.NomName = result.PNomName;
                    supperannuationNominationUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    supperannuationNominationUpdateViewModel.Relation = result.PRelation;
                    supperannuationNominationUpdateViewModel.NomDob = result.PNomDob;
                    supperannuationNominationUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", supperannuationNominationUpdateViewModel.Relation);

                return PartialView("_ModalSupperannuationNominationEditPartial", supperannuationNominationUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> SupperannuationNominationEdit([FromForm] SupperannuationNominationUpdateViewModel supperannuationNominationUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _supperannuationNominationRepository.SupperannuationNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = supperannuationNominationUpdateViewModel.KeyId,
                            PNomName = supperannuationNominationUpdateViewModel.NomName,
                            PNomAdd1 = supperannuationNominationUpdateViewModel.NomAdd1,
                            PRelation = supperannuationNominationUpdateViewModel.Relation,
                            PNomDob = supperannuationNominationUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(supperannuationNominationUpdateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", supperannuationNominationUpdateViewModel.Relation);

            return PartialView("_ModalSupperannuationNominationEditPartial", supperannuationNominationUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> SupperannuationNominationDelete(string id)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync();
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _supperannuationNominationRepository.SupperannuationNominationDeleteAsync(
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

        #endregion Superannuation Employee

        #region Supperannuation Common

        protected async Task<DTResult<SuperannuationDetailsDataTableList>> cmnGetListsSuperannuation(DTParameters param, string empno = null)
        {
            DTResult<SuperannuationDetailsDataTableList> result = new();
            IEnumerable<SuperannuationDetailsDataTableList> data = Enumerable.Empty<SuperannuationDetailsDataTableList>();
            if (empno != null)
            {
                data = await _superannuationDetailsDataTableListRepository.HRSuperannuationDetailsDataTableListAsync(
                                                                    BaseSpTcmPLGet(),
                                                                    new ParameterSpTcmPL
                                                                    {
                                                                        PEmpno = param.Empno,
                                                                        PRowNumber = 0,
                                                                        PPageLength = 1000
                                                                    }
                                                                );
            }
            else
            {
                data = await _superannuationDetailsDataTableListRepository.SuperannuationDetailsDataTableListAsync(
                                                                    BaseSpTcmPLGet(),
                                                                    new ParameterSpTcmPL
                                                                    {
                                                                        PRowNumber = 0,
                                                                        PPageLength = 1000
                                                                    }
                                                                );
            }
            int totalRow = 0;

            if (data.Any())
            {
                totalRow = (int)data.FirstOrDefault().TotalRow.Value;
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();
            return result;
        }

        #endregion Supperannuation Common

        #region Superannuation OnBehalf

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfSuperannuationIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpGenInfoSupperannuationViewModel empGenInfoSupperannuationViewModel = new();

            empGenInfoSupperannuationViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);
            empGenInfoSupperannuationViewModel.Empno = id;
            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalSuperannuationDetailsEditPartial", empGenInfoSupperannuationViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<JsonResult> OnBehalfGetListsSuperannuation(string paramJson)
        {
            DTResult<SuperannuationDetailsDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            if (param.Empno == null)
            {
                return Json(new
                {
                    error = "employee no not found"
                });
            }

            try
            {
                result = await cmnGetListsSuperannuation(param, param.Empno);

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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfSupperannuationNominationAdd(string id)
        {
            try
            {
                if (id == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                SupperannuationNominationCreateViewModel supperannuationNominationCreateViewModel = new();
                supperannuationNominationCreateViewModel.Empno = id;

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
                ViewData["isOnBehalf"] = IsOk;
                return PartialView("_ModalSupperannuationNominationCreatePartial", supperannuationNominationCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfSupperannuationNominationAdd([FromForm] SupperannuationNominationCreateViewModel supperannuationNominationCreateViewModel)
        {
            try
            {
                if (supperannuationNominationCreateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(supperannuationNominationCreateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _supperannuationNominationRepository.HRSupperannuationNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = supperannuationNominationCreateViewModel.Empno,
                            PNomName = supperannuationNominationCreateViewModel.NomName,
                            PNomAdd1 = supperannuationNominationCreateViewModel.NomAdd1,
                            PRelation = supperannuationNominationCreateViewModel.Relation,
                            PNomDob = supperannuationNominationCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(supperannuationNominationCreateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalSupperannuationNominationCreatePartial", supperannuationNominationCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfSupperannuationNominationEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                SupperannuationNominationDetails result = await _supperannuationNominationDetailRepository.SupperannuationNominationDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                SupperannuationNominationUpdateViewModel supperannuationNominationUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    supperannuationNominationUpdateViewModel.KeyId = id;
                    supperannuationNominationUpdateViewModel.Empno = result.PEmpno;
                    supperannuationNominationUpdateViewModel.NomName = result.PNomName;
                    supperannuationNominationUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    supperannuationNominationUpdateViewModel.Relation = result.PRelation;
                    supperannuationNominationUpdateViewModel.NomDob = result.PNomDob;
                    supperannuationNominationUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", supperannuationNominationUpdateViewModel.Relation);
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalSupperannuationNominationEditPartial", supperannuationNominationUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfSupperannuationNominationEdit([FromForm] SupperannuationNominationUpdateViewModel supperannuationNominationUpdateViewModel)
        {
            try
            {
                if (supperannuationNominationUpdateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(supperannuationNominationUpdateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _supperannuationNominationRepository.HRSupperannuationNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = supperannuationNominationUpdateViewModel.KeyId,
                            PEmpno = supperannuationNominationUpdateViewModel.Empno,
                            PNomName = supperannuationNominationUpdateViewModel.NomName,
                            PNomAdd1 = supperannuationNominationUpdateViewModel.NomAdd1,
                            PRelation = supperannuationNominationUpdateViewModel.Relation,
                            PNomDob = supperannuationNominationUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(supperannuationNominationUpdateViewModel.SharePcnt)
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", supperannuationNominationUpdateViewModel.Relation);

            return PartialView("_ModalSupperannuationNominationEditPartial", supperannuationNominationUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfSupperannuationNominationDelete(string id, string empno)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync(empno);
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _supperannuationNominationRepository.HRSupperannuationNominationDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id,
                        PEmpno = empno
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion Superannuation OnBehalf

        #region EmployeeProvidentFund

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpProFundIndex()
        {
            EmpGenInfoProFundNomineeViewModel empGenInfoProFundNomineeViewModel = new();

            empGenInfoProFundNomineeViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            return PartialView("_ModalEmpProFundDetailsEditPartial", empGenInfoProFundNomineeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<JsonResult> GetListsEmpProFundDetails(string paramJson)
        {
            DTResult<EmpProFundDetailsDataTableList> result = new();

            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                System.Collections.Generic.IEnumerable<EmpProFundDetailsDataTableList> data = await _empProFundDetailsDataTableListRepository.EmpProFundDetailsDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PRowNumber = 0,
                                PPageLength = 1000
                            });

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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpProFundNomineeAdd()
        {
            try
            {
                EmpProFundNomineeCreateViewModel empProFundNomineeCreateViewModel = new();

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
                return PartialView("_ModalEmpProFundNomineeCreatePartial", empProFundNomineeCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpProFundNomineeAdd([FromForm] EmpProFundNomineeCreateViewModel empProFundNomineeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empProFundNominationRepository.EmpProFundNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PNomName = empProFundNomineeCreateViewModel.NomName,
                            PNomAdd1 = empProFundNomineeCreateViewModel.NomAdd1,
                            PRelation = empProFundNomineeCreateViewModel.Relation,
                            PNomDob = empProFundNomineeCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empProFundNomineeCreateViewModel.SharePcnt),
                            PNomMinorGuardName = empProFundNomineeCreateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empProFundNomineeCreateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empProFundNomineeCreateViewModel.NomMinorGuardRelation
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
            return PartialView("_ModalEmpProFundNomineeCreatePartial", empProFundNomineeCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpProFundNomineeEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                EmpProvidentFundDetails result = await _empProvidentFundDetailRepository.EmpProvidentFundDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                EmpProFundNominationUpdateViewModel empProFundNominationUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empProFundNominationUpdateViewModel.KeyId = id;

                    empProFundNominationUpdateViewModel.NomName = result.PNomName;
                    empProFundNominationUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empProFundNominationUpdateViewModel.Relation = result.PRelation;
                    empProFundNominationUpdateViewModel.NomDob = result.PNomDob;
                    empProFundNominationUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
                    empProFundNominationUpdateViewModel.NomMinorGuardName = result.PNomMinorGuardName;
                    empProFundNominationUpdateViewModel.NomMinorGuardAdd1 = result.PNomMinorGuardAdd1;
                    empProFundNominationUpdateViewModel.NomMinorGuardRelation = result.PNomMinorGuardRelation;
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empProFundNominationUpdateViewModel.Relation);
                return PartialView("_ModalEmpProFundNomineeUpdatePartial", empProFundNominationUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpProFundNomineeEdit([FromForm] EmpProFundNominationUpdateViewModel empProFundNominationUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empProFundNominationRepository.EmpProFundNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empProFundNominationUpdateViewModel.KeyId,
                            PNomName = empProFundNominationUpdateViewModel.NomName,
                            PNomAdd1 = empProFundNominationUpdateViewModel.NomAdd1,
                            PRelation = empProFundNominationUpdateViewModel.Relation,
                            PNomDob = empProFundNominationUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empProFundNominationUpdateViewModel.SharePcnt),
                            PNomMinorGuardName = empProFundNominationUpdateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empProFundNominationUpdateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empProFundNominationUpdateViewModel.NomMinorGuardRelation
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empProFundNominationUpdateViewModel.Relation);
            return PartialView("_ModalEmpProFundNomineeUpdatePartial", empProFundNominationUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpProFundNomineeDelete(string id)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync();
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empProFundNominationRepository.EmpProFundNominationDeleteAsync(
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

        #endregion EmployeeProvidentFund

        #region Common Employee ProvidentFund

        protected async Task<DTResult<EmpProFundDetailsDataTableList>> cmnGetListsEmpProFundDetails(DTParameters param, string empno = null)
        {
            DTResult<EmpProFundDetailsDataTableList> result = new();
            IEnumerable<EmpProFundDetailsDataTableList> data = Enumerable.Empty<EmpProFundDetailsDataTableList>();
            int totalRow = 0;

            if (empno != null)
            {
                data = await _empProFundDetailsDataTableListRepository.HREmpProFundDetailsDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PEmpno = empno,
                                PRowNumber = 0,
                                PPageLength = 1000
                            });
            }
            else
            {
                data = await _empProFundDetailsDataTableListRepository.EmpProFundDetailsDataTableListAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PRowNumber = 0,
                                PPageLength = 1000
                            });
            }

            if (data.Any())
            {
                totalRow = (int)data.FirstOrDefault().TotalRow.Value;
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();

            return result;
        }

        #endregion Common Employee ProvidentFund

        #region OnBehalf Employee ProvidentFund

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpProFundIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }
            EmpGenInfoProFundNomineeViewModel empGenInfoProFundNomineeViewModel = new();

            empGenInfoProFundNomineeViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);
            empGenInfoProFundNomineeViewModel.Empno = id;

            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalEmpProFundDetailsEditPartial", empGenInfoProFundNomineeViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<JsonResult> OnBehalfGetListsEmpProFundDetails(string paramJson)
        {
            DTResult<EmpProFundDetailsDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            if (param.Empno == null)
            {
                return Json(new
                {
                    error = "employee no not found"
                });
            }

            try
            {
                result = await cmnGetListsEmpProFundDetails(param, param.Empno);

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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpProFundNomineeAdd(string id)
        {
            try
            {
                if (id == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                EmpProFundNomineeCreateViewModel empProFundNomineeCreateViewModel = new();
                empProFundNomineeCreateViewModel.Empno = id;

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                ViewData["isOnBehalf"] = IsOk;

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
                return PartialView("_ModalEmpProFundNomineeCreatePartial", empProFundNomineeCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpProFundNomineeAdd([FromForm] EmpProFundNomineeCreateViewModel empProFundNomineeCreateViewModel)
        {
            try
            {
                if (empProFundNomineeCreateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empProFundNomineeCreateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empProFundNominationRepository.HREmpProFundNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empProFundNomineeCreateViewModel.Empno,
                            PNomName = empProFundNomineeCreateViewModel.NomName,
                            PNomAdd1 = empProFundNomineeCreateViewModel.NomAdd1,
                            PRelation = empProFundNomineeCreateViewModel.Relation,
                            PNomDob = empProFundNomineeCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empProFundNomineeCreateViewModel.SharePcnt),
                            PNomMinorGuardName = empProFundNomineeCreateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empProFundNomineeCreateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empProFundNomineeCreateViewModel.NomMinorGuardRelation
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
            return PartialView("_ModalEmpProFundNomineeCreatePartial", empProFundNomineeCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpProFundNomineeEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                EmpProvidentFundDetails result = await _empProvidentFundDetailRepository.EmpProvidentFundDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

                EmpProFundNominationUpdateViewModel empProFundNominationUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empProFundNominationUpdateViewModel.KeyId = id;
                    empProFundNominationUpdateViewModel.Empno = result.PEmpno;
                    empProFundNominationUpdateViewModel.NomName = result.PNomName;
                    empProFundNominationUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empProFundNominationUpdateViewModel.Relation = result.PRelation;
                    empProFundNominationUpdateViewModel.NomDob = result.PNomDob;
                    empProFundNominationUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
                    empProFundNominationUpdateViewModel.NomMinorGuardName = result.PNomMinorGuardName;
                    empProFundNominationUpdateViewModel.NomMinorGuardAdd1 = result.PNomMinorGuardAdd1;
                    empProFundNominationUpdateViewModel.NomMinorGuardRelation = result.PNomMinorGuardRelation;
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empProFundNominationUpdateViewModel.Relation);
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalEmpProFundNomineeUpdatePartial", empProFundNominationUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpProFundNomineeEdit([FromForm] EmpProFundNominationUpdateViewModel empProFundNominationUpdateViewModel)
        {
            try
            {
                if (empProFundNominationUpdateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empProFundNominationUpdateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empProFundNominationRepository.HREmpProFundNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empProFundNominationUpdateViewModel.KeyId,
                            PEmpno = empProFundNominationUpdateViewModel.Empno,
                            PNomName = empProFundNominationUpdateViewModel.NomName,
                            PNomAdd1 = empProFundNominationUpdateViewModel.NomAdd1,
                            PRelation = empProFundNominationUpdateViewModel.Relation,
                            PNomDob = empProFundNominationUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empProFundNominationUpdateViewModel.SharePcnt),
                            PNomMinorGuardName = empProFundNominationUpdateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empProFundNominationUpdateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empProFundNominationUpdateViewModel.NomMinorGuardRelation
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empProFundNominationUpdateViewModel.Relation);
            return PartialView("_ModalEmpProFundNomineeUpdatePartial", empProFundNominationUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpProFundNomineeDelete(string id, string empno)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync(empno);
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empProFundNominationRepository.HREmpProFundNominationDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id,
                        PEmpno = empno
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OnBehalf Employee ProvidentFund

        #region EmployeePensionFund(Married)

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundMarriedIndex()
        {
            EmpPensionFundMarriedMemberViewModel empPensionFundMarriedMemberViewModel = new();

            empPensionFundMarriedMemberViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            return PartialView("_ModalEmpPensionFundMarriedDetailsEditPartial", empPensionFundMarriedMemberViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<JsonResult> GetListsEmpPensionFundMarried(string paramJson)
        {
            DTResult<EmpPensionFundDetailsMarriedDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                result = await cmnGetListsEmpPensionFundMarried(param);
                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundMarriedMemAdd()
        {
            try
            {
                EmpPensionFundForMarriedMemberCreateViewModel empPensionFundForMarriedMemberCreateViewModel = new();

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

                return PartialView("_ModalEmpPensionFundForMarriedMemberCreatePartial", empPensionFundForMarriedMemberCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundMarriedMemAdd([FromForm] EmpPensionFundForMarriedMemberCreateViewModel empPensionFundForMarriedMemberCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMarriedMemRepository.EmpPensionFundMarriedMemCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PNomName = empPensionFundForMarriedMemberCreateViewModel.NomName,
                            PNomAdd1 = empPensionFundForMarriedMemberCreateViewModel.NomAdd1,
                            PRelation = empPensionFundForMarriedMemberCreateViewModel.Relation,
                            PNomDob = empPensionFundForMarriedMemberCreateViewModel.NomDob,
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpPensionFundForMarriedMemberCreatePartial", empPensionFundForMarriedMemberCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundMarriedMemEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                EmpPensionFundMarriedMemberDetails result = await _empPensionFundMarriedMemDetailRepository.EmpPensionFundMarriedMemDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                EmpPensionFundForMarriedMemberUpdateViewModel empPensionFundForMarriedMemberUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empPensionFundForMarriedMemberUpdateViewModel.KeyId = id;

                    empPensionFundForMarriedMemberUpdateViewModel.NomName = result.PNomName;
                    empPensionFundForMarriedMemberUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empPensionFundForMarriedMemberUpdateViewModel.Relation = result.PRelation;
                    empPensionFundForMarriedMemberUpdateViewModel.NomDob = result.PNomDob;
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundForMarriedMemberUpdateViewModel.Relation);

                return PartialView("_ModalEmpPensionFundForMarriedMemberEditPartial", empPensionFundForMarriedMemberUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundMarriedMemEdit([FromForm] EmpPensionFundForMarriedMemberUpdateViewModel empPensionFundForMarriedMemberUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMarriedMemRepository.EmpPensionFundMarriedMemEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empPensionFundForMarriedMemberUpdateViewModel.KeyId,
                            PNomName = empPensionFundForMarriedMemberUpdateViewModel.NomName,
                            PNomAdd1 = empPensionFundForMarriedMemberUpdateViewModel.NomAdd1,
                            PRelation = empPensionFundForMarriedMemberUpdateViewModel.Relation,
                            PNomDob = empPensionFundForMarriedMemberUpdateViewModel.NomDob
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundForMarriedMemberUpdateViewModel.Relation);

            return PartialView("_ModalEmpPensionFundForMarriedMemberEditPartial", empPensionFundForMarriedMemberUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundMarriedMemDelete(string id)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync();
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMarriedMemRepository.EmpPensionFundMarriedMemDeleteAsync(
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

        #endregion EmployeePensionFund(Married)

        #region Common EmployeePensionFund(Married)

        protected async Task<DTResult<EmpPensionFundDetailsMarriedDataTableList>> cmnGetListsEmpPensionFundMarried(DTParameters param, string empno = null)
        {
            DTResult<EmpPensionFundDetailsMarriedDataTableList> result = new();
            IEnumerable<EmpPensionFundDetailsMarriedDataTableList> data = Enumerable.Empty<EmpPensionFundDetailsMarriedDataTableList>();

            int totalRow = 0;

            if (empno != null)
            {
                data = await _empPensionFundMarriedDetailsDataTableListRepository.HREmpPensionFundMarriedDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno,
                        PRowNumber = 0,
                        PPageLength = 1000
                    }
                );
            }
            else
            {
                data = await _empPensionFundMarriedDetailsDataTableListRepository.EmpPensionFundMarriedDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000
                    }
                );
            }
            if (data.Any())
            {
                totalRow = (int)data.FirstOrDefault().TotalRow.Value;
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();
            return result;
        }

        #endregion Common EmployeePensionFund(Married)

        #region OnBehalf EmployeePensionFund(Married)

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundMarriedIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpPensionFundMarriedMemberViewModel empPensionFundMarriedMemberViewModel = new();
            empPensionFundMarriedMemberViewModel.Empno = id;

            ViewData["isOnBehalf"] = IsOk;
            empPensionFundMarriedMemberViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);

            return PartialView("_ModalEmpPensionFundMarriedDetailsEditPartial", empPensionFundMarriedMemberViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<JsonResult> OnBehalfGetListsEmpPensionFundMarried(string paramJson)
        {
            DTResult<EmpPensionFundDetailsMarriedDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            if (param.Empno == null)
            {
                return Json(new
                {
                    error = "employee no not found"
                });
            }
            try
            {
                result = await cmnGetListsEmpPensionFundMarried(param, param.Empno);
                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundMarriedMemAdd(string id)
        {
            try
            {
                if (id == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                EmpPensionFundForMarriedMemberCreateViewModel empPensionFundForMarriedMemberCreateViewModel = new();
                empPensionFundForMarriedMemberCreateViewModel.Empno = id;

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalEmpPensionFundForMarriedMemberCreatePartial", empPensionFundForMarriedMemberCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundMarriedMemAdd([FromForm] EmpPensionFundForMarriedMemberCreateViewModel empPensionFundForMarriedMemberCreateViewModel)
        {
            try
            {
                if (empPensionFundForMarriedMemberCreateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empPensionFundForMarriedMemberCreateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMarriedMemRepository.HREmpPensionFundMarriedMemCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empPensionFundForMarriedMemberCreateViewModel.Empno,
                            PNomName = empPensionFundForMarriedMemberCreateViewModel.NomName,
                            PNomAdd1 = empPensionFundForMarriedMemberCreateViewModel.NomAdd1,
                            PRelation = empPensionFundForMarriedMemberCreateViewModel.Relation,
                            PNomDob = empPensionFundForMarriedMemberCreateViewModel.NomDob,
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpPensionFundForMarriedMemberCreatePartial", empPensionFundForMarriedMemberCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundMarriedMemEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                EmpPensionFundMarriedMemberDetails result = await _empPensionFundMarriedMemDetailRepository.EmpPensionFundMarriedMemDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                EmpPensionFundForMarriedMemberUpdateViewModel empPensionFundForMarriedMemberUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empPensionFundForMarriedMemberUpdateViewModel.KeyId = id;
                    empPensionFundForMarriedMemberUpdateViewModel.Empno = result.PEmpno;
                    empPensionFundForMarriedMemberUpdateViewModel.NomName = result.PNomName;
                    empPensionFundForMarriedMemberUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empPensionFundForMarriedMemberUpdateViewModel.Relation = result.PRelation;
                    empPensionFundForMarriedMemberUpdateViewModel.NomDob = result.PNomDob;
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundForMarriedMemberUpdateViewModel.Relation);
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalEmpPensionFundForMarriedMemberEditPartial", empPensionFundForMarriedMemberUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundMarriedMemEdit([FromForm] EmpPensionFundForMarriedMemberUpdateViewModel empPensionFundForMarriedMemberUpdateViewModel)
        {
            try
            {
                if (empPensionFundForMarriedMemberUpdateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empPensionFundForMarriedMemberUpdateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMarriedMemRepository.HREmpPensionFundMarriedMemEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empPensionFundForMarriedMemberUpdateViewModel.KeyId,
                            PEmpno = empPensionFundForMarriedMemberUpdateViewModel.Empno,
                            PNomName = empPensionFundForMarriedMemberUpdateViewModel.NomName,
                            PNomAdd1 = empPensionFundForMarriedMemberUpdateViewModel.NomAdd1,
                            PRelation = empPensionFundForMarriedMemberUpdateViewModel.Relation,
                            PNomDob = empPensionFundForMarriedMemberUpdateViewModel.NomDob
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundForMarriedMemberUpdateViewModel.Relation);

            return PartialView("_ModalEmpPensionFundForMarriedMemberEditPartial", empPensionFundForMarriedMemberUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundMarriedMemDelete(string id, string empno)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync(empno);
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMarriedMemRepository.HREmpPensionFundMarriedMemDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id,
                        PEmpno = empno
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OnBehalf EmployeePensionFund(Married)

        #region EmployeePensionFund

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundIndex()
        {
            EmpPensionFundViewModel empPensionFundViewModel = new();

            empPensionFundViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            //return PartialView("EmpPensionFundIndex", empPensionFundViewModel);
            return PartialView("_EmpPensionFundDetailsPartial", empPensionFundViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<JsonResult> GetListsEmpPensionFund(string paramJson)
        {
            DTResult<EmpPensionFundDetailsDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                result = await cmnGetListsEmpPensionFund(param);
                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundAdd()
        {
            try
            {
                EmpPensionFundCreateViewModel empPensionFundCreateViewModel = new();

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

                return PartialView("_ModalEmpPensionFundCreatePartial", empPensionFundCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundAdd([FromForm] EmpPensionFundCreateViewModel empPensionFundCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMemberRepository.EmpPensionFundMemberCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PNomName = empPensionFundCreateViewModel.NomName,
                            PNomAdd1 = empPensionFundCreateViewModel.NomAdd1,
                            PRelation = empPensionFundCreateViewModel.Relation,
                            PNomDob = empPensionFundCreateViewModel.NomDob
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
            return PartialView("_ModalEmpPensionFundCreatePartial", empPensionFundCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                EmpPensionFundDetails result = await _empPensionFundDetailRepository.EmpPensionFundDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                EmpPensionFundUpdateViewModel empPensionFundUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empPensionFundUpdateViewModel.KeyId = id;

                    empPensionFundUpdateViewModel.NomName = result.PNomName;
                    empPensionFundUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empPensionFundUpdateViewModel.Relation = result.PRelation;
                    empPensionFundUpdateViewModel.NomDob = result.PNomDob;
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundUpdateViewModel.Relation);

                return PartialView("_ModalEmpPensionFundUpdatePartial", empPensionFundUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundEdit([FromForm] EmpPensionFundUpdateViewModel empPensionFundUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMemberRepository.EmpPensionFundMemberEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empPensionFundUpdateViewModel.KeyId,
                            PNomName = empPensionFundUpdateViewModel.NomName,
                            PNomAdd1 = empPensionFundUpdateViewModel.NomAdd1,
                            PRelation = empPensionFundUpdateViewModel.Relation,
                            PNomDob = empPensionFundUpdateViewModel.NomDob
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundUpdateViewModel.Relation);

            return PartialView("_ModalEmpPensionFundUpdatePartial", empPensionFundUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPensionFundDelete(string id)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync();
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMemberRepository.EmpPensionFundMemberDeleteAsync(
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

        #endregion EmployeePensionFund

        #region Common EmployeePensionFund

        protected async Task<DTResult<EmpPensionFundDetailsDataTableList>> cmnGetListsEmpPensionFund(DTParameters param, string empno = null)
        {
            DTResult<EmpPensionFundDetailsDataTableList> result = new();
            IEnumerable<EmpPensionFundDetailsDataTableList> data = Enumerable.Empty<EmpPensionFundDetailsDataTableList>();

            int totalRow = 0;

            if (empno != null)
            {
                data = await _empPensionFundDetailsDataTableListRepository.HREmpPensionFundDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno,
                        PRowNumber = 0,
                        PPageLength = 1000
                    }
                );
            }
            else
            {
                data = await _empPensionFundDetailsDataTableListRepository.EmpPensionFundDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000
                    }
                );
            }
            if (data.Any())
            {
                totalRow = (int)data.FirstOrDefault().TotalRow.Value;
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();
            return result;
        }

        #endregion Common EmployeePensionFund

        #region OnBehalf EmployeePensionFund

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpPensionFundViewModel empPensionFundViewModel = new();
            empPensionFundViewModel.Empno = id;

            ViewData["isOnBehalf"] = IsOk;
            empPensionFundViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);

            //return PartialView("EmpPensionFundIndex", empPensionFundViewModel);
            return PartialView("_EmpPensionFundDetailsPartial", empPensionFundViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<JsonResult> OnBehalfGetListsEmpPensionFund(string paramJson)
        {
            DTResult<EmpPensionFundDetailsDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            if (param.Empno == null)
            {
                return Json(new
                {
                    error = "employee no not found"
                });
            }
            try
            {
                result = await cmnGetListsEmpPensionFund(param, param.Empno);
                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundAdd(string id)
        {
            try
            {
                if (id == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                EmpPensionFundCreateViewModel empPensionFundCreateViewModel = new();
                empPensionFundCreateViewModel.Empno = id;

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalEmpPensionFundCreatePartial", empPensionFundCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundAdd([FromForm] EmpPensionFundCreateViewModel empPensionFundCreateViewModel)
        {
            try
            {
                if (empPensionFundCreateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empPensionFundCreateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMemberRepository.HREmpPensionFundMemberCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empPensionFundCreateViewModel.Empno,
                            PNomName = empPensionFundCreateViewModel.NomName,
                            PNomAdd1 = empPensionFundCreateViewModel.NomAdd1,
                            PRelation = empPensionFundCreateViewModel.Relation,
                            PNomDob = empPensionFundCreateViewModel.NomDob
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpPensionFundCreatePartial", empPensionFundCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                EmpPensionFundDetails result = await _empPensionFundDetailRepository.EmpPensionFundDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                EmpPensionFundUpdateViewModel empPensionFundUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empPensionFundUpdateViewModel.KeyId = id;
                    empPensionFundUpdateViewModel.Empno = result.PEmpno;
                    empPensionFundUpdateViewModel.NomName = result.PNomName;
                    empPensionFundUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empPensionFundUpdateViewModel.Relation = result.PRelation;
                    empPensionFundUpdateViewModel.NomDob = result.PNomDob;
                }
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundUpdateViewModel.Relation);
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalEmpPensionFundUpdatePartial", empPensionFundUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundEdit([FromForm] EmpPensionFundUpdateViewModel empPensionFundUpdateViewModel)
        {
            try
            {
                if (empPensionFundUpdateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empPensionFundUpdateViewModel.Empno);
                    if (lockStatusDetail.IsNominationOpen != IsOk)
                    {
                        throw new Exception("Nomination Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMemberRepository.HREmpPensionFundMemberEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empPensionFundUpdateViewModel.KeyId,
                            PEmpno = empPensionFundUpdateViewModel.Empno,
                            PNomName = empPensionFundUpdateViewModel.NomName,
                            PNomAdd1 = empPensionFundUpdateViewModel.NomAdd1,
                            PRelation = empPensionFundUpdateViewModel.Relation,
                            PNomDob = empPensionFundUpdateViewModel.NomDob
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empPensionFundUpdateViewModel.Relation);

            return PartialView("_ModalEmpPensionFundUpdatePartial", empPensionFundUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPensionFundDelete(string id, string empno)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync(empno);
                if (lockStatusDetail.IsNominationOpen != IsOk)
                {
                    throw new Exception("Nomination Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empPensionFundMemberRepository.HREmpPensionFundMemberDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id,
                        PEmpno = empno
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OnBehalf EmployeePensionFund

        #endregion NominationDetails

        #region MediclaimDetails

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpGenInfoMediclaimDetailsIndex()
        {
            EmpGenInfoMediclaimDetailsViewModel empGenInfoMediclaimDetailsViewModel = new();

            empGenInfoMediclaimDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            empGenInfoMediclaimDetailsViewModel.DescripancyDetailViewModel = await GetDescripancyDetailAsync();

            return PartialView("_ModalEmpGenInfoMediclaimDetailsEditPartial", empGenInfoMediclaimDetailsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<JsonResult> GetListsMediclaimDetails(string paramJson)
        {
            DTResult<MediclaimDetailsDataTableList> result = new();

            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                System.Collections.Generic.IEnumerable<MediclaimDetailsDataTableList> data = await _empGenInfoMediclaimDetailsDataTableListRepository.MediclaimDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> MediclaimDetailsAdd()
        {
            try
            {
                var empObject = cmnGetPrimaryDetails();
                MediclaimNominationDetails result = await _mediclaimNominationDetailRepository.MediclaimSelfDetail(
                  BaseSpTcmPLGet(),
                  new ParameterSpTcmPL
                  {
                      PEmpNo = empObject.Result.PEmpNo
                  });

                MediclaimDetailsCreateViewModel mediclainDetailsCreateViewModel = new();
                mediclainDetailsCreateViewModel.Empno = empObject.Result.PEmpNo;

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                if (result.PMessageType == IsOk)
                {
                    mediclainDetailsCreateViewModel.Member = result.PMember;
                    mediclainDetailsCreateViewModel.Dob = result.PDob;
                    mediclainDetailsCreateViewModel.FamilyRelation = result.PRelationVal?.ToString();
                    mediclainDetailsCreateViewModel.Occupation = result.POccupationVal?.ToString();
                    mediclainDetailsCreateViewModel.PreExistingDiseases = result.PRemarks;
                }
                else
                {
                    relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
                }

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.FamilyRelation);

                ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.Occupation);

                return PartialView("_ModalMediclaimDetailsCreatePartial", mediclainDetailsCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> MediclaimDetailsAdd([FromForm] MediclaimDetailsCreateViewModel mediclainDetailsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsMediclaimOpen != IsOk)
                    {
                        throw new Exception("Mediclaim Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _mediclaimNominationRepository.MediclaimNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PMember = mediclainDetailsCreateViewModel.Member,
                            PDob = mediclainDetailsCreateViewModel.Dob,
                            PFamilyRelation = decimal.Parse(mediclainDetailsCreateViewModel.FamilyRelation),
                            POccupation = decimal.Parse(mediclainDetailsCreateViewModel.Occupation),
                            PRemarks = mediclainDetailsCreateViewModel.PreExistingDiseases
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

            MediclaimNominationDetails resultSelfDetail = await _mediclaimNominationDetailRepository.MediclaimSelfDetail(
              BaseSpTcmPLGet(),
              new ParameterSpTcmPL
              {
                  PEmpNo = mediclainDetailsCreateViewModel.Empno
              });

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            if (resultSelfDetail.PMessageType != IsOk)
            {
                relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
            }

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.FamilyRelation);

            ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.Occupation);

            return PartialView("_ModalMediclaimDetailsCreatePartial", mediclainDetailsCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> MediclaimDetailsEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                MediclaimNominationDetails resultDetails = await _mediclaimNominationDetailRepository.MediclaimNominationDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                MediclaimDetailsUpdateViewModel mediclaimDetailsUpdateViewModel = new();
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                if (resultDetails.PMessageType == IsOk)
                {
                    mediclaimDetailsUpdateViewModel.KeyId = id;
                    mediclaimDetailsUpdateViewModel.Empno = resultDetails.PEmpno;
                    mediclaimDetailsUpdateViewModel.Member = resultDetails.PMember;
                    mediclaimDetailsUpdateViewModel.Dob = resultDetails.PDob;
                    mediclaimDetailsUpdateViewModel.FamilyRelation = resultDetails.PRelationVal?.ToString();
                    mediclaimDetailsUpdateViewModel.Occupation = resultDetails.POccupationVal?.ToString();
                    mediclaimDetailsUpdateViewModel.PreExistingDiseases = resultDetails.PRemarks;
                }

                if (mediclaimDetailsUpdateViewModel.FamilyRelation != ConstRelationSelf)
                {
                    relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
                }

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.FamilyRelation);

                ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.Occupation);

                return PartialView("_ModalMediclaimDetailsEditPartial", mediclaimDetailsUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> MediclaimDetailsEdit([FromForm] MediclaimDetailsUpdateViewModel mediclaimDetailsUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsMediclaimOpen != IsOk)
                    {
                        throw new Exception("Mediclaim Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _mediclaimNominationRepository.MediclaimNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = mediclaimDetailsUpdateViewModel.KeyId,
                            PMember = mediclaimDetailsUpdateViewModel.Member,
                            PDob = mediclaimDetailsUpdateViewModel.Dob,
                            PFamilyRelation = decimal.Parse(mediclaimDetailsUpdateViewModel.FamilyRelation),
                            POccupation = decimal.Parse(mediclaimDetailsUpdateViewModel.Occupation),
                            PRemarks = mediclaimDetailsUpdateViewModel.PreExistingDiseases
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            if (mediclaimDetailsUpdateViewModel.FamilyRelation != ConstRelationSelf)
            {
                relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
            }

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.FamilyRelation);
            ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.Occupation);

            return PartialView("_ModalMediclaimDetailsEditPartial", mediclaimDetailsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> MediclaimDetailsDelete(string id)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync();
                if (lockStatusDetail.IsMediclaimOpen != IsOk)
                {
                    throw new Exception("Mediclaim Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _mediclaimNominationRepository.MediclaimNominationDeleteAsync(
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
        public async Task<IActionResult> UpdateSelfRecord()
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _mediclaimNominationRepository.MediclaimUpdateSelfRecordAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    }
                    );
                //Notify(result.PMessageType == IsOk ? "Success" : "Error", StringHelper.CleanExceptionMessage(result.PMessageText), "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion MediclaimDetails

        #region Common MediclaimDetails

        protected async Task<DTResult<MediclaimDetailsDataTableList>> cmnGetListsMediclaimDetails(DTParameters param, string empno = null)
        {
            DTResult<MediclaimDetailsDataTableList> result = new();
            IEnumerable<MediclaimDetailsDataTableList> data = Enumerable.Empty<MediclaimDetailsDataTableList>();

            int totalRow = 0;

            if (empno != null)
            {
                data = await _empGenInfoMediclaimDetailsDataTableListRepository.HRMediclaimDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno,
                        PRowNumber = 0,
                        PPageLength = 1000
                    }
                );
            }
            else
            {
                data = await _empGenInfoMediclaimDetailsDataTableListRepository.MediclaimDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000
                    }
                );
            }
            if (data.Any())
            {
                totalRow = (int)data.FirstOrDefault().TotalRow.Value;
            }

            result.draw = param.Draw;
            result.recordsTotal = totalRow;
            result.recordsFiltered = totalRow;
            result.data = data.ToList();
            return result;
        }

        #endregion Common MediclaimDetails

        #region OnBehalf MediclaimDetails

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpGenInfoMediclaimDetailsIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpGenInfoMediclaimDetailsViewModel empGenInfoMediclaimDetailsViewModel = new();
            empGenInfoMediclaimDetailsViewModel.Empno = id;

            ViewData["isOnBehalf"] = IsOk;
            empGenInfoMediclaimDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);
            empGenInfoMediclaimDetailsViewModel.DescripancyDetailViewModel = await GetDescripancyDetailAsync(id);

            return PartialView("_ModalEmpGenInfoMediclaimDetailsEditPartial", empGenInfoMediclaimDetailsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<JsonResult> OnBehalfGetListsMediclaimDetails(string paramJson)
        {
            DTResult<MediclaimDetailsDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            if (param.Empno == null)
            {
                return Json(new
                {
                    error = "employee no not found"
                });
            }
            try
            {
                result = await cmnGetListsMediclaimDetails(param, param.Empno);
                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfMediclaimDetailsAdd(string id)
        {
            try
            {
                if (id == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                MediclaimNominationDetails result = await _mediclaimNominationDetailRepository.MediclaimSelfDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpNo = id
                    });

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                MediclaimDetailsCreateViewModel mediclainDetailsCreateViewModel = new();
                mediclainDetailsCreateViewModel.Empno = id;

                if (result.PMessageType == IsOk)
                {
                    mediclainDetailsCreateViewModel.Member = result.PMember;
                    mediclainDetailsCreateViewModel.Dob = result.PDob;
                    mediclainDetailsCreateViewModel.FamilyRelation = result.PRelationVal?.ToString();
                    mediclainDetailsCreateViewModel.Occupation = result.POccupationVal?.ToString();
                    mediclainDetailsCreateViewModel.PreExistingDiseases = result.PRemarks;
                }
                else
                {
                    relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
                }

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.FamilyRelation);

                ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.Occupation);

                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalMediclaimDetailsCreatePartial", mediclainDetailsCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfMediclaimDetailsAdd([FromForm] MediclaimDetailsCreateViewModel mediclainDetailsCreateViewModel)
        {
            try
            {
                if (mediclainDetailsCreateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(mediclainDetailsCreateViewModel.Empno);
                    if (lockStatusDetail.IsMediclaimOpen != IsOk)
                    {
                        throw new Exception("Mediclaim Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _mediclaimNominationRepository.HRMediclaimNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = mediclainDetailsCreateViewModel.Empno,
                            PMember = mediclainDetailsCreateViewModel.Member,
                            PDob = mediclainDetailsCreateViewModel.Dob,
                            PFamilyRelation = decimal.Parse(mediclainDetailsCreateViewModel.FamilyRelation),
                            POccupation = decimal.Parse(mediclainDetailsCreateViewModel.Occupation),
                            PRemarks = mediclainDetailsCreateViewModel.PreExistingDiseases
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            if (mediclainDetailsCreateViewModel.FamilyRelation != ConstRelationSelf)
            {
                relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
            }

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.FamilyRelation);

            ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclainDetailsCreateViewModel.Occupation);

            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalMediclaimDetailsCreatePartial", mediclainDetailsCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfMediclaimDetailsEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }
                MediclaimNominationDetails resultDetails = await _mediclaimNominationDetailRepository.MediclaimNominationDetail(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PKeyId = id
                   });

                MediclaimDetailsUpdateViewModel mediclaimDetailsUpdateViewModel = new();
                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
                IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                if (resultDetails.PMessageType == IsOk)
                {
                    mediclaimDetailsUpdateViewModel.KeyId = id;
                    mediclaimDetailsUpdateViewModel.Empno = resultDetails.PEmpno;
                    mediclaimDetailsUpdateViewModel.Member = resultDetails.PMember;
                    mediclaimDetailsUpdateViewModel.Dob = resultDetails.PDob;
                    mediclaimDetailsUpdateViewModel.FamilyRelation = resultDetails.PRelationVal?.ToString();
                    mediclaimDetailsUpdateViewModel.Occupation = resultDetails.POccupationVal?.ToString();
                    mediclaimDetailsUpdateViewModel.PreExistingDiseases = resultDetails.PRemarks;
                }

                if (mediclaimDetailsUpdateViewModel.FamilyRelation != ConstRelationSelf)
                {
                    relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
                }

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.FamilyRelation);

                ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.Occupation);

                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalMediclaimDetailsEditPartial", mediclaimDetailsUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfMediclaimDetailsEdit([FromForm] MediclaimDetailsUpdateViewModel mediclaimDetailsUpdateViewModel)
        {
            try
            {
                if (mediclaimDetailsUpdateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(mediclaimDetailsUpdateViewModel.Empno);
                    if (lockStatusDetail.IsMediclaimOpen != IsOk)
                    {
                        throw new Exception("Mediclaim Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _mediclaimNominationRepository.HRMediclaimNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = mediclaimDetailsUpdateViewModel.KeyId,
                            PEmpno = mediclaimDetailsUpdateViewModel.Empno,
                            PMember = mediclaimDetailsUpdateViewModel.Member,
                            PDob = mediclaimDetailsUpdateViewModel.Dob,
                            PFamilyRelation = decimal.Parse(mediclaimDetailsUpdateViewModel.FamilyRelation),
                            POccupation = decimal.Parse(mediclaimDetailsUpdateViewModel.Occupation),
                            PRemarks = mediclaimDetailsUpdateViewModel.PreExistingDiseases
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

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListCode(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            IEnumerable<DataField> occupationList = await _selectTcmPLRepository.OccupationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            if (mediclaimDetailsUpdateViewModel.FamilyRelation != ConstRelationSelf)
            {
                relationList = relationList.Where(c => c.DataValueField.ToString() != ConstRelationSelf);
            }

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.FamilyRelation);

            ViewData["OccupationList"] = new SelectList(occupationList, "DataValueField", "DataTextField", mediclaimDetailsUpdateViewModel.Occupation);

            ViewData["isOnBehalf"] = IsOk;

            return PartialView("_ModalMediclaimDetailsEditPartial", mediclaimDetailsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfMediclaimDetailsDelete(string id, string empno)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync(empno);
                if (lockStatusDetail.IsMediclaimOpen != IsOk)
                {
                    throw new Exception("Mediclaim Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _mediclaimNominationRepository.HRMediclaimNominationDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id,
                        PEmpno = empno
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OnBehalf MediclaimDetails

        #region Passport

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPassportDetails()
        {
            PassportDetailsViewModel passportDetailsViewModel = new();

            passportDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            try
            {
                EmployeePassportDetailOut result1 = await _empPassportDetailsRepository.EmpPassportDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { });

                var scanFileDetail = await _empScanFileDetailsRepository.EmpScanFileDetailsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PFileType = ConstFileTypePassport
                    });

                passportDetailsViewModel.HasScanFilePassport = scanFileDetail.PFileName;

                if (result1.PMessageType == IsOk)
                {
                    passportDetailsViewModel.HasPassport = result1.PHasPassport;
                    passportDetailsViewModel.Surname = result1.PSurname;
                    passportDetailsViewModel.PassportNo = result1.PPassportNo;
                    passportDetailsViewModel.GivenName = result1.PGivenName;
                    passportDetailsViewModel.IssueDate = result1.PIssueDate;
                    passportDetailsViewModel.ExpiryDate = result1.PExpiryDate;
                    passportDetailsViewModel.IssuedAt = result1.PIssuedAt;

                    ViewData["HasPassport"] = String.IsNullOrEmpty(result1.PHasPassport) ? "Passport info not updated" : result1.PHasPassport == IsOk ? "Yes" : "No";
                    ViewData["PassportUploadedMsg"] = String.IsNullOrEmpty(result1.PFileName) ? "" : "Passport copy uploaded.";
                }
                else
                    throw new Exception(result1.PMessageText);
                return PartialView("_ModalEmpPassportDetailsPartial", passportDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPassportDetailsEdit()
        {
            PassportDetailsViewModel passportDetailsViewModel = new();

            passportDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            try
            {
                EmployeePassportDetailOut result1 = await _empPassportDetailsRepository.EmpPassportDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { });

                if (result1.PMessageType == IsOk)
                {
                    passportDetailsViewModel.HasPassport = result1.PHasPassport;
                    passportDetailsViewModel.Surname = result1.PSurname;
                    passportDetailsViewModel.PassportNo = result1.PPassportNo;
                    passportDetailsViewModel.GivenName = result1.PGivenName;
                    passportDetailsViewModel.IssueDate = result1.PIssueDate;
                    passportDetailsViewModel.ExpiryDate = result1.PExpiryDate;
                    passportDetailsViewModel.IssuedAt = result1.PIssuedAt;

                    IList<DataField> dataFields = new List<DataField>();
                    dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
                    dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });

                    ViewData["HasPassport"] = new SelectList(dataFields, "DataValueField", "DataTextField", result1.PHasPassport);
                }
                else
                    throw new Exception(result1.PMessageText);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return PartialView("_ModalEmpPassportDetailsEditPartial", passportDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpPassportDetailsEdit([FromForm] PassportDetailsViewModel passportDetailsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsPassportOpen != IsOk)
                    {
                        throw new Exception("Passport Details Are Locked.");
                    }

                    if (passportDetailsViewModel.HasPassport == NotOk)
                    {
                        EmployeeScanFileDetailOut scanFileDetails = await _empScanFileDetailsRepository.EmpScanFileDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PFileType = ConstFileTypePassport,
                        });

                        if (scanFileDetails.PMessageType == IsOk)
                        {
                            if (!string.IsNullOrEmpty(scanFileDetails.PFileName))
                            {
                                StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, scanFileDetails.PFileName, Configuration);
                            }
                        }
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _passportDetailsRepository.PassportDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PHasPassport = passportDetailsViewModel.HasPassport,
                            PSurname = passportDetailsViewModel.HasPassport == IsOk ? passportDetailsViewModel.Surname : "",
                            PPassportNo = passportDetailsViewModel.HasPassport == IsOk ? passportDetailsViewModel.PassportNo : "",
                            PGivenName = passportDetailsViewModel.HasPassport == IsOk ? passportDetailsViewModel.GivenName : "",
                            PIssuedAt = passportDetailsViewModel.HasPassport == IsOk ? passportDetailsViewModel.IssuedAt : null,
                            PIssueDate = passportDetailsViewModel.HasPassport == IsOk ? passportDetailsViewModel.IssueDate : null,
                            PExpiryDate = passportDetailsViewModel.HasPassport == IsOk ? passportDetailsViewModel.ExpiryDate : null
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", StringHelper.CleanExceptionMessage(result.PMessageText), "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            passportDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            IList<DataField> dataFields = new List<DataField>();
            dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
            dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });

            ViewData["HasPassport"] = new SelectList(dataFields, "DataValueField", "DataTextField", passportDetailsViewModel.HasPassport);

            return PartialView("_ModalEmpPassportDetailsEditPartial", passportDetailsViewModel);
        }

        #endregion Passport

        #region OnBehalf Passport

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpPassportDetails(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            PassportDetailsViewModel passportDetailsViewModel = new();
            passportDetailsViewModel.Empno = id;
            passportDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);

            try
            {
                EmployeePassportDetailOut result1 = await _empPassportDetailsRepository.HREmpPassportDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { PEmpno = id });

                if (result1.PMessageType == IsOk)
                {
                    passportDetailsViewModel.HasPassport = result1.PHasPassport;
                    passportDetailsViewModel.Surname = result1.PSurname;
                    passportDetailsViewModel.PassportNo = result1.PPassportNo;
                    passportDetailsViewModel.GivenName = result1.PGivenName;
                    passportDetailsViewModel.IssueDate = result1.PIssueDate;
                    passportDetailsViewModel.ExpiryDate = result1.PExpiryDate;
                    passportDetailsViewModel.IssuedAt = result1.PIssuedAt;

                    ViewData["HasPassport"] = String.IsNullOrEmpty(result1.PHasPassport) ? "Passport info not updated" : result1.PHasPassport == IsOk ? "Yes" : "No";
                    ViewData["PassportUploadedMsg"] = String.IsNullOrEmpty(result1.PFileName) ? "" : "Passport copy uploaded.";
                }
                var scanFileDetail = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PFileType = ConstFileTypePassport
                    });

                passportDetailsViewModel.HasScanFilePassport = scanFileDetail.PFileName;
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalEmpPassportDetailsPartial", passportDetailsViewModel);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfPassportDetailsEdit(string id)
        {
            PassportDetailsViewModel passportDetailsViewModel = new();

            passportDetailsViewModel.Empno = id;

            passportDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);

            try
            {
                EmployeePassportDetailOut result1 = await _empPassportDetailsRepository.HREmpPassportDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { PEmpno = id });

                if (result1.PMessageType == IsOk)
                {
                    passportDetailsViewModel.HasPassport = result1.PHasPassport;
                    passportDetailsViewModel.Surname = result1.PSurname;
                    passportDetailsViewModel.PassportNo = result1.PPassportNo;
                    passportDetailsViewModel.GivenName = result1.PGivenName;
                    passportDetailsViewModel.IssueDate = result1.PIssueDate;
                    passportDetailsViewModel.ExpiryDate = result1.PExpiryDate;
                    passportDetailsViewModel.IssuedAt = result1.PIssuedAt;

                    IList<DataField> dataFields = new List<DataField>();
                    dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
                    dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });

                    ViewData["HasPassport"] = new SelectList(dataFields, "DataValueField", "DataTextField", result1.PHasPassport);
                }
                else
                    throw new Exception(result1.PMessageText);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalEmpPassportDetailsEditPartial", passportDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfPassportDetailsEdit([FromForm] PassportDetailsViewModel passportDetailsViewModel)
        {
            try
            {
                if (passportDetailsViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(passportDetailsViewModel.Empno);
                    if (lockStatusDetail.IsPassportOpen != IsOk)
                    {
                        throw new Exception("Passport Details Are Locked.");
                    }

                    if (passportDetailsViewModel.HasPassport == NotOk)
                    {
                        EmployeeScanFileDetailOut scanFileDetails = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = passportDetailsViewModel.Empno,
                            PFileType = ConstFileTypePassport,
                        });

                        if (scanFileDetails.PMessageType == IsOk)
                        {
                            StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, scanFileDetails.PFileName, Configuration);
                        }
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _passportDetailsRepository.HRPassportDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = passportDetailsViewModel.Empno,
                            PHasPassport = passportDetailsViewModel.HasPassport,
                            PSurname = passportDetailsViewModel.Surname,
                            PPassportNo = passportDetailsViewModel.PassportNo,
                            PGivenName = passportDetailsViewModel.GivenName,
                            PIssuedAt = passportDetailsViewModel.IssuedAt,
                            PIssueDate = passportDetailsViewModel.IssueDate,
                            PExpiryDate = passportDetailsViewModel.ExpiryDate
                        });

                    Notify(result.PMessageType == IsOk ? "Success" : "Error", StringHelper.CleanExceptionMessage(result.PMessageText), "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            IList<DataField> dataFields = new List<DataField>();
            dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
            dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });

            ViewData["HasPassport"] = new SelectList(dataFields, "DataValueField", "DataTextField", passportDetailsViewModel.HasPassport);

            ViewData["isOnBehalf"] = IsOk;

            return PartialView("_ModalEmpPassportDetailsEditPartial", passportDetailsViewModel);
        }

        #endregion OnBehalf Passport

        #region Aadhaar

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpAadhaarDetails()
        {
            AadhaarDetailsViewModel aadhaarDetailsViewModel = new();

            try
            {
                EmployeeAadhaarDetailOut result = await _empAadhaarDetailsRepository.EmpAadhaarDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { });

                if (result.PMessageType == IsOk)
                {
                    aadhaarDetailsViewModel.AdhaarNo = result.PAdhaarNo;
                    aadhaarDetailsViewModel.AdhaarName = result.PAdhaarName;
                    aadhaarDetailsViewModel.HasAadhaar = result.PHasAadhaar;
                }

                var scanFileDetail = await _empScanFileDetailsRepository.EmpScanFileDetailsAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL
                      {
                          PFileType = ConstFileTypeAadhaarCard
                      });

                aadhaarDetailsViewModel.HasScanFileAadhaar = scanFileDetail.PFileName;
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IList<DataField> dataFields = new List<DataField>();
            dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
            dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });
            aadhaarDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            ViewData["HasAadhaar"] = new SelectList(dataFields, "DataValueField", "DataTextField", aadhaarDetailsViewModel.HasAadhaar);
            return PartialView("_ModalEmpAadhaarDetailsPartial", aadhaarDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> AadhaarDetailsEdit([FromForm] AadhaarDetailsViewModel aadhaarDetailsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsAadhaarOpen != IsOk)
                    {
                        throw new Exception("Aadhaar Details Are Locked.");
                    }

                    if (aadhaarDetailsViewModel.HasAadhaar == NotOk)
                    {
                        EmployeeScanFileDetailOut scanFileDetails = await _empScanFileDetailsRepository.EmpScanFileDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PFileType = ConstFileTypeAadhaarCard,
                        });

                        if (scanFileDetails.PMessageType == IsOk)
                        {
                            if (!string.IsNullOrEmpty(scanFileDetails.PFileName))
                            {
                                StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, scanFileDetails.PFileName, Configuration);
                            }
                        }
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _aadharDetailsRepository.AadharDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAdhaarNo = aadhaarDetailsViewModel.AdhaarNo,
                            PAdhaarName = aadhaarDetailsViewModel.AdhaarName,
                            PHasAadhaar = aadhaarDetailsViewModel.HasAadhaar,
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

            IList<DataField> dataFields = new List<DataField>();
            dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
            dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });
            aadhaarDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            ViewData["HasAadhaar"] = new SelectList(dataFields, "DataValueField", "DataTextField", aadhaarDetailsViewModel.HasAadhaar);
            return PartialView("_ModalEmpAadhaarDetailsPartial", aadhaarDetailsViewModel);
        }

        #endregion Aadhaar

        #region OnBehalf Aadhaar

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpAadhaarDetails(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            AadhaarDetailsViewModel aadhaarDetailsViewModel = new();
            aadhaarDetailsViewModel.Empno = id;

            try
            {
                EmployeeAadhaarDetailOut result = await _empAadhaarDetailsRepository.HREmpAadhaarDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { PEmpno = id });

                if (result.PMessageType == IsOk)
                {
                    aadhaarDetailsViewModel.AdhaarNo = result.PAdhaarNo;
                    aadhaarDetailsViewModel.AdhaarName = result.PAdhaarName;
                    aadhaarDetailsViewModel.HasAadhaar = result.PHasAadhaar;
                }

                var scanFileDetail = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PFileType = ConstFileTypeAadhaarCard
                    });

                aadhaarDetailsViewModel.HasScanFileAadhaar = scanFileDetail.PFileName;
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            IList<DataField> dataFields = new List<DataField>();
            dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
            dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });

            aadhaarDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);

            ViewData["HasAadhaar"] = new SelectList(dataFields, "DataValueField", "DataTextField", aadhaarDetailsViewModel.HasAadhaar);
            ViewData["isOnBehalf"] = IsOk;

            return PartialView("_ModalEmpAadhaarDetailsPartial", aadhaarDetailsViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfAadhaarDetailsEdit([FromForm] AadhaarDetailsViewModel aadhaarDetailsViewModel)
        {
            try
            {
                if (aadhaarDetailsViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(aadhaarDetailsViewModel.Empno);
                    if (lockStatusDetail.IsAadhaarOpen != IsOk)
                    {
                        throw new Exception("Aadhaar Details Are Locked.");
                    }

                    if (aadhaarDetailsViewModel.HasAadhaar == NotOk)
                    {
                        EmployeeScanFileDetailOut scanFileDetails = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = aadhaarDetailsViewModel.Empno,
                            PFileType = ConstFileTypeAadhaarCard,
                        });

                        if (scanFileDetails.PMessageType == IsOk)
                        {
                            StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, scanFileDetails.PFileName, Configuration);
                        }
                    }

                    Domain.Models.Common.DBProcMessageOutput result = await _aadharDetailsRepository.HRAadharDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = aadhaarDetailsViewModel.Empno,
                            PAdhaarNo = aadhaarDetailsViewModel.AdhaarNo,
                            PAdhaarName = aadhaarDetailsViewModel.AdhaarName,
                            PHasAadhaar = aadhaarDetailsViewModel.HasAadhaar
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

            IList<DataField> dataFields = new List<DataField>();
            dataFields.Add(new DataField { DataTextField = "Yes", DataValueField = "OK" });
            dataFields.Add(new DataField { DataTextField = "No", DataValueField = "KO" });

            aadhaarDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(aadhaarDetailsViewModel.Empno);

            ViewData["HasAadhaar"] = new SelectList(dataFields, "DataValueField", "DataTextField", aadhaarDetailsViewModel.HasAadhaar);
            ViewData["isOnBehalf"] = IsOk;

            return PartialView("_ModalEmpAadhaarDetailsPartial", aadhaarDetailsViewModel);
        }

        #endregion OnBehalf Aadhaar

        #region PassportAndAadhaarDetails

        public async Task<IActionResult> EmployeePassportAndAadhaarDetails()
        {
            EmployeePassportAndAadhaarDetailsViewModel employeePassportAndAadhaarDetailsViewModel = new();

            employeePassportAndAadhaarDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            try
            {
                EmployeeAadhaarDetailOut result = await _empAadhaarDetailsRepository.EmpAadhaarDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { });

                if (result.PMessageType == IsOk)
                {
                    employeePassportAndAadhaarDetailsViewModel.AdhaarNo = result.PAdhaarNo;
                    employeePassportAndAadhaarDetailsViewModel.AdhaarName = result.PAdhaarName;
                }

                EmployeePassportDetailOut result1 = await _empPassportDetailsRepository.EmpPassportDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { });

                if (result1.PMessageType == IsOk)
                {
                    employeePassportAndAadhaarDetailsViewModel.HasPassport = result1.PHasPassport;
                    employeePassportAndAadhaarDetailsViewModel.Surname = result1.PSurname;
                    employeePassportAndAadhaarDetailsViewModel.PassportNo = result1.PPassportNo;
                    employeePassportAndAadhaarDetailsViewModel.GivenName = result1.PGivenName;
                    employeePassportAndAadhaarDetailsViewModel.IssueDate = result1.PIssueDate;
                    employeePassportAndAadhaarDetailsViewModel.ExpiryDate = result1.PExpiryDate;
                    employeePassportAndAadhaarDetailsViewModel.IssuedAt = result1.PIssuedAt;
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return PartialView("_ModalEmpGenInfoPassportAndAadhaarDetailsEditPartial", employeePassportAndAadhaarDetailsViewModel);
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AadhaarDetailsEdit1([FromForm] EmployeePassportAndAadhaarDetailsViewModel employeePassportAndAadhaarDetailsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _aadharDetailsRepository.AadharDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAdhaarNo = employeePassportAndAadhaarDetailsViewModel.AdhaarNo,
                            PAdhaarName = employeePassportAndAadhaarDetailsViewModel.AdhaarName
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

            return PartialView("_ModalEmpGenInfoPassportAndAadhaarDetailsEditPartial", employeePassportAndAadhaarDetailsViewModel);
        }

        #endregion PassportAndAadhaarDetails

        #region FileUpload

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> FileUploadEdit(string fileType, string refNumber)
        {
            if (fileType == null || refNumber == null || string.IsNullOrEmpty(refNumber))
            {
                throw new Exception("Invalid request");
            }

            var employeeDetail = await _empPrimaryDetailsRepository.EmpPrimaryDetailsAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL { });

            var scanFileDetail = await _empScanFileDetailsRepository.EmpScanFileDetailsAsync(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL
                       {
                           PFileType = fileType
                       });

            FileUploadViewModel fileUploadViewModel = new();

            fileUploadViewModel.Empno = CurrentUserIdentity.EmpNo;
            fileUploadViewModel.EmpName = employeeDetail.PEmpName;

            fileUploadViewModel.FileName = scanFileDetail.PFileName;
            fileUploadViewModel.RefNumber = refNumber;

            switch (fileType.Trim())
            {
                case ConstFileTypePassport:
                    fileUploadViewModel.FileType = "Passport";
                    break;

                case ConstFileTypeAadhaarCard:
                    fileUploadViewModel.FileType = "Aadhaar Card";
                    break;

                case ConstFileTypeGTLI:
                    fileUploadViewModel.FileType = "GTLI";
                    break;

                default:
                    throw new Exception("Validity request");
            }

            return PartialView("_ModalFilesUpload", fileUploadViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> FileUploadEdit([FromForm] FileUploadViewModel fileUploadViewModel)
        {
            try
            {
                string serverFileName = null;

                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(fileUploadViewModel.Empno);
                    switch (fileUploadViewModel.FileType.Trim())
                    {
                        case ConstFileTypePassport:
                            if (lockStatusDetail.IsPassportOpen != IsOk)
                            {
                                throw new Exception("Passport Details Are Locked.");
                            };
                            break;

                        case ConstFileTypeAadhaarCard:
                            if (lockStatusDetail.IsAadhaarOpen != IsOk)
                            {
                                throw new Exception("Aadhaar Details Are Locked.");
                            };
                            break;

                        case ConstFileTypeGTLI:
                            if (lockStatusDetail.IsGtliOpen != IsOk)
                            {
                                throw new Exception("GTLI Details Are Locked.");
                            };
                            break;

                        default:
                            throw new Exception("Invalid file type");
                    }

                    //EmployeeDetails selfDetail = await _employeeDetailsRepository.GetEmployeeDetailsAsync(fileUploadViewModel.Empno);
                    var selfDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = fileUploadViewModel.Empno
                        });

                    if (fileUploadViewModel.file != null)
                    {
                        switch (fileUploadViewModel.FileType.Trim())
                        {
                            case ConstFileTypePassport:
                                serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, selfDetail.PForEmpno, StorageHelper.EmpGenInfo.GroupEmpGenInfoPassport, fileUploadViewModel.file, Configuration);
                                break;

                            case ConstFileTypeAadhaarCard:
                                serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, selfDetail.PForEmpno, StorageHelper.EmpGenInfo.GroupEmpGenInfoAadharCard, fileUploadViewModel.file, Configuration);
                                break;

                            case ConstFileTypeGTLI:
                                serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, selfDetail.PForEmpno, StorageHelper.EmpGenInfo.GroupEmpGenInfoGTLI, fileUploadViewModel.file, Configuration);
                                break;
                        }

                        if (fileUploadViewModel.FileType == null || serverFileName == null || string.IsNullOrEmpty(fileUploadViewModel.RefNumber))
                        {
                            throw new Exception("Invalid request");
                        }

                        Domain.Models.Common.DBProcMessageOutput result = await _scanFileRepository.ScanFileDetailsEditAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PFileType = fileUploadViewModel.FileType,
                              PFileName = serverFileName,
                              PRefNumber = fileUploadViewModel.RefNumber
                          });

                        if (result.PMessageType == IsOk && (!string.IsNullOrEmpty(fileUploadViewModel.FileName)))
                        {
                            StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, fileUploadViewModel.FileName, Configuration);
                        }

                        if (result.PMessageType != IsOk)
                        {
                            StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, fileUploadViewModel.FileName, Configuration);
                        }

                        return result.PMessageType != IsOk
                       ? throw new Exception(result.PMessageText.Replace("-", " "))
                       : (IActionResult)Json(new { success = true, response = result.PMessageText });
                    }

                    return Json(new { success = "success", response = "success" });
                }
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfFileUploadEdit(string fileType, string id, string refNumber)
        {
            if (fileType == null || refNumber == null)
            {
                throw new Exception("Invalid request");
            }

            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            var employeeDetail = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL { PEmpno = id });

            var scanFileDetail = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL
                       {
                           PEmpno = id,
                           PFileType = fileType
                       });

            FileUploadViewModel fileUploadViewModel = new();

            fileUploadViewModel.Empno = id;
            fileUploadViewModel.EmpName = employeeDetail.PEmpName;

            fileUploadViewModel.FileName = scanFileDetail.PFileName;
            fileUploadViewModel.RefNumber = refNumber;

            switch (fileType.Trim())
            {
                case ConstFileTypePassport:
                    fileUploadViewModel.FileType = "Passport";
                    break;

                case ConstFileTypeAadhaarCard:
                    fileUploadViewModel.FileType = "Aadhaar Card";
                    break;

                case ConstFileTypeGTLI:
                    fileUploadViewModel.FileType = "GTLI";
                    break;

                default:
                    throw new Exception("InValid request");
            }

            ViewData["isOnBehalf"] = IsOk;

            return PartialView("_ModalFilesUpload", fileUploadViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OnBehalfFileUploadEdit([FromForm] FileUploadViewModel fileUploadViewModel)
        {
            try
            {
                if (fileUploadViewModel.Empno == null)
                {
                    throw new Exception("Invalid employee".Replace("-", " "));
                }

                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(fileUploadViewModel.Empno);
                    switch (fileUploadViewModel.FileType.Trim())
                    {
                        case ConstFileTypePassport:
                            if (lockStatusDetail.IsPassportOpen != IsOk)
                            {
                                throw new Exception("Passport Details Are Locked.");
                            };
                            break;

                        case ConstFileTypeAadhaarCard:
                            if (lockStatusDetail.IsAadhaarOpen != IsOk)
                            {
                                throw new Exception("Aadhaar Details Are Locked.");
                            };
                            break;

                        case ConstFileTypeGTLI:
                            if (lockStatusDetail.IsGtliOpen != IsOk)
                            {
                                throw new Exception("GTLI Details Are Locked.");
                            };
                            break;

                        default:
                            throw new Exception("Invalid file type");
                    }

                    string serverFileName = "";
                    //EmployeeDetails selfDetail = await _employeeDetailsRepository.GetEmployeeDetailsAsync(fileUploadViewModel.Empno);
                    var selfDetail = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = fileUploadViewModel.Empno
                        });

                    if (fileUploadViewModel.file != null)
                    {
                        switch (fileUploadViewModel.FileType.Trim())
                        {
                            case ConstFileTypePassport:
                                serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, selfDetail.PForEmpno, StorageHelper.EmpGenInfo.GroupEmpGenInfoPassport, fileUploadViewModel.file, Configuration);
                                break;

                            case ConstFileTypeAadhaarCard:
                                serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, selfDetail.PForEmpno, StorageHelper.EmpGenInfo.GroupEmpGenInfoAadharCard, fileUploadViewModel.file, Configuration);
                                break;

                            case ConstFileTypeGTLI:
                                serverFileName = await StorageHelper.SaveFileAsync(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, selfDetail.PForEmpno, StorageHelper.EmpGenInfo.GroupEmpGenInfoGTLI, fileUploadViewModel.file, Configuration);
                                break;
                        }

                        Domain.Models.Common.DBProcMessageOutput result = await _scanFileRepository.HRScanFileDetailsEditAsync(
                     BaseSpTcmPLGet(),
                     new ParameterSpTcmPL
                     {
                         PEmpno = fileUploadViewModel.Empno,
                         PFileType = fileUploadViewModel.FileType,
                         PFileName = serverFileName,
                         PRefNumber = fileUploadViewModel.RefNumber
                     });

                        if (result.PMessageType == IsOk && (!string.IsNullOrEmpty(fileUploadViewModel.FileName)))
                        {
                            StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, fileUploadViewModel.FileName, Configuration);
                        }

                        if (result.PMessageType != IsOk)
                        {
                            StorageHelper.DeleteFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, fileUploadViewModel.FileName, Configuration);
                        }

                        return result.PMessageType != IsOk
                       ? throw new Exception(result.PMessageText.Replace("-", " "))
                       : (IActionResult)Json(new { success = true, response = result.PMessageText });
                    }

                    return Json(new { success = "success", response = "success" });
                }
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion FileUpload

        #region OnBehalf AadhaarDetails

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfPassportDetails()
        {
            EmployeePassportAndAadhaarDetailsViewModel employeePassportAndAadhaarDetailsViewModel = new();

            employeePassportAndAadhaarDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();

            try
            {
                EmployeeAadhaarDetailOut result = await _empAadhaarDetailsRepository.EmpAadhaarDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { });

                if (result.PMessageType == IsOk)
                {
                    employeePassportAndAadhaarDetailsViewModel.AdhaarNo = result.PAdhaarNo;
                    employeePassportAndAadhaarDetailsViewModel.AdhaarName = result.PAdhaarName;
                }

                EmployeePassportDetailOut result1 = await _empPassportDetailsRepository.EmpPassportDetailsAsync(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL { });

                if (result1.PMessageType == IsOk)
                {
                    employeePassportAndAadhaarDetailsViewModel.HasPassport = result1.PHasPassport;
                    employeePassportAndAadhaarDetailsViewModel.Surname = result1.PSurname;
                    employeePassportAndAadhaarDetailsViewModel.PassportNo = result1.PPassportNo;
                    employeePassportAndAadhaarDetailsViewModel.GivenName = result1.PGivenName;
                    employeePassportAndAadhaarDetailsViewModel.IssueDate = result1.PIssueDate;
                    employeePassportAndAadhaarDetailsViewModel.ExpiryDate = result1.PExpiryDate;
                    employeePassportAndAadhaarDetailsViewModel.IssuedAt = result1.PIssuedAt;
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return PartialView("_ModalEmpGenInfoPassportAndAadhaarDetailsEditPartial", employeePassportAndAadhaarDetailsViewModel);
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfAadhaarDetailsEdit1([FromForm] AadhaarDetailsViewModel aadhaarDetailsViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _aadharDetailsRepository.AadharDetailsEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAdhaarNo = aadhaarDetailsViewModel.AdhaarNo,
                            PAdhaarName = aadhaarDetailsViewModel.AdhaarName
                        });

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, message = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalEmpGenInfoPassportAndAadhaarDetailsEditPartial", aadhaarDetailsViewModel);
        }

        #endregion OnBehalf AadhaarDetails

        #region GTLIDetails

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> EmpGenInfoGTLIDetailsIndex()
        {
            EmpGenInfoGTLIDetailsViewModel empGenInfoGTLIDetailsViewModel = new();

            empGenInfoGTLIDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync();
            empGenInfoGTLIDetailsViewModel.DescripancyDetailViewModel = await GetDescripancyDetailAsync();

            EmpPrimaryDetailOut result = await _empPrimaryDetailsRepository.EmpPrimaryDetailsAsync(
                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL());

            var scanFileDetail = await _empScanFileDetailsRepository.EmpScanFileDetailsAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PFileType = ConstFileTypeGTLI
                   });

            empGenInfoGTLIDetailsViewModel.HasScanFileGTLI = scanFileDetail.PFileName;

            if (result.PMessageType == IsOk)
            {
                empGenInfoGTLIDetailsViewModel.FirstName = result.PFirstName;
                empGenInfoGTLIDetailsViewModel.Surname = result.PSurname;
                empGenInfoGTLIDetailsViewModel.FatherName = result.PFatherName;
                empGenInfoGTLIDetailsViewModel.Address = result.PPAdd;
                empGenInfoGTLIDetailsViewModel.Pincode = result.PPPincode;
                empGenInfoGTLIDetailsViewModel.NoDadHusbInName = (result.PNoDadHusbInName == "1" ? true : false);
            }

            return PartialView("_ModalEmpGenInfoGTLIDetailsEditPartial", empGenInfoGTLIDetailsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<JsonResult> GetListsGTLIDetails(string paramJson)
        {
            DTResult<GTLIDetailsDataTableList> result = new();

            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                System.Collections.Generic.IEnumerable<GTLIDetailsDataTableList> data = await _gTLIDetailsDataTableListRepository.GTLIDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GTLIDetailsAdd()
        {
            try
            {
                EmpGTLIDetailsCreateViewModel empGTLIDetailsCreateViewModel = new();

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

                return PartialView("_ModalEmpGTLIDetailsCreatePartial", empGTLIDetailsCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        ////[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionCreateJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GTLIDetailsAdd([FromForm] EmpGTLIDetailsCreateViewModel empGTLIDetailsCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsGtliOpen != IsOk)
                    {
                        throw new Exception("GTLI Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empGTLINominationRepository.EmpGtliNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PNomName = empGTLIDetailsCreateViewModel.NomName,
                            PNomAdd1 = empGTLIDetailsCreateViewModel.NomAdd1,
                            PRelation = empGTLIDetailsCreateViewModel.Relation,
                            PNomDob = empGTLIDetailsCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empGTLIDetailsCreateViewModel.SharePcnt),
                            PNomMinorGuardName = empGTLIDetailsCreateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empGTLIDetailsCreateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empGTLIDetailsCreateViewModel.NomMinorGuardRelation
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

            var relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpGTLIDetailsCreatePartial", empGTLIDetailsCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GTLIDetailsEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                GTLINominationDetails result = await _gTLINominationDetailRepository.GTLINominationDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                EmpGTLIDetailsUpdateViewModel empGTLIDetailsUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empGTLIDetailsUpdateViewModel.KeyId = id;

                    empGTLIDetailsUpdateViewModel.NomName = result.PNomName;
                    empGTLIDetailsUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empGTLIDetailsUpdateViewModel.Relation = result.PRelation;
                    empGTLIDetailsUpdateViewModel.NomDob = result.PNomDob;
                    empGTLIDetailsUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
                    empGTLIDetailsUpdateViewModel.NomMinorGuardName = result.PNomMinorGuardName;
                    empGTLIDetailsUpdateViewModel.NomMinorGuardAdd1 = result.PNomMinorGuardAdd1;
                    empGTLIDetailsUpdateViewModel.NomMinorGuardRelation = result.PNomMinorGuardRelation;
                }

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empGTLIDetailsUpdateViewModel.Relation);

                return PartialView("_ModalEmpGTLIDetailsUpdatePartial", empGTLIDetailsUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GTLIDetailsEdit([FromForm] EmpGTLIDetailsUpdateViewModel empGTLIDetailsUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync();
                    if (lockStatusDetail.IsGtliOpen != IsOk)
                    {
                        throw new Exception("GTLI Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empGTLINominationRepository.EmpGtliNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empGTLIDetailsUpdateViewModel.KeyId,
                            PNomName = empGTLIDetailsUpdateViewModel.NomName,
                            PNomAdd1 = empGTLIDetailsUpdateViewModel.NomAdd1,
                            PRelation = empGTLIDetailsUpdateViewModel.Relation,
                            PNomDob = empGTLIDetailsUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empGTLIDetailsUpdateViewModel.SharePcnt),
                            PNomMinorGuardName = empGTLIDetailsUpdateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empGTLIDetailsUpdateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empGTLIDetailsUpdateViewModel.NomMinorGuardRelation
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empGTLIDetailsUpdateViewModel.Relation);

            return PartialView("_ModalEmpGTLIDetailsUpdatePartial", empGTLIDetailsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateSelfInfo)]
        public async Task<IActionResult> GTLIDetailsDelete(string id)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync();
                if (lockStatusDetail.IsGtliOpen != IsOk)
                {
                    throw new Exception("GTLI Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empGTLINominationRepository.EmpGtliNominationDeleteAsync(
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

        #endregion GTLIDetails

        #region OnBehalf GTLI

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpGenInfoGTLIDetailsIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpGenInfoGTLIDetailsViewModel empGenInfoGTLIDetailsViewModel = new();
            empGenInfoGTLIDetailsViewModel.Empno = id;
            empGenInfoGTLIDetailsViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);
            empGenInfoGTLIDetailsViewModel.DescripancyDetailViewModel = await GetDescripancyDetailAsync(id);

            EmpPrimaryDetailOut result = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(

                       BaseSpTcmPLGet(),
                       new ParameterSpTcmPL { PEmpno = id });

            var scanFileDetail = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                 BaseSpTcmPLGet(),
                 new ParameterSpTcmPL
                 {
                     PEmpno = id,
                     PFileType = ConstFileTypeGTLI
                 });

            empGenInfoGTLIDetailsViewModel.HasScanFileGTLI = scanFileDetail.PFileName;

            if (result.PMessageType == IsOk)
            {
                empGenInfoGTLIDetailsViewModel.FirstName = result.PFirstName;
                empGenInfoGTLIDetailsViewModel.Surname = result.PSurname;
                empGenInfoGTLIDetailsViewModel.FatherName = result.PFatherName;
                empGenInfoGTLIDetailsViewModel.Address = result.PPAdd;
                empGenInfoGTLIDetailsViewModel.Pincode = result.PPPincode;
                empGenInfoGTLIDetailsViewModel.NoDadHusbInName = (result.PNoDadHusbInName == "1" ? true : false);
            }
            ViewData["isOnBehalf"] = IsOk;
            return PartialView("_ModalEmpGenInfoGTLIDetailsEditPartial", empGenInfoGTLIDetailsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<JsonResult> OnBehalfGetListsGTLIDetails(string paramJson)
        {
            DTResult<GTLIDetailsDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            if (param.Empno == null)
            {
                return Json(new
                {
                    error = "employee no not found"
                });
            }

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<GTLIDetailsDataTableList> data = await _gTLIDetailsDataTableListRepository.HRGTLIDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno,
                        PRowNumber = 0,
                        PPageLength = 1000
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGTLIDetailsAdd(string id)
        {
            try
            {
                if (id == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                EmpGTLIDetailsCreateViewModel empGTLIDetailsCreateViewModel = new();
                empGTLIDetailsCreateViewModel.Empno = id;

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalEmpGTLIDetailsCreatePartial", empGTLIDetailsCreateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGTLIDetailsAdd([FromForm] EmpGTLIDetailsCreateViewModel empGTLIDetailsCreateViewModel)
        {
            try
            {
                if (empGTLIDetailsCreateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empGTLIDetailsCreateViewModel.Empno);
                    if (lockStatusDetail.IsGtliOpen != IsOk)
                    {
                        throw new Exception("GTLI Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empGTLINominationRepository.HREmpGtliNominationCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empGTLIDetailsCreateViewModel.Empno,
                            PNomName = empGTLIDetailsCreateViewModel.NomName,
                            PNomAdd1 = empGTLIDetailsCreateViewModel.NomAdd1,
                            PRelation = empGTLIDetailsCreateViewModel.Relation,
                            PNomDob = empGTLIDetailsCreateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empGTLIDetailsCreateViewModel.SharePcnt),
                            PNomMinorGuardName = empGTLIDetailsCreateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empGTLIDetailsCreateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empGTLIDetailsCreateViewModel.NomMinorGuardRelation
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

            var relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpGTLIDetailsCreatePartial", empGTLIDetailsCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGTLIDetailsEdit(string id)
        {
            try
            {
                if (id == null)
                {
                    return NotFound();
                }

                GTLINominationDetails result = await _gTLINominationDetailRepository.GTLINominationDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    });

                EmpGTLIDetailsUpdateViewModel empGTLIDetailsUpdateViewModel = new();

                if (result.PMessageType == IsOk)
                {
                    empGTLIDetailsUpdateViewModel.KeyId = id;
                    empGTLIDetailsUpdateViewModel.Empno = result.PEmpno;
                    empGTLIDetailsUpdateViewModel.NomName = result.PNomName;
                    empGTLIDetailsUpdateViewModel.NomAdd1 = result.PNomAdd1;
                    empGTLIDetailsUpdateViewModel.Relation = result.PRelation;
                    empGTLIDetailsUpdateViewModel.NomDob = result.PNomDob;
                    empGTLIDetailsUpdateViewModel.SharePcnt = result.PSharePcnt.ToString();
                    empGTLIDetailsUpdateViewModel.NomMinorGuardName = result.PNomMinorGuardName;
                    empGTLIDetailsUpdateViewModel.NomMinorGuardAdd1 = result.PNomMinorGuardAdd1;
                    empGTLIDetailsUpdateViewModel.NomMinorGuardRelation = result.PNomMinorGuardRelation;
                }

                IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

                ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empGTLIDetailsUpdateViewModel.Relation);
                ViewData["isOnBehalf"] = IsOk;

                return PartialView("_ModalEmpGTLIDetailsUpdatePartial", empGTLIDetailsUpdateViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        //[RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionEditJob)]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGTLIDetailsEdit([FromForm] EmpGTLIDetailsUpdateViewModel empGTLIDetailsUpdateViewModel)
        {
            try
            {
                if (empGTLIDetailsUpdateViewModel.Empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }
                if (ModelState.IsValid)
                {
                    var lockStatusDetail = await GetLockStatusDetailAsync(empGTLIDetailsUpdateViewModel.Empno);
                    if (lockStatusDetail.IsGtliOpen != IsOk)
                    {
                        throw new Exception("GTLI Details Are Locked.");
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _empGTLINominationRepository.HREmpGtliNominationEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = empGTLIDetailsUpdateViewModel.KeyId,
                            PEmpno = empGTLIDetailsUpdateViewModel.Empno,
                            PNomName = empGTLIDetailsUpdateViewModel.NomName,
                            PNomAdd1 = empGTLIDetailsUpdateViewModel.NomAdd1,
                            PRelation = empGTLIDetailsUpdateViewModel.Relation,
                            PNomDob = empGTLIDetailsUpdateViewModel.NomDob,
                            PSharePcnt = decimal.Parse(empGTLIDetailsUpdateViewModel.SharePcnt),
                            PNomMinorGuardName = empGTLIDetailsUpdateViewModel.NomMinorGuardName,
                            PNomMinorGuardAdd1 = empGTLIDetailsUpdateViewModel.NomMinorGuardAdd1,
                            PNomMinorGuardRelation = empGTLIDetailsUpdateViewModel.NomMinorGuardRelation
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
            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationListText(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", empGTLIDetailsUpdateViewModel.Relation);

            return PartialView("_ModalEmpGTLIDetailsUpdatePartial", empGTLIDetailsUpdateViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfGTLIDetailsDelete(string id, string empno)
        {
            try
            {
                var lockStatusDetail = await GetLockStatusDetailAsync(empno);
                if (lockStatusDetail.IsGtliOpen != IsOk)
                {
                    throw new Exception("GTLI Details Are Locked.");
                }
                Domain.Models.Common.DBProcMessageOutput result = await _empGTLINominationRepository.HREmpGtliNominationDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id,
                        PEmpno = empno
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion OnBehalf GTLI

        #region Generic Validate Class

        public async Task<GetLockStatusDetailViewModel> GetLockStatusDetailAsync(string empno = null)
        {
            GetLockStatusDetailViewModel lockStatusDetailViewModel = new();
            try
            {
                EmpGenInfoGetLockStatusDetailOut result = await _empGenInfoGetLockStatusDetailsRepository.EmpGenInfoGetLockStatusDetailsAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL { PEmpno = empno });

                if (result.PMessageType == IsOk)
                {
                    lockStatusDetailViewModel.IsPrimaryOpen = result.PIsPrimaryOpen;
                    lockStatusDetailViewModel.IsSecondaryOpen = result.PIsSecondaryOpen;
                    lockStatusDetailViewModel.IsNominationOpen = result.PIsNominationOpen;
                    lockStatusDetailViewModel.IsMediclaimOpen = result.PIsMediclaimOpen;
                    lockStatusDetailViewModel.IsAadhaarOpen = result.PIsAadhaarOpen;
                    lockStatusDetailViewModel.IsPassportOpen = result.PIsPassportOpen;
                    lockStatusDetailViewModel.IsGtliOpen = result.PIsGtliOpen;
                }
                return lockStatusDetailViewModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public async Task<GetDescripancyDetailViewModel> GetDescripancyDetailAsync(string empno = null)
        {
            GetDescripancyDetailViewModel descripancyDetailViewModel = new();
            try
            {
                EmpGenInfoGetDescripancyDetailOut result = await _empGenInfoGetDescripancyDetailsRepository.EmpGenInfoGetDescripancyDetailsAsync(
                      BaseSpTcmPLGet(),
                      new ParameterSpTcmPL { PEmpno = empno });

                if (result.PMessageType == IsOk)
                {
                    descripancyDetailViewModel.PrimaryStatus = result.PPrimaryStatus;
                    descripancyDetailViewModel.PrimaryText = result.PPrimaryText;
                    descripancyDetailViewModel.NominationStatus = result.PNominationStatus;
                    descripancyDetailViewModel.NominationText = result.PNominationText;
                    descripancyDetailViewModel.GratuityStatus = result.PGratuityStatus;
                    descripancyDetailViewModel.GratuityText = result.PGratuityText;
                    descripancyDetailViewModel.EpfStatus = result.PEpfStatus;
                    descripancyDetailViewModel.EpfText = result.PEpfText;
                    descripancyDetailViewModel.EpsaStatus = result.PEpsaStatus;
                    descripancyDetailViewModel.EpsaText = result.PEpsaText;
                    descripancyDetailViewModel.EpsmStatus = result.PEpsmStatus;
                    descripancyDetailViewModel.EpsmText = result.PEpsmText;
                    descripancyDetailViewModel.MediclaimStatus = result.PMediclaimStatus;
                    descripancyDetailViewModel.CanMediclaimAdd = result.PCanMediclaimAdd;
                    descripancyDetailViewModel.CanMediclaimEdit = result.PCanMediclaimEdit;
                    descripancyDetailViewModel.MediclaimText = result.PMediclaimText;
                    descripancyDetailViewModel.PpAaStatus = result.PPpAaStatus;
                    descripancyDetailViewModel.PpAaText = result.PPpAaText;
                    descripancyDetailViewModel.AaStatus = result.PAaStatus;
                    descripancyDetailViewModel.AaText = result.PAaText;
                    descripancyDetailViewModel.GtliStatus = result.PGtliStatus;
                    descripancyDetailViewModel.GtliText = result.PGtliText;
                    descripancyDetailViewModel.SupAnnuStatus = result.PSupAnnuStatus;
                    descripancyDetailViewModel.SupAnnuText = result.PSupAnnuText;
                    descripancyDetailViewModel.CanPrintGTLI = result.PCanPrintGtli;
                }
                return descripancyDetailViewModel;
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion Generic Validate Class

        #region HR_Emp_Info

        //public async Task<IActionResult> OnBeHalfGenInfoDetails(string id)
        //{
        //    if (id == null)
        //    {
        //        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
        //    }

        // if (id == null) { return StatusCode((int)HttpStatusCode.InternalServerError,
        // StringHelper.CleanExceptionMessage("employee no not found")); }

        // EmpGenInfoPrimaryDetailsViewModel empGenInformationViewModel = new();
        // PrimaryDetailViewModel primaryDetails = new();

        // empGenInformationViewModel.LockStatusDetailViewModel = await
        // GetLockStatusDetailAsync(id); try { EmpPrimaryDetailOut result = await
        // _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync( BaseSpTcmPLGet(), new
        // ParameterSpTcmPL { PEmpno = id });

        // if (result.PMessageType == IsOk) { primaryDetails.Assign = result.PAssign;
        // primaryDetails.AssignName = result.PAssignName; primaryDetails.CostName =
        // result.PCostName; primaryDetails.DesgCode = result.PDesgCode; primaryDetails.DesgName =
        // result.PDesgName; primaryDetails.Doj = DateTime.Parse(result.PDoj); primaryDetails.Name =
        // result.PEmpName; primaryDetails.EmpType = result.PEmptype; primaryDetails.Grade =
        // result.PGrade; primaryDetails.HoD = result.PHod; primaryDetails.HoDName =
        // result.PHodName; primaryDetails.Parent = result.PParent; primaryDetails.Secretary =
        // result.PSecretary; primaryDetails.SecName = result.PSecretaryName; }
        // empGenInformationViewModel.Empno = id; empGenInformationViewModel.PrimaryDetails =
        // primaryDetails; } catch (Exception ex) { Notify("Error", ex.Message + " " +
        // ex.InnerException?.Message, "toaster", NotificationType.error); return
        // RedirectToAction("Index", "Home"); }

        //    return View("OnBehalfGenInfoDetails", empGenInformationViewModel);
        //}

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBeHalfGenInfoDetails(string empno)
        {
            if (empno == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpGenInfoPrimaryDetailsViewModel empGenInformationViewModel = new();
            PrimaryDetailViewModel primaryDetails = new();

            empGenInformationViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(empno);
            // empGenInformationViewModel.DescripancyDetailViewModel = await GetDescripancyDetailAsync(empno);

            try
            {
                EmpPrimaryDetailOut result = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL
                           {
                               PEmpno = empno
                           });

                if (result.PMessageType == IsOk)
                {
                    primaryDetails.Assign = result.PAssign;
                    primaryDetails.AssignName = result.PAssignName;
                    primaryDetails.CostName = result.PCostName;
                    primaryDetails.DesgCode = result.PDesgCode;
                    primaryDetails.DesgName = result.PDesgName;
                    primaryDetails.Doj = result.PDoj;
                    primaryDetails.Dob = result.PDob;

                    primaryDetails.Name = result.PEmpName;
                    primaryDetails.EmpType = result.PEmptype;
                    primaryDetails.Grade = result.PGrade;
                    primaryDetails.Gender = result.PGender;
                    primaryDetails.HoD = result.PHod;
                    primaryDetails.HoDName = result.PHodName;
                    primaryDetails.Parent = result.PParent;
                    primaryDetails.Secretary = result.PSecretary;
                    primaryDetails.SecName = result.PSecretaryName;
                }
                primaryDetails.Empno = empno;
                empGenInformationViewModel.Empno = empno;
                empGenInformationViewModel.PrimaryDetails = primaryDetails;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return RedirectToAction("Index", "Home");
            }

            return View("OnBehalfGenInfoDetails", empGenInformationViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmployeePrimaryDetailIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            //if (id == null)
            //{
            //    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            //}

            var lockDetails = await GetLockStatusDetailAsync(id);

            var empPrimaryDetails = await cmnGetPrimaryDetailsViewModel(id);
            empPrimaryDetails.Empno = id;

            ViewData["CountriesList"] = await cmnGetCountryList(empPrimaryDetails.CountryOfBirth);

            var viewName = lockDetails.IsPrimaryOpen == IsOk ? "_EmpPrimaryDetailsEditPartial" : "_EmpPrimaryDetailsPartial";
            ViewData["isOnBehalf"] = IsOk;

            return PartialView(viewName, empPrimaryDetails);
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> OnBehalfEmpGenInfoNominationDetailsIndex(string id)
        {
            if (id == null)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
            }

            EmpGenInfoGratuityViewModel empGenInfoGratuityViewModel = new();
            EmpPrimaryDetailOut result = new();

            empGenInfoGratuityViewModel.LockStatusDetailViewModel = await GetLockStatusDetailAsync(id);

            result = await cmnGetPrimaryDetails(id);

            if (result.PMessageType == "OK")
            {
                empGenInfoGratuityViewModel.FirstName = result.PFirstName;
                empGenInfoGratuityViewModel.Surname = result.PSurname;
                empGenInfoGratuityViewModel.FatherName = result.PFatherName;
                empGenInfoGratuityViewModel.Address = result.PPAdd;
                empGenInfoGratuityViewModel.Pincode = result.PPPincode;
                empGenInfoGratuityViewModel.NoDadHusbInName = (result.PNoDadHusbInName == "1" ? true : false);
            }
            empGenInfoGratuityViewModel.Empno = id;

            return PartialView("_OnBehalfEmpNominationDetailsPartial", empGenInfoGratuityViewModel);
        }

        #endregion HR_Emp_Info

        #region LockStatus

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGILock)]
        public async Task<IActionResult> LockStatusIndex()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterLockStatusIndex
                });

                EmpLockStatusDetailsViewModel empLockStatusDetailsViewModel = new EmpLockStatusDetailsViewModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    empLockStatusDetailsViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                return View(empLockStatusDetailsViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGILock)]
        public async Task<JsonResult> GetListsloadEmpLockStatusDetails(string paramJson)
        {
            DTResult<EmpLockStatusDetailsDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                System.Collections.Generic.IEnumerable<EmpLockStatusDetailsDataTableList> data =
                                                    await _lockStatusDetailsDataTableListRepository.LockStatusDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PParent = param.Parent,
                        PIsPrimaryOpen = param.IsPrimaryOpen,
                        PIsSecondaryOpen = param.IsSecondaryOpen,
                        PIsMediclaimOpen = param.IsMediclaimOpen,
                        PIsNominationOpen = param.IsNominationOpen,
                        PIsAadhaarOpen = param.IsAadhaarOpen,
                        PIsPassportOpen = param.IsPassportOpen,
                        PIsGtliOpen = param.IsGtliOpen,
                        PExEmpno = param.ExEmpno,
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGILock)]
        public async Task<IActionResult> LockStatusEdit(string empno, string empName)
        {
            try
            {
                if (empno == null)
                {
                    return NotFound();
                }

                LockStatusDetailEditViewModel lockStatusDetailEditViewModel = new();

                var lockDetails = await GetLockStatusDetailAsync(empno);

                if (lockDetails != null)
                {
                    lockStatusDetailEditViewModel.EmpNo = empno;
                    lockStatusDetailEditViewModel.EmpName = empName;
                    if (lockDetails.IsPrimaryOpen == IsOk)
                    {
                        lockStatusDetailEditViewModel.IsPrimaryOpen = _Ok;
                    }
                    if (lockDetails.IsSecondaryOpen == IsOk)
                    {
                        lockStatusDetailEditViewModel.IsSecondaryOpen = _Ok;
                    }
                    if (lockDetails.IsNominationOpen == IsOk)
                    {
                        lockStatusDetailEditViewModel.IsNominationOpen = _Ok;
                    }
                    if (lockDetails.IsMediclaimOpen == IsOk)
                    {
                        lockStatusDetailEditViewModel.IsMediclaimOpen = _Ok;
                    }
                    if (lockDetails.IsAadhaarOpen == IsOk)
                    {
                        lockStatusDetailEditViewModel.IsAadhaarOpen = _Ok;
                    }
                    if (lockDetails.IsPassportOpen == IsOk)
                    {
                        lockStatusDetailEditViewModel.IsPassportOpen = _Ok;
                    }
                    if (lockDetails.IsGtliOpen == IsOk)
                    {
                        lockStatusDetailEditViewModel.IsGtliOpen = _Ok;
                    }
                }

                return PartialView("_ModalLockStatusEditPartial", lockStatusDetailEditViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGILock)]
        public async Task<IActionResult> LockStatusEdit([FromForm] LockStatusDetailEditViewModel lockStatusDetailEditViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _empDetailsLockStatusRepository.EmpDetailsLockStatusEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = lockStatusDetailEditViewModel.EmpNo,
                            PIsPrimaryOpen = lockStatusDetailEditViewModel.IsPrimaryOpen,
                            PIsSecondaryOpen = lockStatusDetailEditViewModel.IsSecondaryOpen,
                            PIsNominationOpen = lockStatusDetailEditViewModel.IsNominationOpen,
                            PIsMediclaimOpen = lockStatusDetailEditViewModel.IsMediclaimOpen,
                            PIsAadhaarOpen = lockStatusDetailEditViewModel.IsAadhaarOpen,
                            PIsPassportOpen = lockStatusDetailEditViewModel.IsPassportOpen,
                            PIsGtliOpen = lockStatusDetailEditViewModel.IsGtliOpen
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

            return PartialView("_ModalLockStatusEditPartial", lockStatusDetailEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGILock)]
        public async Task<IActionResult> UpdateNewJoinee()
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _empDetailsLockStatusRepository.UpdateNewJoineeAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    }
                    );

                Notify(result.PMessageType == IsOk ? "Success" : "Error", StringHelper.CleanExceptionMessage(result.PMessageText), "", result.PMessageType == IsOk ? NotificationType.success : NotificationType.error);
                return RedirectToAction("LockStatusIndex");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }
            return RedirectToAction("LockStatusIndex");
        }

        #endregion LockStatus

        #region Bulk Action

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGILock)]
        public IActionResult BulkActionEdit()
        {
            BulkActionEditViewModel bulkActionEditViewModel = new();

            return PartialView("_ModalBulkActionEditPartial", bulkActionEditViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGILock)]
        public async Task<IActionResult> BulkActionEdit([FromForm] BulkActionEditViewModel bulkActionEditViewModel)
        {
            decimal isLock = -1;
            decimal isOpen = 1;
            string isChecked = "1";

            try
            {
                Domain.Models.Common.DBProcMessageOutput result = new();

                if (ModelState.IsValid)
                {
                    if (
                        bulkActionEditViewModel.OpenGtli == isChecked ||
                        bulkActionEditViewModel.OpenMediclaim == isChecked ||
                        bulkActionEditViewModel.OpenPassport == isChecked ||
                        bulkActionEditViewModel.OpenAadhaar == isChecked ||
                        bulkActionEditViewModel.OpenNomination == isChecked ||
                        bulkActionEditViewModel.OpenPrimary == isChecked ||
                        bulkActionEditViewModel.OpenSecondary == isChecked
                        )
                    {
                        result = await _bulkActionsRepository.BulkActionsLockUpdateAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PIsAadhaarOpen = bulkActionEditViewModel.OpenAadhaar == isChecked ? isOpen : null,
                                PIsGtliOpen = bulkActionEditViewModel.OpenGtli == isChecked ? isOpen : null,
                                PIsMediclaimOpen = bulkActionEditViewModel.OpenMediclaim == isChecked ? isOpen : null,
                                PIsNominationOpen = bulkActionEditViewModel.OpenNomination == isChecked ? isOpen : null,
                                PIsPassportOpen = bulkActionEditViewModel.OpenPassport == isChecked ? isOpen : null,
                                PIsPrimaryOpen = bulkActionEditViewModel.OpenPrimary == isChecked ? isOpen : null,
                                PIsSecondaryOpen = bulkActionEditViewModel.OpenSecondary == isChecked ? isOpen : null,
                            });
                    }
                    else if (
                        bulkActionEditViewModel.LockGTLI == isChecked ||
                        bulkActionEditViewModel.LockMediclaim == isChecked ||
                        bulkActionEditViewModel.LockPassport == isChecked ||
                        bulkActionEditViewModel.LockAdhaar == isChecked ||
                        bulkActionEditViewModel.LockNomination == isChecked ||
                        bulkActionEditViewModel.LockPrimary == isChecked ||
                        bulkActionEditViewModel.LockSecondary == isChecked

                        )
                    {
                        result = await _bulkActionsRepository.BulkActionsLockUpdateAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PIsAadhaarOpen = bulkActionEditViewModel.LockAdhaar == isChecked ? isLock : null,
                                PIsGtliOpen = bulkActionEditViewModel.LockGTLI == isChecked ? isLock : null,
                                PIsMediclaimOpen = bulkActionEditViewModel.LockMediclaim == isChecked ? isLock : null,
                                PIsNominationOpen = bulkActionEditViewModel.LockNomination == isChecked ? isLock : null,
                                PIsPassportOpen = bulkActionEditViewModel.LockPassport == isChecked ? isLock : null,
                                PIsPrimaryOpen = bulkActionEditViewModel.LockPrimary == isChecked ? isLock : null,
                                PIsSecondaryOpen = bulkActionEditViewModel.LockSecondary == isChecked ? isLock : null
                            });
                    }

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            return PartialView("_ModalBulkActionEditPartial", bulkActionEditViewModel);
        }

        #endregion Bulk Action

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
            var retVal = await RetriveFilter(ConstFilterLockStatusIndex);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var parentList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);

            ViewData["ParentList"] = new SelectList(parentList, "DataValueField", "DataTextField");

            return PartialView("_ModalEmpLockStatusDetailsFilterSet", filterDataModel);
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
                            Parent = filterDataModel.Parent,
                            IsPrimaryOpen = filterDataModel.IsPrimaryOpen.ToString(),
                            IsSecondaryOpen = filterDataModel.IsSecondaryOpen.ToString(),
                            IsNominationOpen = filterDataModel.IsNominationOpen.ToString(),
                            IsMediclaimOpen = filterDataModel.IsMediclaimOpen.ToString(),
                            IsAadhaarOpen = filterDataModel.IsAadhaarOpen.ToString(),
                            IsPassportOpen = filterDataModel.IsPassportOpen.ToString(),
                            IsGtliOpen = filterDataModel.IsGtliOpen.ToString(),
                            ExEmpno = filterDataModel.ExEmpno,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterLockStatusIndex);

                return Json(new
                {
                    success = true,
                    parent = filterDataModel.Parent,
                    isPrimaryOpen = filterDataModel.IsPrimaryOpen,
                    isSecondaryOpen = filterDataModel.IsSecondaryOpen,
                    isNominationOpen = filterDataModel.IsNominationOpen,
                    isMediclaimOpen = filterDataModel.IsMediclaimOpen,
                    isAadhaarOpen = filterDataModel.IsAadhaarOpen,
                    isPassportOpen = filterDataModel.IsPassportOpen,
                    isGtliOpen = filterDataModel.IsGtliOpen,
                    exEmpno = filterDataModel.ExEmpno
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter

        [HttpGet]
        public async Task<IActionResult> GetEmpGenInfoValidateStatus(string empno)
        {
            var EmpGenInfoValidateStatus = await GetDescripancyDetailAsync(empno);

            return Json(EmpGenInfoValidateStatus);
        }

        [ValidateAntiForgeryToken]
        public IActionResult DownloadEGIInstructions()
        {
            var bytes = StorageHelper.DownloadFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: "Templates\\EGI-Instructions.pdf", Configuration);
            return File(bytes, "application/octet-stream", "EGI-Instructions.pdf");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> DownloadScanFile(string fileType, string empno)
        {
            try
            {
                if (fileType == null || empno == null)
                {
                    throw new Exception("Invalid request");
                }

                if (empno == null)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("employee no not found"));
                }

                var employeeDetail = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                             BaseSpTcmPLGet(),
                             new ParameterSpTcmPL { PEmpno = empno });

                var scanFileDetail = await _empScanFileDetailsRepository.HREmpScanFileDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL
                           {
                               PEmpno = empno,
                               PFileType = fileType
                           });

                byte[] bytes = null;

                switch (fileType.Trim())
                {
                    case ConstFileTypePassport:
                        bytes = StorageHelper.DownloadFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: scanFileDetail.PFileName, Configuration);
                        break;

                    case ConstFileTypeAadhaarCard:
                        bytes = StorageHelper.DownloadFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: scanFileDetail.PFileName, Configuration);
                        break;

                    case ConstFileTypeGTLI:
                        bytes = StorageHelper.DownloadFile(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: scanFileDetail.PFileName, Configuration);
                        break;

                    case ConstFileTypeNO:
                        return RedirectToAction("DownloadNomination", "Report", new { id = empno });

                    default:
                        throw new Exception("InValid request");
                }

                return File(bytes, "application/octet-stream", scanFileDetail.PFileName);
            }
            catch (FileNotFoundException)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Exception  - File not found..!");
            }
            catch (ArgumentNullException)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "Exception  - File not found..!");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        #region LoAAddendumAppointmentLetter

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumUser)]
        public async Task<IActionResult> LoAAddendumAppointmentLetterIndex()
        {
            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());

            if (!(employeeDetails.PEmpType == "R" || employeeDetails.PEmpType == "F"))
            {
                return Unauthorized("Employee type not valid");
            }

            var result = await _loAAddendumConsentDetailsAsync.LoAAddendumConsentDetailsAsync(
            BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
            });
            ViewData["EmployeeName"] = employeeDetails.PName;
            ViewData["Empno"] = employeeDetails.PForEmpno;

            string content = result.PAcceptanceText;
            content = content.Replace("Email_Pending", "<span class='text-dander' style='color:#dc3545!important'> Email pending </span>");
            result.PAcceptanceText = content;
            return View(result);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumUser)]
        public async Task<IActionResult> AddendumConsentSave([FromForm] LoAAddendumConsentUpdateViewModel loAAddendumConsentUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (loAAddendumConsentUpdateViewModel.AcceptanceStatus == 0)
                    {
                        Notify("Error", "Please select 'I Accept this term & condition' ", "toaster", NotificationType.error);
                    }
                    else
                    {
                        var result = await _loAAddendumConsentUpdateRepository.LoAAddendumConsentUpdateAsync(
                            BaseSpTcmPLGet(),
                            new ParameterSpTcmPL
                            {
                                PAcceptanceStatus = loAAddendumConsentUpdateViewModel.AcceptanceStatus
                            });
                        if (result.PMessageType == NotOk)
                        {
                            Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                        }
                        else
                        {
                            var retVal = await LoaAddendumSendAcceptanceMail();

                            string message = "Consent registered successfully. ";
                            message += (string)(retVal.GetType()).GetProperty("MessageText").GetValue(retVal);
                            string messageType = (string)(retVal.GetType()).GetProperty("MessageType").GetValue(retVal);

                            Notify(messageType == IsOk ? "Success" : "Warning", message, "toaster", messageType == IsOk ? NotificationType.success : NotificationType.warning);
                        }
                    }
                }
                return RedirectToAction("LoAAddendumAppointmentLetterIndex");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                //return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
            return RedirectToAction("LoAAddendumAppointmentLetterIndex");
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumUser)]
        public async Task<IActionResult> GetAddendumtoAppointmentLetter()
        {
            var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeName"] = employeeDetails.PName;
            ViewData["Empno"] = employeeDetails.PForEmpno;
            var result = await _loAAddendumConsentDetailsAsync.LoAAddendumConsentDetailsAsync(
            BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
                PEmpno = employeeDetails.PForEmpno
            });

            //if (result.PAcceptanceStatusVal == 1)
            //{
            //    statusText = ("Already registered your consent on " + result.PAcceptanceDate.Value.ToString("dd-MMM-yyyy HH:mm:ss"));
            //}
            //else if (result.PAcceptanceStatusVal == 2)
            //{
            //    statusText = ("Deemed Confirmation on " + result.PAcceptanceDate.Value.ToString("dd-MMM-yyyy HH:mm:ss"));
            //}
            string content = result.PAcceptanceText;
            content = content.Replace("Email_Pending", "<span class='text-dander' style='color:#dc3545!important'> Email pending </span>");
            ViewData["Signature"] = content;
            ViewData["PAcceptanceStatusVal"] = result.PAcceptanceStatusVal.ToString();
            ViewData["PCommunicationDate"] = result.PCommunicationDate;

            return PartialView("_ModalAddendumtoAppointmentLetterPartial");
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumRelativesColleaguesHR)]
        public async Task<IActionResult> LoAAddendumAppointmentIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLoAAddendumAppointmentIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            LoAAddendumAppointmentViewModel loAAddendumAppointmentViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(loAAddendumAppointmentViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumRelativesColleaguesHR)]
        public async Task<JsonResult> GetListsLoAAddendumAppointmentList(string paramJson)
        {
            DTResult<LoAAddendumAppointmentDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<LoAAddendumAppointmentDataTableList> data = await _loAAddendumAppointmentDataTableListRepository.LoAAddendumAppointmentDataTableListAsync(
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

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumRelativesColleaguesHR)]
        public async Task<IActionResult> LoAAddendumAppointmentExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();

                DataTable dtcostcode = new DataTable();
                DataTable dtmonth = new DataTable();
                string strUser = User.Identity.Name;

                var result = (await _loAAddendumAppointmentDataTableListRepository.LoAAddendumAppointmentDataTableListAsync(
                    BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000
                    }));

                if (result == null)
                {
                    return NotFound();
                }

                LoAAddendumAppointmentExcelViewModel loAAddendumAppointmentExcelViewModel = new();

                foreach (var item in result.Select(s => new { s.Empno, s.EmpName, s.Parent, s.Assign, s.Emptype, s.AcceptanceStatusText, s.EmailStatus, s.AcceptanceDate }))
                {
                    loAAddendumAppointmentExcelViewModel.Data.Add(
                       new DataRows
                       {
                           Empno = item.Empno,
                           EmpName = item.EmpName,
                           Parent = item.Parent,
                           Assign = item.Assign,
                           Emptype = item.Emptype,
                           AcceptanceStatus = item.AcceptanceStatusText,
                           EmailStatus = item.EmailStatus,
                           AcceptanceDate = item.AcceptanceDate
                       });
                };
                var resultData = loAAddendumAppointmentExcelViewModel.Data;

                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "LoAAddendumAppointment_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    var sheet1 = wb.Worksheets.Add("Sheet1");
                    sheet1.Cell(1, 1).InsertTable(resultData);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        byte[] byteContent = stream.ToArray();

                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(byteContent, mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #region Print PDF

        [HttpPost]
        [ValidateAntiForgeryToken]
        private async Task<ActionResult> ConvertResponseMessageToIActionResultPDF(HttpResponseMessage httpResponseMessage, string defaultFileName)
        {
            string fileName = string.Empty;
            if (httpResponseMessage.IsSuccessStatusCode)
            {
                byte[] buffer = null;
                Stream stream = await httpResponseMessage.Content.ReadAsStreamAsync();
                string contentType = httpResponseMessage.Content.Headers.ContentType.ToString();
                using (MemoryStream ms = new MemoryStream())
                {
                    await stream.CopyToAsync(ms);
                    buffer = ms.ToArray();
                }
                var oFile = File(buffer, contentType, defaultFileName);
                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", oFile, NotificationType.success));
            }
            else
            {
                return Json(ResponseHelper.GetMessageObject("Internal server error.", NotificationType.error));
            }
        }

        public async Task<IActionResult> LoaAddendumAcceptancePrint(string empno)
        {
            try
            {
                var result = await _loAAddendumConsentDetailsAsync.LoAAddendumConsentDetailsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno
                    });

                if (result == null)
                {
                    return NotFound();
                }

                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PEmpno = empno
                });

                string htmlString = string.Empty;

                string _uriGetPdf = "PDFGenerator/ConvertHtmlToPdf";
                string fileName = "LoaAddendumAcceptancePrint.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    htmlString = htmlString.Replace("PDate", currDate.ToString("dd-MMM-yyyy"));
                    htmlString = htmlString.Replace("PEmpNo", "(" + employeeDetails.PForEmpno + ")");
                    htmlString = htmlString.Replace("PNameOfEmp", employeeDetails.PName);
                    htmlString = htmlString.Replace("PCommunicationDate", result.PCommunicationDate);

                    if (result.PAcceptanceStatusVal == 1)
                        htmlString = htmlString.Replace("PAcceptanceStatus", "Already registered your consent on " + result.PAcceptanceDate.Value.ToString("dd-MMM-yyyy HH:mm:ss"));
                    else if (result.PAcceptanceStatusVal == 2)
                        htmlString = htmlString.Replace("PAcceptanceStatus", "Deemed Confirmation on " + result.PAcceptanceDate.Value.ToString("dd-MMM-yyyy HH:mm:ss"));
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("LoaAddendumAcceptance_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetPdf, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResultPDF(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        public async Task<dynamic> LoaAddendumSendAcceptanceMail()
        {
            //try
            {
                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                });

                var result = await _loAAddendumConsentDetailsAsync.LoAAddendumConsentDetailsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = employeeDetails.PForEmpno
                    });

                if (result == null)
                {
                    return ResponseHelper.GetMessageObject("Consent details not found.", NotificationType.error);
                }

                string htmlString = string.Empty;
                string emailText = string.Empty;
                string emailSubject = string.Empty;

                string _uriGeneratePdfSendMail = "EmpGenInfoDetails/LoaAddendumGeneratePDFSendMail";
                string fileName = "LoaAddendumAcceptancePrint.txt";
                string emailFileName = "LoaAddendumAcceptanceEmail.txt";

                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: fileName, Configuration);

                string emailFilePath = StorageHelper.GetTemplateFilePath(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: emailFileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                using (StreamReader r = new StreamReader(emailFilePath))
                {
                    emailText = r.ReadToEnd();
                }

                string regexMatchStr = "<subject>(.*?)</subject>";

                Regex regex = new Regex(regexMatchStr);
                var v = regex.Match(emailText);
                emailSubject = v.Groups[1].ToString();

                regexMatchStr = regexMatchStr.Replace("(.*?)", emailSubject);
                emailText = emailText.Replace(regexMatchStr, "");

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    htmlString = htmlString.Replace("PDate", currDate.ToString("dd-MMM-yyyy"));
                    htmlString = htmlString.Replace("PEmpNo", employeeDetails.PForEmpno);
                    htmlString = htmlString.Replace("PNameOfEmp", employeeDetails.PName);
                    htmlString = htmlString.Replace("PCommunicationDate", result.PCommunicationDate);

                    emailText = emailText.Replace("PDate", currDate.ToString("dd-MMM-yyyy"));
                    emailText = emailText.Replace("PNameOfEmp", employeeDetails.PName);
                    emailText = emailText.Replace("PEmpno", employeeDetails.PForEmpno);
                    emailText = emailText.Replace("PCommunicationDate", result.PCommunicationDate);

                    if (result.PAcceptanceStatusVal == 1)
                        htmlString = htmlString.Replace("PAcceptanceStatus", "Accepted the above terms & conditions on " + result.PAcceptanceDate.Value.ToString("dd-MMM-yyyy HH:mm:ss"));
                    else if (result.PAcceptanceStatusVal == 2)
                        htmlString = htmlString.Replace("PAcceptanceStatus", "Deemed Confirmation on " + result.PAcceptanceDate.Value.ToString("dd-MMM-yyyy HH:mm:ss"));
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString += filePath + "-Template not found, contact system administrator !!!";
                }

                HCModel hCModel = new HCModel();
                hCModel.Empno = employeeDetails.PForEmpno;
                hCModel.Htmlcontent = htmlString;
                hCModel.MailTo = employeeDetails.PEmail + ";hr_tcmpl@tecnimont.in;";
                hCModel.MailSubject = emailSubject;
                hCModel.MailBody1 = emailText;
                hCModel.MailType = "HTML";

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGeneratePdfSendMail, hCModel);

                string message = returnResponse.Content.ReadAsStringAsync().Result;
                message = JsonConvert.DeserializeObject<string>(message);

                return ResponseHelper.GetMessageObject(message, returnResponse.IsSuccessStatusCode ? NotificationType.success : NotificationType.error);
            }
            //catch (Exception ex)
            //{
            //    throw new CustomJsonException(ex.Message, ex);
            //}
        }

        #endregion Print PDF

        #endregion LoAAddendumAppointmentLetter

        #region Employment of relatives

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpRelativesColleaguesUser)]
        public async Task<IActionResult> EmploymentOfRelativesIndex()
        {
            EmploymentOfRelativesViewModel employmentOfRelativesViewModel = new();

            EmpRelativesDeclStatusDetailOut details = await _empRelativesDeclStatusDetailsRepository.EmpRelativesDeclStatusDetailsAsync(
                           BaseSpTcmPLGet(), new ParameterSpTcmPL());

            employmentOfRelativesViewModel.IsRelativeInOffice = details.PDeclStatusText;

            var data = await _employeeRelativesDataTableListRepository.EmployeeRelativesDataTableListAsync(
                   BaseSpTcmPLGet(),
                   new ParameterSpTcmPL
                   {
                       PGenericSearch = "",
                       PRowNumber = 0,
                       PPageLength = 500
                   }
               );

            if (data.Any())
            {
                employmentOfRelativesViewModel.RelativeCount = (int)data.FirstOrDefault().TotalRow.Value;
            }

            return View(employmentOfRelativesViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpRelativesColleaguesUser)]
        public async Task<IActionResult> EmploymentOfRelativesAdd()
        {
            EmploymentOfRelativesAddViewModel employmentOfRelativesAddViewModel = new();

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.RelativeEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField");

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField");

            return PartialView("_ModalAddEmploymentOfRelativesPartial", employmentOfRelativesAddViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpRelativesColleaguesUser)]
        public async Task<IActionResult> EmploymentOfRelativesAdd([FromForm] EmploymentOfRelativesAddViewModel employmentOfRelativesAddViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    if (employmentOfRelativesAddViewModel.ColleagueName != null)
                    {
                        var Empno = employmentOfRelativesAddViewModel.ColleagueName;
                        var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                        {
                            PEmpno = Empno
                        });
                        employmentOfRelativesAddViewModel.ColleagueName = employeeDetails.PName;
                        employmentOfRelativesAddViewModel.ColleagueDept = employeeDetails.PCostName;
                        employmentOfRelativesAddViewModel.ColleagueLocation = employeeDetails.PCurrentOfficeLocation;
                        employmentOfRelativesAddViewModel.ColleagueEmpno = Empno;
                    }
                    else
                    {
                        employmentOfRelativesAddViewModel.ColleagueName = employmentOfRelativesAddViewModel.RelativeName;
                        employmentOfRelativesAddViewModel.ColleagueRelation = employmentOfRelativesAddViewModel.RelativeRelation;
                    }
                    Domain.Models.Common.DBProcMessageOutput result = await _employmentOfficeRelativesRepository.EmploymentOfficeRelativesAddAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PColleagueName = employmentOfRelativesAddViewModel.ColleagueName,
                            PColleagueDept = employmentOfRelativesAddViewModel.ColleagueDept,
                            PColleagueRelation = employmentOfRelativesAddViewModel.ColleagueRelation,
                            PColleagueLocation = employmentOfRelativesAddViewModel.ColleagueLocation,
                            PColleagueEmpno = employmentOfRelativesAddViewModel.ColleagueEmpno
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

            IEnumerable<DataField> employeeList = await _selectTcmPLRepository.RelativeEmployeeList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["EmployeeList"] = new SelectList(employeeList, "DataValueField", "DataTextField", employmentOfRelativesAddViewModel.ColleagueEmpno);

            IEnumerable<DataField> relationList = await _selectTcmPLRepository.RelationList(BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["RelationList"] = new SelectList(relationList, "DataValueField", "DataTextField", employmentOfRelativesAddViewModel.ColleagueRelation);

            return PartialView("_ModalAddEmploymentOfRelativesPartial", employmentOfRelativesAddViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpRelativesColleaguesUser)]
        public async Task<JsonResult> GetListsEmployeeRelativeList(string paramJson)
        {
            DTResult<EmployeeRelativesDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<EmployeeRelativesDataTableList> data = await _employeeRelativesDataTableListRepository.EmployeeRelativesDataTableListAsync(
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

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpRelativesColleaguesUser)]
        public async Task<IActionResult> EmployeeRelativeDelete(string name)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _employeeRelativeRepository.EmployeeRelativeDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PColleagueName = name
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpRelativesColleaguesUser)]
        public async Task<IActionResult> RelativeConfirmationSubmitToHR(EmploymentOfRelativesViewModel employmentOfRelativesViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Domain.Models.Common.DBProcMessageOutput result = await _employeeRelativeRepository.SubmitToHRAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PRelativeExists = employmentOfRelativesViewModel.IsRelativeInOffice
                        });
                    if (result.PMessageType != "OK")
                    {
                        Notify("Error", result.PMessageText.Replace("-", " "), "toaster", NotificationType.error);
                    }
                    else
                    {
                        Notify("Success", result.PMessageText.Replace("-", " "), "toaster", NotificationType.success);
                    }
                }
                return RedirectToAction("EmploymentOfRelativesIndex");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumRelativesColleaguesHR)]
        public async Task<IActionResult> EmpRelativesAsColleaguesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmpRelativesAsColleaguesIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            EmpRelativesAsColleaguesViewModel empRelativesAsColleaguesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            return View(empRelativesAsColleaguesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumRelativesColleaguesHR)]
        public async Task<JsonResult> GetListsEmpRelativesAsColleaguesList(string paramJson)
        {
            DTResult<EmpRelativesAsColleaguesDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            try
            {
                System.Collections.Generic.IEnumerable<EmpRelativesAsColleaguesDataTableList> data = await _empRelativesAsColleaguesDataTableListRepository.EmpRelativesAsColleaguesDataTableListAsync(
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

        #region Print PDF

        public async Task<IActionResult> EmployeeRelativesDeclarationPrint(string empno)
        {
            try
            {
                var result = await _employeeRelativesDataTableListRepository.EmployeeRelativesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno,
                        PRowNumber = 0,
                        PPageLength = 1000
                    }
                );

                if (result == null)
                {
                    return NotFound();
                }

                var employeeDetails = await _commonEmployeeDetailsRepository.EmployeeDetailAsync(BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PEmpno = empno
                });

                string htmlString = string.Empty;

                string _uriGetPdf = "PDFGenerator/ConvertHtmlToPdf";
                string fileName = "EmpRelativesDeclPrint.txt";
                var i = 0;
                var x = 0;
                string filePath = StorageHelper.GetTemplateFilePath(StorageHelper.EmpGenInfo.RepositoryEmpGenInfo, FileName: fileName, Configuration);

                using (StreamReader r = new StreamReader(filePath))
                {
                    htmlString = r.ReadToEnd();
                }

                if (!String.IsNullOrEmpty(htmlString))
                {
                    DateTime currDate = DateTime.Now;

                    htmlString = htmlString.Replace("PDate", currDate.ToString("dd-MMM-yyyy"));
                    htmlString = htmlString.Replace("PEmpNo", "(" + employeeDetails.PForEmpno + ")");
                    htmlString = htmlString.Replace("PNameOfEmp", employeeDetails.PName);

                    foreach (var item in result)
                    {
                        i++;
                        if (i == 1)
                        {
                            htmlString = htmlString.Replace("PName1", item.ColleagueName);
                            htmlString = htmlString.Replace("PDepartment1", item.ColleagueDept);
                            htmlString = htmlString.Replace("PRelation1", item.ColleagueRelationText);
                            htmlString = htmlString.Replace("PLocation1", item.ColleagueLocation);
                            htmlString = htmlString.Replace("PColEmpNo1", item.ColleagueEmpno);
                        }
                        else if (i == 2)
                        {
                            htmlString = htmlString.Replace("PName2", item.ColleagueName);
                            htmlString = htmlString.Replace("PDepartment2", item.ColleagueDept);
                            htmlString = htmlString.Replace("PRelation2", item.ColleagueRelationText);
                            htmlString = htmlString.Replace("PLocation2", item.ColleagueLocation);
                            htmlString = htmlString.Replace("PColEmpNo2", item.ColleagueEmpno);
                        }
                        else if (i == 3)
                        {
                            htmlString = htmlString.Replace("PName3", item.ColleagueName);
                            htmlString = htmlString.Replace("PDepartment3", item.ColleagueDept);
                            htmlString = htmlString.Replace("PRelation3", item.ColleagueRelationText);
                            htmlString = htmlString.Replace("PLocation3", item.ColleagueLocation);
                            htmlString = htmlString.Replace("PColEmpNo3", item.ColleagueEmpno);
                        }
                        else if (i == 4)
                        {
                            htmlString = htmlString.Replace("PName4", item.ColleagueName);
                            htmlString = htmlString.Replace("PDepartment4", item.ColleagueDept);
                            htmlString = htmlString.Replace("PRelation4", item.ColleagueRelationText);
                            htmlString = htmlString.Replace("PLocation4", item.ColleagueLocation);
                            htmlString = htmlString.Replace("PColEmpNo4", item.ColleagueEmpno);
                        }
                        else if (i == 5)
                        {
                            htmlString = htmlString.Replace("PName5", item.ColleagueName);
                            htmlString = htmlString.Replace("PDepartment5", item.ColleagueDept);
                            htmlString = htmlString.Replace("PRelation5", item.ColleagueRelationText);
                            htmlString = htmlString.Replace("PLocation5", item.ColleagueLocation);
                            htmlString = htmlString.Replace("PColEmpNo5", item.ColleagueEmpno);
                        }
                    }

                    for (x = i; x < 6; x++)
                    {
                        htmlString = htmlString.Replace("PName" + x, "");
                        htmlString = htmlString.Replace("PDepartment" + x, "");
                        htmlString = htmlString.Replace("PRelation" + x, "");
                        htmlString = htmlString.Replace("PLocation" + x, "");
                        htmlString = htmlString.Replace("PColEmpNo" + x, "");
                    }
                }
                else
                {
                    htmlString = "<br/> <br/>";
                    htmlString = filePath + "-Template not found, contact system administrator !!!";
                }
                string strFileNameOut = String.Format("EmpRelativesDeclaration_{0}_{1}.{2}", employeeDetails.PName.ToString(), DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var returnResponse = await _httpClientWebApi.ExecutePostUriAsync(new HCModel(), _uriGetPdf, new Classes.HCModel { Htmlcontent = htmlString, Fname = strFileNameOut });

                return await ConvertResponseMessageToIActionResultPDF(returnResponse, strFileNameOut);
            }
            catch (Exception ex)
            {
                throw new CustomJsonException(ex.Message, ex);
            }
        }

        #endregion Print PDF

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEmpAddendumRelativesColleaguesHR)]
        public async Task<IActionResult> EmpRelativesAsColleaguesExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();

                DataTable dtcostcode = new DataTable();
                DataTable dtmonth = new DataTable();
                string strUser = User.Identity.Name;

                var result = (await _empRelativesAsColleaguesDataTableListExcelViewRepository.GetEmpRelativesAsColleaguesForExcelAsync(
                    BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000
                    }));
                var result1 = (await _employeeRelativesDataTableListExcelViewRepository.GetEmployeeRelativesForExcelAsync(
                    BaseSpTcmPLGet(), new ParameterSpTcmPL
                    {
                    }));

                if (result == null || result1 == null)
                {
                    return NotFound();
                }

                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "EmpRelativesAsColleagues_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    var sheet1 = wb.Worksheets.Add("Summary");
                    sheet1.Cell(1, 1).InsertTable(result);

                    var sheet2 = wb.Worksheets.Add("Details");
                    sheet2.Cell(1, 1).InsertTable(result1);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        byte[] byteContent = stream.ToArray();

                        var mimeType = MimeTypeMap.GetMimeType("xlsx");

                        FileContentResult file = File(byteContent, mimeType, StrFimeName);

                        return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Employment of relatives
    }
}