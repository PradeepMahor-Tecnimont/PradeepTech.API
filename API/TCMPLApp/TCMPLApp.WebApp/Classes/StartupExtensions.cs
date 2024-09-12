using TCMPLApp.DataAccess.Repositories;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.CoreSettings;
using TCMPLApp.DataAccess.Repositories.DeskBooking;
using TCMPLApp.DataAccess.Repositories.DigiForm;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Repositories.ERS;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.DataAccess.Repositories.HSE;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.DataAccess.Repositories.Logbook;
using TCMPLApp.DataAccess.Repositories.Logs;
using TCMPLApp.DataAccess.Repositories.MailQueue;
using TCMPLApp.DataAccess.Repositories.OffBoarding;
using TCMPLApp.DataAccess.Repositories.ProcessQueue;
using TCMPLApp.DataAccess.Repositories.ProcessQueue.View.Implementation;
using TCMPLApp.DataAccess.Repositories.ProcessQueue.View.Interface;
using TCMPLApp.DataAccess.Repositories.RapReporting;
using TCMPLApp.DataAccess.Repositories.ReportSiteMap;
using TCMPLApp.DataAccess.Repositories.SWP;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.DataAccess.Repositories.Timesheet;
using TCMPLApp.DataAccess.Repositories.Timesheet.Exec.Implementation;
using TCMPLApp.DataAccess.Repositories.Timesheet.Exec.Interface;
using TCMPLApp.DataAccess.Repositories.Timesheet.View.Implementation;
using TCMPLApp.DataAccess.Repositories.Timesheet.View.Interface;
using TCMPLApp.DataAccess.Repositories.Utilities;

namespace Microsoft.Extensions.DependencyInjection
{
    public static class StartupExtensions
    {
        public static IServiceCollection AddDataAccessService(this IServiceCollection services)
        {
            #region View

            services.AddTransient<IEmployeeMasterViewRepository, EmployeeMasterViewRepository>();
            services.AddTransient<ICostCenterMasterMainDataTableListRepository, CostCenterMasterMainDataTableListRepository>();
            services.AddTransient<ICostCenterMasterMainRepository, CostCenterMasterMainRepository>();
            services.AddTransient<IHolidayMasterViewRepository, HolidayMasterViewRepository>();
            services.AddTransient<IHRMastersViewRepository, HRMastersViewRepository>();
            services.AddTransient<IHRMastersQueryReportsViewRepository, HRMastersQueryReportsViewRepository>();
            services.AddTransient<IHRMastersReportsViewRepository, HRMastersReportsViewRepository>();
            services.AddTransient<IEmployeeMasterDataTableListViewRepository, EmployeeMasterDataTableListViewRepository>();
            services.AddTransient<IEmployeeMasterDataTableListExcelViewRepository, EmployeeMasterDataTableListExcelViewRepository>();
            services.AddTransient<ICostcodeListDataTableListRepository, CostcodeListDataTableListRepository>();

            services.AddTransient<ICommonEmployeeDetailsRepository, CommonEmployeeDetailsRepository>();

            services.AddTransient<ISelectTcmPLPagingRepository, SelectTcmPLPagingRepository>();
            services.AddTransient<IVppConfigPremiumDataTableListRepository, VppConfigPremiumDataTableListRepository>();

            #endregion View

            #region Exec

            services.AddTransient<IEmployeeMasterRepository, EmployeeMasterRepository>();
            services.AddTransient<IEmployeeImportRepository, EmployeeImportRepository>();
            services.AddTransient<ICostCenterMasterRepository, CostCenterMasterRepository>();
            services.AddTransient<IHolidayMasterRepository, HolidayMasterRepository>();
            services.AddTransient<IHRMastersRepository, HRMastersRepository>();
            services.AddTransient<IHRUtilitiesRepository, HRUtilitiesRepository>();
            services.AddTransient<IDmsUser, DmsUserRepository>();

            #endregion Exec

            #region Exec HRMasters

            services.AddTransient<IEmployeeDeleteRepository, EmployeeDeleteRepository>();
            services.AddTransient<IHRMastersCustomImportRepository, HRMastersCustomImportRepository>();

            #endregion Exec HRMasters

            #region View HRMasters

            services.AddTransient<IEmployeeDeleteDataTableListRepository, EmployeeDeleteDataTableListRepository>();

            #endregion View HRMasters

            #region HRMIS View Repositories

            services.AddTransient<IInternalTransfersDataTableListRepository, InternalTransfersDataTableListRepository>();
            services.AddTransient<IInternalTransfersXLDataTableListRepository, InternalTransfersXLDataTableListRepository>();
            services.AddTransient<IProspectiveEmployeesDataTableListRepository, ProspectiveEmployeesDataTableListRepository>();
            services.AddTransient<IProspectiveEmployeesXLDataTableListRepository, ProspectiveEmployeesXLDataTableListRepository>();
            services.AddTransient<IResignedEmployeeDataTableListRepository, ResignedEmployeeDataTableListRepository>();
            services.AddTransient<IResignedEmployeeXLDataTableListRepository, ResignedEmployeeXLDataTableListRepository>();

            #endregion HRMIS View Repositories

            #region HRMIS Exec Repositories

            services.AddTransient<IInternalTransferRepository, InternalTransferRepository>();
            services.AddTransient<IInternalTransferDetailRepository, InternalTransferDetailRepository>();
            services.AddTransient<IProspectiveEmployeesRepository, ProspectiveEmployeesRepository>();
            services.AddTransient<IProspectiveEmployeesDetailRepository, ProspectiveEmployeesDetailRepository>();
            services.AddTransient<IEmployeeDetailRepository, EmployeeDetailRepository>();
            services.AddTransient<IResignedEmployeeRepository, ResignedEmployeeRepository>();
            services.AddTransient<IResignedEmployeeDetailRepository, ResignedEmployeeDetailRepository>();

            #endregion HRMIS Exec Repositories

            #region EmpOfficeLocation View Repositories

            services.AddTransient<IEmpOfficeLocationDataTableListRepository, EmpOfficeLocationDataTableListRepository>();
            services.AddTransient<IEmpOfficeLocationXLDataTableListRepository, EmpOfficeLocationXLDataTableListRepository>();
            services.AddTransient<IEmpOfficeLocationHistoryDataTableListRepository, EmpOfficeLocationHistoryDataTableListRepository>();

            #endregion EmpOfficeLocation View Repositories

            #region EmpOfficeLocation Exec Repositories

            services.AddTransient<IEmpOfficeLocationDetailRepository, EmpOfficeLocationDetailRepository>();
            services.AddTransient<IEmpOfficeLocationRepository, EmpOfficeLocationRepository>();
            services.AddTransient<IEmpOfficeLocationImportRepository, EmpOfficeLocationImportRepository>();

            #endregion EmpOfficeLocation Exec Repositories

            #region Attendance View Repositories

            services.AddTransient<IAttendanceLeaveApplicationsDataTableListRepository, AttendanceLeaveApplicationsDataTableListRepository>();
            services.AddTransient<IAttendanceLeaveLedgerDataTableListRepository, AttendanceLeaveLedgerDataTableListRepository>();
            services.AddTransient<IAttendanceLeavesAvailedDataTableListRepository, AttendanceLeavesAvailedDataTableListRepository>();
            services.AddTransient<IAttendanceLeaveClaimsDataTableListRepository, AttendanceLeaveClaimsDataTableListRepository>();
            services.AddTransient<IAttendanceOnDutyApplicationsDataTableListRepository, AttendanceOnDutyApplicationsDataTableListRepository>();
            services.AddTransient<IAttendanceExtraHoursApprovalDataTableListRepository, AttendanceExtraHoursApprovalDataTableListRepository>();
            services.AddTransient<IAttendanceGuestAttendanceDataTableListRepository, AttendanceGuestAttendanceDataTableListRepository>();
            services.AddTransient<IAttendanceHolidayAttendanceDataTableListRepository, AttendanceHolidayAttendanceDataTableListRepository>();

            services.AddTransient<IAttendanceOnDutyApprovalDataTableListRepository, AttendanceOnDutyApprovalDataTableListRepository>();
            services.AddTransient<IAttendanceLeaveApprovalDataTableListRepository, AttendanceLeaveApprovalDataTableListRepository>();

            services.AddTransient<IAttendancePunchDetailsDataTableListRepository, AttendancePunchDetailsDataTableListRepository>();
            services.AddTransient<IAttendancePunchDetailsDayPunchListRepository, AttendancePunchDetailsDayPunchListRepository>();

            services.AddTransient<IAttendanceExtraHoursDataTableListRepository, AttendanceExtraHoursDataTableListRepository>();
            services.AddTransient<IAttendanceExtraHoursDetailDataTableListRepository, AttendanceExtraHoursDetailDataTableListRepository>();

            services.AddTransient<IAttendancePrintLogDataTableListRepository, AttendancePrintLogDataTableListRepository>();

            services.AddTransient<IAttendanceEmployeeDetailsRepository, AttendanceEmployeeDetailsRepository>();
            services.AddTransient<IAttendanceHolidayApprovalDataTableListRepository, AttendanceHolidayApprovalDataTableListRepository>();
            services.AddTransient<ILeaveCalendarDataTableListRepository, LeaveCalendarDataTableListRepository>();
            services.AddTransient<ILoPForExcessLeaveDataTableListRepository, LoPForExcessLeaveDataTableListRepository>();
            services.AddTransient<IAttendanceFlexiPunchDetailsDataTableListRepository, AttendanceFlexiPunchDetailsDataTableListRepository>();
            services.AddTransient<IShiftDataTableListRepository, ShiftDataTableListRepository>();

            services.AddTransient<IExtraHoursFlexiApprovalDataTableListRepository, ExtraHoursFlexiApprovalDataTableListRepository>();
            services.AddTransient<IExtraHoursFlexiDataTableListRepository, ExtraHoursFlexiDataTableListRepository>();
            services.AddTransient<IExtraHoursFlexiDetailDataTableListRepository, ExtraHoursFlexiDetailDataTableListRepository>();
            services.AddTransient<ILeaveCalendarHoDExcelDataTableListRepository, LeaveCalendarHoDExcelDataTableListRepository>();

            #endregion Attendance View Repositories

            #region Attendance Exec Repositories

            services.AddTransient<IAttendanceLeaveCreateRepository, AttendanceLeaveCreateRepository>();
            services.AddTransient<IAttendanceLeaveValidateRepository, AttendanceLeaveValidateRepository>();
            services.AddTransient<IAttendanceLeaveDetailsRepository, AttendanceLeaveDetailsRepository>();
            services.AddTransient<IAttendanceLeaveDetailsSLRepository, AttendanceLeaveDetailsSLRepository>();
            services.AddTransient<IAttendanceLeaveDeleteRepository, AttendanceLeaveDeleteRepository>();

            services.AddTransient<IAttendanceLeaveLedgerBalance, AttendanceLeaveLedgerBalance>();

            services.AddTransient<IAttendanceOnDutyCreateRepository, AttendanceOnDutyCreateRepository>();
            services.AddTransient<IAttendanceOnDutyDetailsRepository, AttendanceOnDutyDetailsRepository>();
            services.AddTransient<IAttendanceOnDutyDeleteRepository, AttendanceOnDutyDeleteRepository>();

            services.AddTransient<IAttendanceOnDutyApprovalRepository, AttendanceOnDutyApprovalRepository>();
            services.AddTransient<IAttendanceLeaveApprovalRepository, AttendanceLeaveApprovalRepository>();
            services.AddTransient<IAttendanceExtraHoursApprovalRepository, AttendanceExtraHoursApprovalRepository>();
            services.AddTransient<IAttendanceExtraHoursAdjustmentRepository, AttendanceExtraHoursAdjustmentRepository>();

            services.AddTransient<IAttendanceLeaveClaimCreateRepository, AttendanceLeaveClaimCreateRepository>();
            services.AddTransient<IAttendanceLeaveClaimImportRepository, AttendanceLeaveClaimImportRepository>();

            services.AddTransient<IAttendanceGuestAttendanceDetailsRepository, AttendanceGuestAttendanceDetailsRepository>();
            services.AddTransient<IAttendanceGuestAttendanceCreateRepository, AttendanceGuestAttendanceCreateRepository>();
            services.AddTransient<IAttendanceGuestAttendanceDeleteRepository, AttendanceGuestAttendanceDeleteRepository>();

            services.AddTransient<IAttendanceHolidayAttendanceDetailsRepository, AttendanceHolidayAttendanceDetailsRepository>();
            services.AddTransient<IAttendanceHolidayAttendanceCreateRepository, AttendanceHolidayAttendanceCreateRepository>();
            services.AddTransient<IAttendanceHolidayAttendanceDeleteRepository, AttendanceHolidayAttendanceDeleteRepository>();
            services.AddTransient<IAttendanceHolidayApprovalRepository, AttendanceHolidayApprovalRepository>();

            services.AddTransient<IAttendanceExtraHoursClaimCreateRepository, AttendanceExtraHoursClaimCreateRepository>();
            services.AddTransient<IAttendanceExtraHoursClaimDeleteRepository, AttendanceExtraHoursClaimDeleteRepository>();
            services.AddTransient<IAttendanceExtraHoursClaimDetailsRepository, AttendanceExtraHoursClaimDetailsRepository>();
            services.AddTransient<IAttendanceExtrahoursClaimExistsRepository, AttendanceExtrahoursClaimExistsRepository>();

            services.AddTransient<IAttendancePunchUploadRepository, AttendancePunchUploadRepository>();
            services.AddTransient<IAttendanceEmpCardRFIDUploadRepository, AttendanceEmpCardRFIDUploadRepository>();

            services.AddTransient<IAttendanceDeskDetailsRepository, AttendanceDeskDetailsRepository>();

            services.AddTransient<IAttendanceActionsExecutor, AttendanceActionsExecutor>();
            services.AddTransient<IAttendanceActionsExecuteReport, AttendanceActionsExecuteReport>();
            services.AddTransient<IAttendancePLAvailedReport, AttendancePLAvailedReport>();
            services.AddTransient<ILoPForExcessLeaveRepository, LoPForExcessLeaveRepository>();
            services.AddTransient<ILoPForExcessLeaveImportRepository, LoPForExcessLeaveImportRepository>();
            services.AddTransient<ILoPLastSalaryMonthDetailsRepository, LoPLastSalaryMonthDetailsRepository>();
            services.AddTransient<ILoPLastSalaryMonthStatusRepository, LoPLastSalaryMonthStatusRepository>();
            services.AddTransient<IShiftMasterRepository, ShiftMasterRepository>();
            services.AddTransient<IShiftDetailRepository, ShiftDetailRepository>();
            services.AddTransient<IShiftConfigDetailRepository, ShiftConfigDetailRepository>();
            services.AddTransient<IShiftLunchConfigDetailRepository, ShiftLunchConfigDetailRepository>();
            services.AddTransient<IShiftHalfDayConfigDetailRepository, ShiftHalfDayConfigDetailRepository>();

            services.AddTransient<IFilterRepository, FilterRepository>();

            services.AddTransient<IExtraHoursFlexiAdjustmentRepository, ExtraHoursFlexiAdjustmentRepository>();
            services.AddTransient<IExtraHoursFlexiApprovalRepository, ExtraHoursFlexiApprovalRepository>();
            services.AddTransient<IExtraHoursFlexiClaimCreateRepository, ExtraHoursFlexiClaimCreateRepository>();
            services.AddTransient<IExtraHoursFlexiClaimDeleteRepository, ExtraHoursFlexiClaimDeleteRepository>();
            services.AddTransient<IExtraHoursFlexiClaimDetailsRepository, ExtraHoursFlexiClaimDetailsRepository>();
            services.AddTransient<IExtraHoursFlexiClaimExistsRepository, ExtraHoursFlexiClaimExistsRepository>();

            #endregion Attendance Exec Repositories

            #region SWP View Repositories

            services.AddTransient<ISWPPrimaryWorkSpaceDataTableListRepository, SWPPrimaryWorkSpaceDataTableListRepository>();
            services.AddTransient<ISWPSmartWorkSpaceDataTableListRepository, SWPSmartWorkSpaceDataTableListRepository>();
            services.AddTransient<ISWPOfficeAtndDataTableListRepository, SWPOfficeAtndDataTableListRepository>();
            services.AddTransient<ISWPPrimaryWorkSpaceExcelDataTableListRepository, SWPPrimaryWorkSpaceExcelDataTableListRepository>();
            services.AddTransient<ISWPSmartWorkSpaceExcelDataTableListRepository, SWPSmartWorkSpaceExcelDataTableListRepository>();

            services.AddTransient<ISWPEmployeeProjectMappingDataTableListRepository, SWPEmployeeProjectMappingDataTableListRepository>();
            services.AddTransient<IDMSAsset2HomeDataTableListRepository, DMSAsset2HomeDataTableListRepository>();
            services.AddTransient<IDMSAsset2HomeDetailRepository, DMSAsset2HomeDetailRepository>();
            services.AddTransient<IDMSOrphanAssetDataTableListRepository, DMSOrphanAssetDataTableListRepository>();
            services.AddTransient<IDMSOrphanAssetDetailRepository, DMSOrphanAssetDetailRepository>();
            services.AddTransient<ISWPEmployeeWorkspaceRepository, SWPEmployeeWorkspaceRepository>();
            services.AddTransient<IEmployeeWorkSpaceDataTableListRepository, EmployeeWorkSpaceDataTableListRepository>();
            services.AddTransient<INonSWSEmpAtHomeDataTableListRepository, NonSWSEmpAtHomeDataTableListRepository>();
            services.AddTransient<ISWPDMSDeskAllocationSWPDataTableListRepository, SWPDMSDeskAllocationSWPDataTableListRepository>();

            services.AddTransient<ISWPSmartWorkspaceEmpPresentDataTableListRepository, SWPSmartWorkspaceEmpPresentDataTableListRepository>();
            services.AddTransient<ISWPOfficeWorkspaceEmpAbsentDataTableListRepository, SWPOfficeWorkspaceEmpAbsentDataTableListRepository>();

            services.AddTransient<IExcludeEmployeeDataTableListRepository, ExcludeEmployeeDataTableListRepository>();
            services.AddTransient<IExcludeEmployeeExcelDataTableListRepository, ExcludeEmployeeExcelDataTableListRepository>();
            services.AddTransient<IFutureEmpComingToOfficeDataTableListRepository, FutureEmpComingToOfficeDataTableListRepository>();
            services.AddTransient<ISWPAttendanceStatusDataTableListRepository, SWPAttendanceStatusDataTableListRepository>();
            services.AddTransient<ISWPAttendanceStatusForDayDataTableListRepository, SWPAttendanceStatusForDayDataTableListRepository>();
            services.AddTransient<ISWPAttendanceStatusDatesDataTableListRepository, SWPAttendanceStatusDatesDataTableListRepository>();
            services.AddTransient<ISWPAttendanceStatusSubContractDataTableListRepository, SWPAttendanceStatusSubContractDataTableListRepository>();

            services.AddTransient<ISWPAttendanceStatusForMonthDataTableListRepository, SWPAttendanceStatusForMonthDataTableListRepository>();
            services.AddTransient<ISWPAttendanceStatusWeekNamesDataTableListRepository, SWPAttendanceStatusWeekNamesDataTableListRepository>();

            services.AddTransient<ISWPPrimaryWorkSpaceAdminDataTableListRepository, SWPPrimaryWorkSpaceAdminDataTableListRepository>();
            services.AddTransient<ISWPAssignCostCodesDataTableListRepository, SWPAssignCostCodesDataTableListRepository>();

            services.AddTransient<ISWPEmployeesDataTableListRepository, SWPEmployeesDataTableListRepository>();

            #endregion SWP View Repositories

            #region SWP Exec Repositories

            services.AddTransient<ISWPPlanningStatusRepository, SWPPlanningStatusRepository>();
            services.AddTransient<ISWPPlanningStatusDeptRepository, SWPPlanningStatusDeptRepository>();
            services.AddTransient<ISWPPrimaryWorkSpaceRepository, SWPPrimaryWorkSpaceRepository>();
            services.AddTransient<ISWPEmployeeOfficeWorkspaceRepository, SWPEmployeeOfficeWorkspaceRepository>();
            services.AddTransient<ISWPHeaderStatusForSmartWorkspaceRepository, SWPHeaderStatusForSmartWorkspaceRepository>();
            services.AddTransient<ISWPHeaderStatusForPrimaryWorkSpaceRepository, SWPHeaderStatusForPrimaryWorkSpaceRepository>();

            services.AddTransient<ISWPEmployeeProjectCreateRepository, SWPEmployeeProjectCreateRepository>();
            services.AddTransient<ISWPEmployeeProjectUpdateRepository, SWPEmployeeProjectUpdateRepository>();
            services.AddTransient<ISWPEmployeeProjectDeleteRepository, SWPEmployeeProjectDeleteRepository>();
            services.AddTransient<IDMSOrphanAssetUpdateRepository, DMSOrphanAssetUpdateRepository>();
            services.AddTransient<IDMSAsset2HomeUpdateRepository, DMSAsset2HomeUpdateRepository>();

            services.AddTransient<ISWPFlagsRepository, SWPFlagsRepository>();
            services.AddTransient<ISWPFlagsGenericRepository, SWPFlagsGenericRepository>();

            services.AddTransient<IExcludeEmployeeRepository, ExcludeEmployeeRepository>();
            services.AddTransient<IExcludeEmployeeDetails, ExcludeEmployeeDetails>();
            services.AddTransient<IEmployeeProjectMappingDetails, EmployeeProjectMappingDetails>();
            services.AddTransient<IFutureEmpComingToOfficeRepository, FutureEmpComingToOfficeRepository>();
            services.AddTransient<IFutureEmpComingToOfficeDeleteRepository, FutureEmpComingToOfficeDeleteRepository>();

            #endregion SWP Exec Repositories

            #region LC View Repositories

            //services.AddTransient<IBankDetailsRepository, BankDetailsRepository>();
            //services.AddTransient<ICurrencyDetailsRepository, CurrencyDetailsRepository>();
            //services.AddTransient<IVendorDetailsRepository, VendorDetailsRepository>();
            //services.AddTransient<IBankDataTableListRepository, BankDataTableListRepository>();
            //services.AddTransient<ICurrencyDataTableListRepository, CurrencyDataTableListRepository>();
            //services.AddTransient<IVendorDataTableListRepository, VendorDataTableListRepository>();

            //services.AddTransient<IAfcLcMainDataTableListRepository, AfcLcMainDataTableListRepository>();
            //services.AddTransient<IAfcLcMainExcelDataTableListRepository, AfcLcMainExcelDataTableListRepository>();
            //services.AddTransient<ILcMainPoSapInvoiceDataTableListRepository, LcMainPoSapInvoiceDataTableListRepository>();
            //services.AddTransient<ILcAmountDataTableListRepository, LcAmountDataTableListRepository>();
            //services.AddTransient<ILcChargesDataTableListRepository, LcChargesDataTableListRepository>();
            //services.AddTransient<ILcLiveStatusDataTableListRepository, LcLiveStatusDataTableListRepository>();
            //services.AddTransient<ILcMainDetailsRepository, LcMainDetailsRepository>();
            //services.AddTransient<ILcBankDetailsRepository, LcBankDetailsRepository>();
            //services.AddTransient<ILcChargesDetailsRepository, LcChargesDetailsRepository>();
            //services.AddTransient<ILcAcceptanceDetailsRepository, LcAcceptanceDetailsRepository>();
            //services.AddTransient<ILcAmountDetailsRepository, LcAmountDetailsRepository>();

            #endregion LC View Repositories

            #region LC Exec Repositories

            //services.AddTransient<ILCMastersRepository, LCMastersRepository>();
            //services.AddTransient<ILCRepository, LCRepository>();

            #endregion LC Exec Repositories

            #region BG View Repositories

            //services.AddTransient<IBGAmendmentDataTableListRepository, BGAmendmentDataTableListRepository>();
            //services.AddTransient<IBGMasterDataTableListRepository, BGMasterDataTableListRepository>();
            //services.AddTransient<IBGAcceptableMasterDataTableListRepository, BGAcceptableMasterDataTableListRepository>();
            //services.AddTransient<IBGBankMasterDataTableListRepository, BGBankMasterDataTableListRepository>();
            //services.AddTransient<IBGCompanyMasterDataTableListRepository, BGCompanyMasterDataTableListRepository>();
            //services.AddTransient<IBGCurrencyMasterDataTableListRepository, BGCurrencyMasterDataTableListRepository>();
            //services.AddTransient<IBGGuaranteeTypeMasterDataTableListRepository, BGGuaranteeTypeMasterDataTableListRepository>();
            //services.AddTransient<IBGPayableMasterDataTableListRepository, BGPayableMasterDataTableListRepository>();
            //services.AddTransient<IBGProjectMasterDataTableListRepository, BGProjectMasterDataTableListRepository>();

            //services.AddTransient<IBGProjectControlMasterDataTableListRepository, BGProjectControlMasterDataTableListRepository>();
            //services.AddTransient<IBGProjectDriMasterDataTableListRepository, BGProjectDriMasterDataTableListRepository>();
            //services.AddTransient<IBGVendorTypeMasterDataTableListRepository, BGVendorTypeMasterDataTableListRepository>();
            //services.AddTransient<IBGVendorMasterDataTableListRepository, BGVendorMasterDataTableListRepository>();

            //services.AddTransient<IBGAmendmentDetailRepository, BGAmendmentDetailRepository>();
            //services.AddTransient<IBGAmendmentStatusDetailRepository, BGAmendmentStatusDetailRepository>();
            //services.AddTransient<IBGMasterDetailRepository, BGMasterDetailRepository>();
            //services.AddTransient<IBGAcceptableMasterDetailRepository, BGAcceptableMasterDetailRepository>();
            //services.AddTransient<IBGBankMasterDetailRepository, BGBankMasterDetailRepository>();
            //services.AddTransient<IBGCompanyMasterDetailRepository, BGCompanyMasterDetailRepository>();
            //services.AddTransient<IBGCurrencyMasterDetailRepository, BGCurrencyMasterDetailRepository>();
            //services.AddTransient<IBGGuaranteeTypeMasterDetailRepository, BGGuaranteeTypeMasterDetailRepository>();
            //services.AddTransient<IBGPayableMasterDetailRepository, BGPayableMasterDetailRepository>();
            //services.AddTransient<IBGProjectMasterDetailRepository, BGProjectMasterDetailRepository>();
            //services.AddTransient<IBGRecipientsDataTableListRepository, BGRecipientsDataTableListRepository>();
            //services.AddTransient<IBGPPCMasterDataTableListRepository, BGPPCMasterDataTableListRepository>();
            //services.AddTransient<IBGPPMMasterDataTableListRepository, BGPPMMasterDataTableListRepository>();

            //services.AddTransient<IBGProjectControlMasterDetailRepository, BGProjectControlMasterDetailRepository>();
            //services.AddTransient<IBGPPCMasterDetailRepository, BGPPCMasterDetailRepository>();
            //services.AddTransient<IBGPPMMasterDetailRepository, BGPPMMasterDetailRepository>();
            //services.AddTransient<IBGProjectDriMasterDetailRepository, BGProjectDriMasterDetailRepository>();
            //services.AddTransient<IBGVendorTypeMasterDetailRepository, BGVendorTypeMasterDetailRepository>();
            //services.AddTransient<IBGVendorMasterDetailRepository, BGVendorMasterDetailRepository>();

            #endregion BG View Repositories

            #region BG Exec Repositories

            //services.AddTransient<IBGAmendmentRepository, BGAmendmentRepository>();
            //services.AddTransient<IBGAmendmentStatusRepository, BGAmendmentStatusRepository>();
            //services.AddTransient<IBGMasterRepository, BGMasterRepository>();
            //services.AddTransient<IBGAcceptableMasterRepository, BGAcceptableMasterRepository>();
            //services.AddTransient<IBGBankMasterRepository, BGBankMasterRepository>();
            //services.AddTransient<IBGCompanyMasterRepository, BGCompanyMasterRepository>();
            //services.AddTransient<IBGCurrencyMasterRepository, BGCurrencyMasterRepository>();
            //services.AddTransient<IBGCurrencyMasterRepository, BGCurrencyMasterRepository>();
            //services.AddTransient<IBGGuaranteeTypeMasterRepository, BGGuaranteeTypeMasterRepository>();
            //services.AddTransient<IBGPayableMasterRepository, BGPayableMasterRepository>();
            //services.AddTransient<IBGProjectMasterRepository, BGProjectMasterRepository>();

            //services.AddTransient<IBGProjectControlMasterRepository, BGProjectControlMasterRepository>();
            //services.AddTransient<IBGProjectDriMasterRepository, BGProjectDriMasterRepository>();
            //services.AddTransient<IBGVendorTypeMasterRepository, BGVendorTypeMasterRepository>();
            //services.AddTransient<IBGVendorMasterRepository, BGVendorMasterRepository>();
            //services.AddTransient<IBGPPCMasterRepository, BGPPCMasterRepository>();
            //services.AddTransient<IBGPPMMasterRepository, BGPPMMasterRepository>();

            #endregion BG Exec Repositories

            #region DMS View Repositories

            services.AddTransient<IDMSEmployeeRepository, DMSEmployeeRepository>();
            services.AddTransient<IDeskMasterDataTableListRepository, DeskMasterDataTableListRepository>();
            services.AddTransient<IDeskMasterViewRepository, DeskMasterViewRepository>();

            services.AddTransient<IBayDataTableListRepository, BayDataTableListRepository>();
            services.AddTransient<IDeskAreaCategoriesDataTableListRepository, DeskAreaCategoriesDataTableListRepository>();
            services.AddTransient<IDeskAreaDataTableListRepository, DeskAreaDataTableListRepository>();
            services.AddTransient<IDeskMasterDataTableListRepository, DeskMasterDataTableListRepository>();
            services.AddTransient<IAssetsOnDeskDataTableListRepository, AssetsOnDeskDataTableListRepository>();
            services.AddTransient<IEmployeeAssetsDataTableListRepository, EmployeeAssetsDataTableListRepository>();
            services.AddTransient<IInvItemTypesDataTableListRepository, InvItemTypesDataTableListRepository>();
            services.AddTransient<IInvItemCategoryDataTableListRepository, InvItemCategoryDataTableListRepository>();
            services.AddTransient<IInvItemAsgmtTypesDataTableListRepository, InvItemAsgmtTypesDataTableListRepository>();
            services.AddTransient<IInvItemAMSAssetMappingDataTableListRepository, InvItemAMSAssetMappingDataTableListRepository>();

            services.AddTransient<IInvEmployeeTransactionDataTableListRepository, InvEmployeeTransactionDataTableListRepository>();
            services.AddTransient<IInvTransactionDataTableListRepository, InvTransactionDataTableListRepository>();
            services.AddTransient<IInvTransactionDataTableListExcelRepository, InvTransactionDataTableListExcelRepository>();
            services.AddTransient<IInvTransactionDetailDataTableListRepository, InvTransactionDetailDataTableListRepository>();
            services.AddTransient<IInvEmployeeDetailsRepository, InvEmployeeDetailsRepository>();
            services.AddTransient<IInvEmployeeTransactionDetailDataTableListRepository, InvEmployeeTransactionDetailDataTableListRepository>();

            services.AddTransient<IInvItemAddOnDataTableListRepository, InvItemAddOnDataTableListRepository>();

            services.AddTransient<IInvConsumablesDataTableListRepository, InvConsumablesDataTableListRepository>();
            services.AddTransient<IInvConsumablesDetailDataTableListRepository, InvConsumablesDetailDataTableListRepository>();

            services.AddTransient<IInvItemGroupDataTableListRepository, InvItemGroupDataTableListRepository>();
            services.AddTransient<IInvItemGroupDetailDataTableListRepository, InvItemGroupDetailDataTableListRepository>();

            services.AddTransient<IInvLaptopLotwiseDataTableListExcelRepository, InvLaptopLotwiseDataTableListExcelRepository>();

            services.AddTransient<IMovementsDataTableListRepository, MovementsDataTableListRepository>();
            services.AddTransient<IMovementsSelectedDeskDataTableListRepository, MovementsSelectedDeskDataTableListRepository>();
            services.AddTransient<IFlexiToDMSDataTableListRepository, FlexiToDMSDataTableListRepository>();

            services.AddTransient<IMovementAssignmentDataTableListRepository, MovementAssignmentDataTableListRepository>();
            services.AddTransient<IDMSGuestMasterDataTableListRepository, DMSGuestMasterDataTableListRepository>();
            services.AddTransient<IDeskManagementStatusDataTableLisRepository, DeskManagementStatusDataTableLisRepository>();
            services.AddTransient<IDeskManagementWorkloadDataTableLisRepository, DeskManagementWorkloadDataTableLisRepository>();

            services.AddTransient<IAssetOnHoldActionTransDataTableListRepository, AssetOnHoldActionTransDataTableListRepository>();
            services.AddTransient<IAssetOnHoldAssetAddDataTableListRepository, AssetOnHoldAssetAddDataTableListRepository>();

            services.AddTransient<IAssetDistributionDataTableListRepository, AssetDistributionDataTableListRepository>();
            services.AddTransient<IEmployeeAssetStatusDataTableListRepository, EmployeeAssetStatusDataTableListRepository>();

            services.AddTransient<IAssetWithITPoolDataTableListRepository, AssetWithITPoolDataTableListRepository>();
            services.AddTransient<IDeskBlockDataTableListRepository, DeskBlockDataTableListRepository>();
            services.AddTransient<IDeskBlockDetailRepository, DeskBlockDetailRepository>();

            services.AddTransient<IInvAddOnContainerDataTableListRepository, InvAddOnContainerDataTableListRepository>();
            services.AddTransient<INewEmployeeDataTableListRepository, NewEmployeeDataTableListRepository>();
            services.AddTransient<ILaptopLotWiseDataTableListRepository, LaptopLotWiseDataTableListRepository>();
            services.AddTransient<IOfficeDataTableListRepository, OfficeDataTableListRepository>();
            services.AddTransient<IDeskAreaOfficeMapDataTableListRepository, DeskAreaOfficeMapDataTableListRepository>();
            services.AddTransient<IDeskAreaDepartmentMapDataTableListRepository, DeskAreaDepartmentMapDataTableListRepository>();
            services.AddTransient<IDeskAreaProjectMapDataTableListRepository, DeskAreaProjectMapDataTableListRepository>();
            services.AddTransient<IDmAreaTypeDataTableListRepository, DmAreaTypeDataTableListRepository>();
            services.AddTransient<IDeskAreaUserMapDataTableListRepository, DeskAreaUserMapDataTableListRepository>();
            services.AddTransient<IDeskAreaEmployeeMapDataTableListRepository, DeskAreaEmployeeMapDataTableListRepository>();
            services.AddTransient<IDeskAreaEmpAreaTypeMapDataTableListRepository, DeskAreaEmpAreaTypeMapDataTableListRepository>();
            services.AddTransient<IDeskAreaDepartmentDataTableListRepository, DeskAreaDepartmentDataTableListRepository>();
            services.AddTransient<IDeskAreaProjectDataTableListRepository, DeskAreaProjectDataTableListRepository>();
            services.AddTransient<ITagObjectMapDataTableListRepository, TagObjectMapDataTableListRepository>();
            services.AddTransient<IDMSReportDataTableListRepository, DMSReportDataTableListRepository>();
            services.AddTransient<IInvItemNotInServiceDataTableListRepository, InvItemNotInServiceDataTableListRepository>();
            services.AddTransient<IExcludeDataTableListRepository, ExcludeDataTableListRepository>();
            services.AddTransient<IAiroliEmpInDmUsermasterDataTableListRepository, AiroliEmpInDmUsermasterDataTableListRepository>();
            services.AddTransient<IOfficeDeskStatusDataListRepository, OfficeDeskStatusDataListRepository>();
            services.AddTransient<IAssetMapWithEmpDataTableListRepository, AssetMapWithEmpDataTableListRepository>();
            services.AddTransient<IDesksDataTableListRepository, DesksDataTableListRepository>();
            services.AddTransient<IDeskAndEmpDetailDataTableListRepository, DeskAndEmpDetailDataTableListRepository>();
            services.AddTransient<IEmpDeskInMoreThanPlacesDataTableListRepository, EmpDeskInMoreThanPlacesDataTableListRepository>();

            #endregion DMS View Repositories

            #region DMS Exec Repositories

            services.AddTransient<IDeskMasterRepository, DeskMasterRepository>();
            services.AddTransient<IDMSAsset2HomeRepository, DMSAsset2HomeRepository>();
            services.AddTransient<IDMSRepository, DMSRepository>();

            services.AddTransient<IBayDetailRepository, BayDetailRepository>();
            services.AddTransient<IBayRepository, BayRepository>();
            services.AddTransient<IDeskAreaCategoriesDetailRepository, DeskAreaCategoriesDetailRepository>();
            services.AddTransient<IDeskAreaCategoriesRepository, DeskAreaCategoriesRepository>();
            services.AddTransient<IDeskAreaDetailRepository, DeskAreaDetailRepository>();
            services.AddTransient<IDeskAreaRepository, DeskAreaRepository>();
            services.AddTransient<IDeskMasterDetailRepository, DeskMasterDetailRepository>();
            services.AddTransient<IDeskMasterRepository, DeskMasterRepository>();
            services.AddTransient<IAssetsOnDeskRepository, AssetsOnDeskRepository>();
            services.AddTransient<IDeskAsgmtMasterDetailRepository, DeskAsgmtMasterDetailRepository>();

            services.AddTransient<IInvItemTypesDetailRepository, InvItemTypesDetailRepository>();
            services.AddTransient<IInvItemTypesRepository, InvItemTypesRepository>();

            services.AddTransient<IInvItemCategoryRepository, InvItemCategoryRepository>();
            services.AddTransient<IInvItemCategoryDetailRepository, InvItemCategoryDetailRepository>();

            services.AddTransient<IInvItemAsgmtTypesRepository, InvItemAsgmtTypesRepository>();
            services.AddTransient<IInvItemAsgmtTypesDetailRepository, InvItemAsgmtTypesDetailRepository>();

            services.AddTransient<IInvItemAMSAssetMappingRepository, InvItemAMSAssetMappingRepository>();
            services.AddTransient<IInvItemAMSAssetMappingDetailRepository, InvItemAMSAssetMappingDetailRepository>();

            services.AddTransient<IInvTransactionRepository, InvTransactionRepository>();
            services.AddTransient<IInvTransactionForIdRepository, InvTransactionForIdRepository>();
            services.AddTransient<IInvTransactionDetailsRepository, InvTransactionDetailsRepository>();

            services.AddTransient<IInvConsumablesImportRepository, InvConsumablesImportRepository>();
            services.AddTransient<IInvConsumablesDetailsRepository, InvConsumablesDetailsRepository>();

            services.AddTransient<IInvItemAddOnTransRepository, InvItemAddOnTransRepository>();

            services.AddTransient<IInvItemGroupImportRepository, InvItemGroupImportRepository>();
            services.AddTransient<IInvItemGroupDetailRepository, InvItemGroupDetailRepository>();

            services.AddTransient<IMovementsSelectedDeskRepository, MovementsSelectedDeskRepository>();
            services.AddTransient<IMovementsDeskAssignmentRepository, MovementsDeskAssignmentRepository>();
            services.AddTransient<IMovementsAssetAssignmentRepository, MovementsAssetAssignmentRepository>();
            services.AddTransient<IFlexiToDMSRepository, FlexiToDMSRepository>();

            services.AddTransient<IDMSGuestMasterRepository, DMSGuestMasterRepository>();
            services.AddTransient<IDMSGuestMasterDetailRepository, DMSGuestMasterDetailRepository>();

            services.AddTransient<IAssetOnHoldActionTransRepository, AssetOnHoldActionTransRepository>();
            services.AddTransient<IAssetOnHoldActionTransDetailRepository, AssetOnHoldActionTransDetailRepository>();

            services.AddTransient<IAssetOnHoldAssetAddRepository, AssetOnHoldAssetAddRepository>();
            services.AddTransient<IAssetOnHoldAssetAddDetailRepository, AssetOnHoldAssetAddDetailRepository>();

            services.AddTransient<IMovementsImportRepository, MovementsImportRepository>();
            services.AddTransient<IDeskBlockRepository, DeskBlockRepository>();

            services.AddTransient<IInvAddOnContainerRepository, InvAddOnContainerRepository>();
            services.AddTransient<INewEmployeeDetailRepository, NewEmployeeDetailRepository>();
            services.AddTransient<IOfficeRequestRepository, OfficeRequestRepository>();
            services.AddTransient<IOfficeDetailRepository, OfficeDetailRepository>();
            services.AddTransient<IDeskAreaOfficeMapDetailRepository, DeskAreaOfficeMapDetailRepository>();
            services.AddTransient<IDeskAreaOfficeMapRequestRepository, DeskAreaOfficeMapRequestRepository>();
            services.AddTransient<IDeskAreaDepartmentMapRequestRepository, DeskAreaDepartmentMapRequestRepository>();
            services.AddTransient<IDeskAreaDepartmentMapDetailRepository, DeskAreaDepartmentMapDetailRepository>();
            services.AddTransient<IDmAreaTypeDetailRepository, DmAreaTypeDetailRepository>();
            services.AddTransient<IDmAreaTypeRepository, DmAreaTypeRepository>();
            services.AddTransient<IDeskAreaProjectMapRepository, DeskAreaProjectMapRepository>();
            services.AddTransient<IDeskAreaProjectMapDetailRepository, DeskAreaProjectMapDetailRepository>();

            services.AddTransient<IDeskAreaUserMapRequestRepository, DeskAreaUserMapRequestRepository>();
            services.AddTransient<IDeskAreaUserMapDetailRepository, DeskAreaUserMapDetailRepository>();
            services.AddTransient<IDeskAreaEmployeeMapRepository, DeskAreaEmployeeMapRepository>();
            services.AddTransient<IDeskAreaEmployeeMapDetailRepository, DeskAreaEmployeeMapDetailRepository>();

            services.AddTransient<IDeskAreaEmpAreaTypeMapRequestRepository, DeskAreaEmpAreaTypeMapRequestRepository>();
            services.AddTransient<IDeskAreaEmpAreaTypeMapDetailRepository, DeskAreaEmpAreaTypeMapDetailRepository>();
            services.AddTransient<ITagObjectMapRepository, TagObjectMapRepository>();

            services.AddTransient<IDeskAreaDeskListImportRepository, DeskAreaDeskListImportRepository>();
            services.AddTransient<IDeskAreaUserListImportRepository, DeskAreaUserListImportRepository>();
            services.AddTransient<IAssetMasterDetailRepository, AssetMasterDetailRepository>();
            services.AddTransient<IInvItemGroupRepository, InvItemGroupRepository>();
            services.AddTransient<IExcludeRepository, ExcludeRepository>();
            services.AddTransient<IDmManagementRepository, DmManagementRepository>();
            services.AddTransient<IInvReserveItemsDetailsRepository, InvReserveItemsDetailsRepository>();
            services.AddTransient<ISetZoneDeskImportRepository, SetZoneDeskImportRepository>();

            #endregion DMS Exec Repositories

            #region HSE Exec Repositories

            services.AddTransient<IIncidentDetailRepository, IncidentDetailRepository>();
            services.AddTransient<IIncidentRepository, IncidentRepository>();
            services.AddTransient<IHSEQuizRepository, HSEQuizRepository>();
            services.AddTransient<IHSEQuizCounterDetailsRepository, HSEQuizCounterDetailsRepository>();
            services.AddTransient<IHSEQuizDetailsRepository, HSEQuizDetailsRepository>();

            #endregion HSE Exec Repositories

            #region HSE View Repositories

            services.AddTransient<IIncidentDataTableListRepository, IncidentDataTableListRepository>();
            services.AddTransient<IIncidentRecipientListRepository, IncidentRecipientListRepository>();
            services.AddTransient<IHSEQuizDataTableListRepository, HSEQuizDataTableListRepository>();

            #endregion HSE View Repositories

            #region ERS Exec Repositories

            services.AddTransient<IVacancyRepository, VacancyRepository>();
            services.AddTransient<IVacancyDetailRepository, VacancyDetailRepository>();
            services.AddTransient<IHRVacancyDetailRepository, HRVacancyDetailRepository>();
            services.AddTransient<IHRCVActionUpdateRepository, HRCVActionUpdateRepository>();
            services.AddTransient<IHRCVReferEmpDetailRepository, HRCVReferEmpDetailRepository>();
            services.AddTransient<IHRCVDetailRepository, HRCVDetailRepository>();

            #endregion ERS Exec Repositories

            #region ERS View Repositories

            services.AddTransient<IUploadedCVDataTableListRepository, UploadedCVDataTableListRepository>();
            services.AddTransient<IVacanciesDataTableListRepository, VacanciesDataTableListRepository>();
            services.AddTransient<IHRUploadedCVDataTableListRepository, HRUploadedCVDataTableListRepository>();
            services.AddTransient<IHRUploadedCVDataTableExcelRepository, HRUploadedCVDataTableExcelRepository>();
            services.AddTransient<IHRVacanciesDataTableListRepository, HRVacanciesDataTableListRepository>();
            services.AddTransient<IHRVacanciesDataTableExcelRepository, HRVacanciesDataTableExcelRepository>();

            #endregion ERS View Repositories

            #region JOB Exec Repositories

            services.AddTransient<IJobmasterDetailRepository, JobmasterDetailRepository>();
            services.AddTransient<IJobmasterBudgetImportRepository, JobmasterBudgetImportRepository>();
            services.AddTransient<IJobPhaseRepository, JobPhaseRepository>();
            services.AddTransient<IJobMailListRepository, JobMailListRepository>();
            services.AddTransient<IJobPhaseDetailRepository, JobPhaseDetailRepository>();
            services.AddTransient<IJobEditRepository, JobEditRepository>();
            services.AddTransient<IJobPmJsDetailRepository, JobPmJsDetailRepository>();
            services.AddTransient<IJobPmJsRepository, JobPmJsRepository>();
            services.AddTransient<IJobNotesRepository, JobNotesRepository>();
            services.AddTransient<IJobNotesDetailRepository, JobNotesDetailRepository>();
            services.AddTransient<ITMAGroupsRepository, TMAGroupsRepository>();
            services.AddTransient<ITMAGroupsDetailRepository, TMAGroupsDetailRepository>();
            services.AddTransient<IJobResponsibleApproversDetailRepository, JobResponsibleApproversDetailRepository>();
            services.AddTransient<IJobResponsibleApproversRepository, JobResponsibleApproversRepository>();
            services.AddTransient<IBusinessLinesRepository, BusinessLinesRepository>();
            services.AddTransient<IBusinessLinesDetailRepository, BusinessLinesDetailRepository>();
            services.AddTransient<ISubBusinessLinesRepository, SubBusinessLinesRepository>();
            services.AddTransient<ISubBusinessLinesDetailRepository, SubBusinessLinesDetailRepository>();
            services.AddTransient<ISegmentsRepository, SegmentsRepository>();
            services.AddTransient<ISegmentsDetailRepository, SegmentsDetailRepository>();
            services.AddTransient<IScopeOfWorkRepository, ScopeOfWorkRepository>();
            services.AddTransient<IScopeOfWorkDetailRepository, ScopeOfWorkDetailRepository>();
            services.AddTransient<IPlantTypesRepository, PlantTypesRepository>();
            services.AddTransient<IPlantTypesDetailRepository, PlantTypesDetailRepository>();
            services.AddTransient<IProjectTypesRepository, ProjectTypesRepository>();
            services.AddTransient<IProjectTypesDetailRepository, ProjectTypesDetailRepository>();
            services.AddTransient<IJobApprovalRepository, JobApprovalRepository>();

            services.AddTransient<IJobApproverStatusDetailRepository, JobApproverStatusDetailRepository>();
            services.AddTransient<IJobsMasterRepository, JobsMasterRepository>();

            services.AddTransient<IJobErpPhasesFileDetailRepository, JobErpPhasesFileDetailRepository>();
            services.AddTransient<IJobErpPhasesFileRepository, JobErpPhasesFileRepository>();

            services.AddTransient<IJobCoMasterDetailRepository, JobCoMasterDetailRepository>();
            services.AddTransient<IJobCoMasterRepository, JobCoMasterRepository>();

            services.AddTransient<IJobValidateStatusRepository, JobValidateStatusRepository>();
            services.AddTransient<IClientRepository, ClientRepository>();

            #endregion JOB Exec Repositories

            #region JOB View Repositories

            services.AddTransient<IJobmasterDataTableListRepository, JobmasterDataTableListRepository>();
            services.AddTransient<IJobmasterBudgetApiRepository, JobmasterBudgetApiRepository>();
            services.AddTransient<IJobPhaseDataTableListRepository, JobPhaseDataTableListRepository>();
            services.AddTransient<IJobResponsibleApproversListRepository, JobResponsibleApproversListRepository>();
            services.AddTransient<IJobResponsibleActionsListRepository, JobResponsibleActionsListRepository>();
            services.AddTransient<ITMAGroupsDataTableListRepository, TMAGroupsDataTableListRepository>();
            services.AddTransient<IJobMailListDataTableListRepository, JobMailListDataTableListRepository>();
            services.AddTransient<IBusinessLinesDataTableListRepository, BusinessLinesDataTableListRepository>();
            services.AddTransient<ISubBusinessLinesDataTableListRepository, SubBusinessLinesDataTableListRepository>();
            services.AddTransient<ISegmentsDataTableListRepository, SegmentsDataTableListRepository>();
            services.AddTransient<IJobBudgetDataTableListRepository, JobBudgetDataTableListRepository>();
            services.AddTransient<IScopeOfWorkDataTableListRepository, ScopeOfWorkDataTableListRepository>();
            services.AddTransient<IPlantTypesDataTableListRepository, PlantTypesDataTableListRepository>();
            services.AddTransient<IProjectTypesDataTableListRepository, ProjectTypesDataTableListRepository>();
            services.AddTransient<IJobFormListReportExcelRepository, JobFormListReportExcelRepository>();
            services.AddTransient<IJobCoMasterDataTableListRepository, JobCoMasterDataTableListRepository>();

            #endregion JOB View Repositories

            #region Rap Reporting View Repositories

            services.AddTransient<ICostcodeGroupCostcodeDataTableListRepository, CostcodeGroupCostcodeDataTableListRepository>();
            services.AddTransient<IRapReportingReportsRepository, RapReportingReportsRepository>();
            services.AddTransient<IExpectedJobsDataTableListRepository, ExpectedJobsDataTableListRepository>();
            services.AddTransient<IExptJobsDataTableListRepository, ExptJobsDataTableListRepository>();
            services.AddTransient<IExptPrjcDataTableListRepository, ExptPrjcDataTableListRepository>();
            services.AddTransient<IProjmastDetailRepository, ProjmastDetailRepository>();
            services.AddTransient<IManhoursProjectionsCurrentJobsCanCreateRepository, ManhoursProjectionsCurrentJobsCanCreateRepository>();

            services.AddTransient<IOscDetailDataTableListRepository, OscDetailDataTableListRepository>();
            services.AddTransient<IOscHoursDataTableListRepository, OscHoursDataTableListRepository>();
            services.AddTransient<IOscMasterDataTableListRepository, OscMasterDataTableListRepository>();
            services.AddTransient<IOscSesDataTableListRepository, OscSesDataTableListRepository>();
            services.AddTransient<IOscActualHoursBookedDataTableListRepository, OscActualHoursBookedDataTableListRepository>();
            services.AddTransient<IProcessLogDataTableListRepository, ProcessLogDataTableListRepository>();
            services.AddTransient<ITSPostedHoursDataTableListRepository, TSPostedHoursDataTableListRepository>();
            services.AddTransient<ITSShiftProjectManhoursDataTableListRepository, TSShiftProjectManhoursDataTableListRepository>();
            services.AddTransient<IActivityMasterDataTableListRepository, ActivityMasterDataTableListRepository>();
            services.AddTransient<IProjactMasterDataTableListRepository, ProjactMasterDataTableListRepository>();
            services.AddTransient<IRapHoursDataTableListRepository, RapHoursDataTableListRepository>();
            services.AddTransient<IWrkHoursDataTableListRepository, WrkHoursDataTableListRepository>();
            services.AddTransient<ITLPDataTableListRepository, TLPDataTableListRepository>();
            services.AddTransient<ITsConfigDataTableListRepository, TsConfigDataTableListRepository>();
            services.AddTransient<IOvertimeUpdateDataTableListRepository, OvertimeUpdateDataTableListRepository>();
            services.AddTransient<IMovemastDataTableListRepository, MovemastDataTableListRepository>();

            services.AddTransient<IManhoursPrjcMasterDataTableListRepository, ManhoursPrjcMasterDataTableListRepository>();
            services.AddTransient<IManhoursPrjcJobDetailsDataTableListRepository, ManhoursPrjcJobDetailsDataTableListRepository>();
            services.AddTransient<IManhoursPrjcJobDetailsForExcelDataTableListRepository, ManhoursPrjcJobDetailsForExcelDataTableListRepository>();
            services.AddTransient<IMovemastForExcelTemplateDataTableListRepository, MovemastForExcelTemplateDataTableListRepository>();

            #endregion Rap Reporting View Repositories

            #region Rap Reporting Exec Repositories

            services.AddTransient<IRapReportingRepository, RapReportingRepository>();
            services.AddTransient<IExpectedJobsDetailsRepository, ExpectedJobsDetailsRepository>();
            services.AddTransient<IExpectedJobsRepository, ExpectedJobsRepository>();
            services.AddTransient<IExptPrjcDetailRepository, ExptPrjcDetailRepository>();
            services.AddTransient<IExptPrjcRepository, ExptPrjcRepository>();
            services.AddTransient<IManageRepository, ManageRepository>();
            services.AddTransient<IManhoursProjectionsCurrentJobsImportRepository, ManhoursProjectionsCurrentJobsImportRepository>();
            services.AddTransient<IManhoursProjectionsExpectedJobsImportRepository, ManhoursProjectionsExpectedJobsImportRepository>();
            services.AddTransient<IOvertimeUpdateImportRepository, OvertimeUpdateImportRepository>();

            services.AddTransient<IOscHoursDetailRepository, OscHoursDetailRepository>();
            services.AddTransient<IOscHoursRepository, OscHoursRepository>();
            services.AddTransient<IOscMasterDetailRepository, OscMasterDetailRepository>();
            services.AddTransient<IOscDetailDetailRepository, OscDetailDetailRepository>();
            services.AddTransient<IOscMasterRepository, OscMasterRepository>();
            services.AddTransient<IOscSesRepository, OscSesRepository>();
            services.AddTransient<IOscSesDetailRepository, OscSesDetailRepository>();
            services.AddTransient<IOscDetailRepository, OscDetailRepository>();

            services.AddTransient<IMovemastImportRepository, MovemastImportRepository>();
            services.AddTransient<ITSRepostingDetailsRepository, TSRepostingDetailsRepository>();
            services.AddTransient<ITSPostedHoursTotalRepository, TSPostedHoursTotalRepository>();

            services.AddTransient<ITSShiftProjectManhoursRepository, TSShiftProjectManhoursRepository>();
            services.AddTransient<ITSShiftProjectManhoursReportRepository, TSShiftProjectManhoursReportRepository>();
            services.AddTransient<IActivityMasterRepository, ActivityMasterRepository>();
            services.AddTransient<IActivityDetailRepository, ActivityDetailRepository>();
            services.AddTransient<IProjactMasterRepository, ProjactMasterRepository>();
            services.AddTransient<IProjactDetailRepository, ProjactDetailRepository>();
            services.AddTransient<IRapHoursRepository, RapHoursRepository>();
            services.AddTransient<IRapHoursDetailRepository, RapHoursDetailRepository>();
            services.AddTransient<IWrkHoursRepository, WrkHoursRepository>();
            services.AddTransient<IWrkHoursDetailRepository, WrkHoursDetailRepository>();
            services.AddTransient<ITLPRepository, TLPRepository>();
            services.AddTransient<ITLPDetailRepository, TLPDetailRepository>();
            services.AddTransient<IProcessingMonthDetailRepository, ProcessingMonthDetailRepository>();
            services.AddTransient<IOvertimeUpdateDetailRepository, OvertimeUpdateDetailRepository>();
            services.AddTransient<IOvertimeUpdateRepository, OvertimeUpdateRepository>();
            services.AddTransient<IMovemastDetailRepository, MovemastDetailRepository>();
            services.AddTransient<IMovemastRepository, MovemastRepository>();
            services.AddTransient<IManhoursProjectionsCurrentJobsProjectRepository, ManhoursProjectionsCurrentJobsProjectRepository>();
            services.AddTransient<INoOfEmployeeDetailRepository, NoOfEmployeeDetailRepository>();
            services.AddTransient<INoOfEmployeeRepository, NoOfEmployeeRepository>();

            #endregion Rap Reporting Exec Repositories

            #region RSVP Exec Repositories

            services.AddTransient<INavratriRSVPDetailRepository, NavratriRSVPDetailRepository>();
            services.AddTransient<IRSVPRepository, RSVPRepository>();

            #endregion RSVP Exec Repositories

            #region RSVP View Repositories

            services.AddTransient<IRSVPViewRepository, RSVPViewRepository>();

            #endregion RSVP View Repositories

            #region Mail Queue

            services.AddTransient<IMailQueueMailsRepository, MailQueueMailsRepository>();

            #endregion Mail Queue

            #region Process Queue

            #region Exec

            services.AddTransient<IProcessQueueRepository, ProcessQueueRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IProcessQueueDataTableListRepository, ProcessQueueDataTableListRepository>();

            #endregion View

            #endregion Process Queue

            #region Timesheet

            #region Exec

            services.AddTransient<ITimesheetReportRepository, TimesheetReportRepository>();
            services.AddTransient<ITimesheetDepartmentRepository, TimesheetDepartmentRepository>();
            services.AddTransient<ITimesheetDepartmentStatusRepository, TimesheetDepartmentStatusRepository>();
            services.AddTransient<ITimesheetEmployeeStatusRepository, TimesheetEmployeeStatusRepository>();
            services.AddTransient<ITimesheetStatusPartialDataTableListRepository, TimesheetStatusPartialDataTableListRepository>();
            services.AddTransient<ITimesheetWrkHourCountRepository, TimesheetWrkHourCountRepository>();
            services.AddTransient<ITimesheetFreezeStatusRepository, TimesheetFreezeStatusRepository>();
            services.AddTransient<IOSCMhrsRepository, OSCMhrsRepository>();
            services.AddTransient<IOSCMhrsDetailRepository, OSCMhrsDetailRepository>();
            services.AddTransient<IEmployeeTimesheetDetailsRepository, EmployeeTimesheetDetailsRepository>();

            #endregion Exec

            #region View

            services.AddTransient<ITimesheetReportDetailRepository, TimesheetReportDetailRepository>();
            services.AddTransient<IOSCMhrsDetailsDataTableListRepository, OSCMhrsDetailsDataTableListRepository>();
            services.AddTransient<IOSCMhrsSummaryDataTableListRepository, OSCMhrsSummaryDataTableListRepository>();
            services.AddTransient<IOSCMhrsDetailsXLDataTableListRepository, OSCMhrsDetailsXLDataTableListRepository>();
            services.AddTransient<ITimesheetStatusDataTableListRepository, TimesheetStatusDataTableListRepository>();
            services.AddTransient<ITimesheetStatusDataTableListExcelRepository, TimesheetStatusDataTableListExcelRepository>();
            services.AddTransient<ITimesheetProjectDataTableListRepository, TimesheetProjectDataTableListRepository>();
            services.AddTransient<ITimesheetProjectDataTableExcelRepository, TimesheetProjectDataTableExcelRepository>();
            services.AddTransient<ITimesheetDepartmentDataTableListExcelRepository, TimesheetDepartmentDataTableListExcelRepository>();
            services.AddTransient<ITimesheetPartialStatusDataTableListExcelRepository, TimesheetPartialStatusDataTableListExcelRepository>();
            services.AddTransient<ITimesheetReminderEmailRepository, TimesheetReminderEmailRepository>();
            services.AddTransient<ITimesheetStatusEmployeeCountDataTableListRepository, TimesheetStatusEmployeeCountDataTableListRepository>();
            services.AddTransient<IEmployeeTimesheetDataTableListRepository, EmployeeTimesheetDataTableListRepository>();

            #endregion View

            #endregion Timesheet

            #region Employee General Info

            #region Exec

            services.AddTransient<IVoluntaryParentPolicyRepository, VoluntaryParentPolicyRepository>();
            services.AddTransient<IVoluntaryParentPolicyDetailRepository, VoluntaryParentPolicyDetailRepository>();
            services.AddTransient<IHRVoluntaryParentPolicyDetailRepository, HRVoluntaryParentPolicyDetailRepository>();
            services.AddTransient<IGratuityNominationRepository, GratuityNominationRepository>();
            services.AddTransient<ISupperannuationNominationRepository, SupperannuationNominationRepository>();
            services.AddTransient<IEmpProFundNominationRepository, EmpProFundNominationRepository>();
            services.AddTransient<IGratuityNominationDetailRepository, GratuityNominationDetailRepository>();
            services.AddTransient<ISupperannuationNominationDetailRepository, SupperannuationNominationDetailRepository>();
            services.AddTransient<IEmpPensionFundMarriedMemRepository, EmpPensionFundMarriedMemRepository>();
            services.AddTransient<IEmpPensionFundMarriedMemDetailRepository, EmpPensionFundMarriedMemDetailRepository>();
            services.AddTransient<IEmpPensionFundMemberRepository, EmpPensionFundMemberRepository>();
            services.AddTransient<IEmpPensionFundDetailRepository, EmpPensionFundDetailRepository>();
            services.AddTransient<IEmpProvidentFundDetailRepository, EmpProvidentFundDetailRepository>();
            services.AddTransient<IMediclaimNominationRepository, MediclaimNominationRepository>();
            services.AddTransient<IMediclaimNominationDetailRepository, MediclaimNominationDetailRepository>();
            services.AddTransient<IEmpAadhaarDetailsRepository, EmpAadhaarDetailsRepository>();
            services.AddTransient<IEmpPassportDetailsRepository, EmpPassportDetailsRepository>();
            services.AddTransient<IEmpGtliNominationRepository, EmpGtliNominationRepository>();
            services.AddTransient<IGTLINominationDetailRepository, GTLINominationDetailRepository>();
            services.AddTransient<IEmployeeSecondaryDetailsRepository, EmployeeSecondaryDetailsRepository>();
            services.AddTransient<IEmployeePrimaryDetailsRepository, EmployeePrimaryDetailsRepository>();
            services.AddTransient<IEmpDetailsLockStatusRepository, EmpDetailsLockStatusRepository>();
            services.AddTransient<IAadharDetailsRepository, AadharDetailsRepository>();
            services.AddTransient<IPassportDetailsRepository, PassportDetailsRepository>();
            services.AddTransient<IBulkActionsRepository, BulkActionsRepository>();
            services.AddTransient<IScanFileRepository, ScanFileRepository>();
            services.AddTransient<IEmpScanFileDetailsRepository, EmpScanFileDetailsRepository>();
            services.AddTransient<INominationSubmitStatusRepository, NominationSubmitStatusRepository>();
            services.AddTransient<IGTLINominationSubmitStatusRepository, GTLINominationSubmitStatusRepository>();

            services.AddTransient<IIcardConsentDetailsRepository, IcardConsentDetailsRepository>();
            services.AddTransient<IIcardConsentPhotoImportRepository, IcardConsentPhotoImportRepository>();
            services.AddTransient<IICardConsentUpdateRepository, ICardConsentUpdateRepository>();
            services.AddTransient<ILoAAddendumConsentDetailsRepository, LoAAddendumConsentDetailsRepository>();
            services.AddTransient<ILoAAddendumConsentUpdateRepository, LoAAddendumConsentUpdateRepository>();
            services.AddTransient<IEmploymentOfficeRelativesRepository, EmploymentOfficeRelativesRepository>();
            services.AddTransient<IEmployeeRelativeRepository, EmployeeRelativeRepository>();
            services.AddTransient<ILoaAddendumAcceptanceDetailsRepository, LoaAddendumAcceptanceDetailsRepository>();
            services.AddTransient<IEmpRelativesAsColleaguesDetailsRepository, EmpRelativesAsColleaguesDetailsRepository>();
            services.AddTransient<IEmpRelativesDeclStatusDetailsRepository, EmpRelativesDeclStatusDetailsRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IVoluntaryParentPolicyDataTableListRepository, VoluntaryParentPolicyDataTableListRepository>();
            services.AddTransient<IHRVoluntaryParentPolicyDataTableListRepository, HRVoluntaryParentPolicyDataTableListRepository>();
            services.AddTransient<IHRVoluntaryParentPolicyDetailDataTableListRepository, HRVoluntaryParentPolicyDetailDataTableListRepository>();
            services.AddTransient<IGratuityDetailsDataTableListRepository, GratuityDetailsDataTableListRepository>();
            services.AddTransient<ISuperannuationDetailsDataTableListRepository, SuperannuationDetailsDataTableListRepository>();
            services.AddTransient<IEmpProFundDetailsDataTableListRepository, EmpProFundDetailsDataTableListRepository>();
            services.AddTransient<IGTLIDetailsDataTableListRepository, GTLIDetailsDataTableListRepository>();
            services.AddTransient<IGTLIDataTableListRepository, GTLIDataTableListRepository>();
            services.AddTransient<IEmpPrimaryDetailsRepository, EmpPrimaryDetailsRepository>();
            services.AddTransient<IEmpSecondaryDetailsRepository, EmpSecondaryDetailsRepository>();

            services.AddTransient<IEmpPensionFundMarriedDetailsDataTableListRepository, EmpPensionFundMarriedDetailsDataTableListRepository>();
            services.AddTransient<IEmpPensionFundDetailsDataTableListRepository, EmpPensionFundDetailsDataTableListRepository>();
            services.AddTransient<IEmpGenInfoGetLockStatusDetailsRepository, EmpGenInfoGetLockStatusDetailsRepository>();
            services.AddTransient<IEmpGenInfoGetDescripancyDetailsRepository, EmpGenInfoGetDescripancyDetailsRepository>();
            services.AddTransient<IEmpGenInfoMediclaimDetailsDataTableListRepository, EmpGenInfoMediclaimDetailsDataTableListRepository>();
            services.AddTransient<ILockStatusDetailsDataTableListRepository, LockStatusDetailsDataTableListRepository>();
            services.AddTransient<INominationSubmitStatusDataTableListRepository, NominationSubmitStatusDataTableListRepository>();
            services.AddTransient<IGTLINominationSubmitStatusDataTableListRepository, GTLINominationSubmitStatusDataTableListRepository>();

            services.AddTransient<IHREmpNomineeDataTableListRepository, HREmpNomineeDataTableListRepository>();
            services.AddTransient<IHREmpFamilyDataTableListRepository, HREmpFamilyDataTableListRepository>();
            services.AddTransient<IHREmpMediclaimDataTableListRepository, HREmpMediclaimDataTableListRepository>();
            services.AddTransient<IHREmpDetailsNotFilledDataTableListRepository, HREmpDetailsNotFilledDataTableListRepository>();
            services.AddTransient<IHREmpDetailsAllDataTableListRepository, HREmpDetailsAllDataTableListRepository>();
            services.AddTransient<IHREmpAadhaarDataTableListRepository, HREmpAadhaarDataTableListRepository>();
            services.AddTransient<IHRExEmpNomineeDataTableListRepository, HRExEmpNomineeDataTableListRepository>();
            services.AddTransient<IHRExEmpContactInfoDataTableListRepository, HRExEmpContactInfoDataTableListRepository>();

            services.AddTransient<IICardConsentDataTableListRepository, ICardConsentDataTableListRepository>();
            services.AddTransient<IICardConsentXLDataTableListRepository, ICardConsentXLDataTableListRepository>();
            services.AddTransient<IHRVppConfigProcessDataTableListRepository, HRVppConfigProcessDataTableListRepository>();
            services.AddTransient<IVppConfigProcessRepository, VppConfigProcessRepository>();
            services.AddTransient<IHRVppConfigProcessDetailRepository, HRVppConfigProcessDetailRepository>();
            services.AddTransient<IVoluntaryParentPolicyConfigurationRepository, VoluntaryParentPolicyConfigurationRepository>();
            services.AddTransient<IEmployeeRelativesDataTableListRepository, EmployeeRelativesDataTableListRepository>();
            services.AddTransient<ILoAAddendumAppointmentDataTableListRepository, LoAAddendumAppointmentDataTableListRepository>();
            services.AddTransient<IEmpRelativesAsColleaguesDataTableListRepository, EmpRelativesAsColleaguesDataTableListRepository>();
            services.AddTransient<IEmployeeRelativesDataTableListExcelViewRepository, EmployeeRelativesDataTableListExcelViewRepository>();
            services.AddTransient<IEmpRelativesAsColleaguesDataTableListExcelViewRepository, EmpRelativesAsColleaguesDataTableListExcelViewRepository>();

            #endregion View

            #endregion Employee General Info

            #region Logs

            #region Exec

            services.AddTransient<IEmailDetailsRepository, EmailDetailsRepository>();
            services.AddTransient<IProcessDetailsRepository, ProcessDetailsRepository>();
            services.AddTransient<IAccessGrantRepository, AccessGrantRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IEmailDataTableListRepository, EmailDataTableListRepository>();
            services.AddTransient<IProcessDataTableListRepository, ProcessDataTableListRepository>();
            services.AddTransient<IAppTaskSchedulerLogDataTableListRepository, AppTaskSchedulerLogDataTableListRepository>();
            services.AddTransient<IAppProcessQueueLogDataTableListRepository, AppProcessQueueLogDataTableListRepository>();

            services.AddTransient<IAccessGrantDataTableListRepository, AccessGrantDataTableListRepository>();

            #endregion View

            #endregion Logs

            #region CoreSettings

            #region Exec

            services.AddTransient<IModulesDetailRepository, ModulesDetailRepository>();
            services.AddTransient<IModulesRepository, ModulesRepository>();
            services.AddTransient<IRolesRepository, RolesRepository>();
            services.AddTransient<IRolesDetailRepository, RolesDetailRepository>();
            services.AddTransient<IActionsRepository, ActionsRepository>();
            services.AddTransient<IActionsDetailRepository, ActionsDetailRepository>();
            services.AddTransient<IModuleRolesRepository, ModuleRolesRepository>();
            services.AddTransient<IModuleRolesDetailRepository, ModuleRolesDetailRepository>();
            services.AddTransient<IModuleRolesActionsRepository, ModuleRolesActionsRepository>();
            services.AddTransient<IModuleRolesActionsDetailRepository, ModuleRolesActionsDetailRepository>();
            services.AddTransient<IModuleUserRolesRepository, ModuleUserRolesRepository>();
            services.AddTransient<IModuleUserRolesDetailRepository, ModuleUserRolesDetailRepository>();
            services.AddTransient<IModuleUserRoleActionsRepository, ModuleUserRoleActionsRepository>();
            services.AddTransient<IDelegateRepository, DelegateRepository>();
            services.AddTransient<IModuleUserRoleCostCodeRepository, ModuleUserRoleCostCodeRepository>();
            services.AddTransient<IAppMailProcessStatusRepository, AppMailProcessStatusRepository>();
            services.AddTransient<IAppMailProcessStatusDetailsRepository, AppMailProcessStatusDetailsRepository>();
            services.AddTransient<IModuleActionsRepository, ModuleActionsRepository>();
            services.AddTransient<IUploadAppUserRepository, UploadAppUserRepository>();
            services.AddTransient<IUpdateAppUserMasterRepository, UpdateAppUserMasterRepository>();
            services.AddTransient<IModuleUserRoleBulkUploadRepository, ModuleUserRoleBulkUploadRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IModulesDataTableListRepository, ModulesDataTableListRepository>();
            services.AddTransient<IRolesDataTableListRepository, RolesDataTableListRepository>();
            services.AddTransient<IActionsDataTableListRepository, ActionsDataTableListRepository>();
            services.AddTransient<IModuleRolesDataTableListRepository, ModuleRolesDataTableListRepository>();
            services.AddTransient<IModuleRolesActionsDataTableListRepository, ModuleRolesActionsDataTableListRepository>();
            services.AddTransient<IModuleUserRolesDataTableListRepository, ModuleUserRolesDataTableListRepository>();
            services.AddTransient<IVUModuleUserRoleActionsDataTableListRepository, VUModuleUserRoleActionsDataTableListRepository>();
            services.AddTransient<IModuleUserRoleActionsDataTableListRepository, ModuleUserRoleActionsDataTableListRepository>();
            services.AddTransient<IDelegateDataTableListRepository, DelegateDataTableListRepository>();
            services.AddTransient<IModuleUserRoleCostCodeDataTableListRepository, ModuleUserRoleCostCodeDataTableListRepository>();
            services.AddTransient<IAppMailProcessStatusLogDataTableListRepository, AppMailProcessStatusLogDataTableListRepository>();
            services.AddTransient<IModuleActionsDataTableListRepository, ModuleActionsDataTableListRepository>();
            services.AddTransient<IAppUserMasterDataTableListRepository, AppUserMasterDataTableListRepository>();

            #endregion View

            #endregion CoreSettings

            #region OffBoarding

            #region Exec

            services.AddTransient<IOFBInitRepository, OFBInitRepository>();
            services.AddTransient<IOFBInitDetailRepository, OFBInitDetailRepository>();
            services.AddTransient<IOFBApprovalDetailRepository, OFBApprovalDetailRepository>();
            services.AddTransient<IOFBApprovalRepository, OFBApprovalRepository>();
            services.AddTransient<IOFBEmpExitDetailsRepository, OFBEmpExitDetailsRepository>();
            services.AddTransient<IOFBRollbackRepository, OFBRollbackRepository>();
            services.AddTransient<IOFBResetApprovalsRepository, OFBResetApprovalsRepository>();
            services.AddTransient<IOFBApprovalActionDetailRepository, OFBApprovalActionDetailRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IOFBInitDataTableListRepository, OFBInitDataTableListRepository>();

            services.AddTransient<IOFBPendingApprovalsDataTableListRepository, OFBPendingApprovalsDataTableListRepository>();
            services.AddTransient<IOFBHistoryDataTableListRepository, OFBHistoryDataTableListRepository>();
            services.AddTransient<IOFBApprovalDetailsDataTableListRepository, OFBApprovalDetailsDataTableListRepository>();
            services.AddTransient<IOFBRollbackDataTableListRepository, OFBRollbackDataTableListRepository>();
            services.AddTransient<IOFBHistoryXLDataTableListRepository, OFBHistoryXLDataTableListRepository>();
            services.AddTransient<IOFBApprovalsDataTableListRepository, OFBApprovalsDataTableListRepository>();
            services.AddTransient<IOFBApprovalsXLDataTableListRepository, OFBApprovalsXLDataTableListRepository>();
            services.AddTransient<IOFBResetApprovalsDataTableListRepository, OFBResetApprovalsDataTableListRepository>();
            services.AddTransient<IOFBDeptmntExitApprovalsDataTableListRepository, OFBDeptmntExitApprovalsDataTableListRepository>();

            #endregion View

            #endregion OffBoarding

            #region Report site map

            #region Exec

            services.AddTransient<ISiteMapActionDetailsRepository, SiteMapActionDetailsRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IReportSiteMapDataTableListRepository, ReportSiteMapDataTableListRepository>();
            services.AddTransient<IReportSiteMapFilterRepository, ReportSiteMapFilterRepository>();
            services.AddTransient<IRepSiteMapDataTableListRepository, RepSiteMapDataTableListRepository>();

            #endregion View

            #endregion Report site map

            #region DigiForm

            #region Exec

            services.AddTransient<IMidEvaluationDetailRepository, MidEvaluationDetailRepository>();
            services.AddTransient<IMidTermEvaluationRepository, MidTermEvaluationRepository>();
            services.AddTransient<IMidEvaluationGetKeyIdRepository, MidEvaluationGetKeyIdRepository>();
            services.AddTransient<ICostcodeChangeRequestRepository, CostcodeChangeRequestRepository>();
            services.AddTransient<ICostcodeChangeRequestDetailRepository, CostcodeChangeRequestDetailRepository>();
            services.AddTransient<ISiteMasterRequestRepository, SiteMasterRequestRepository>();
            services.AddTransient<ISiteMasterDetailRepository, SiteMasterDetailRepository>();
            services.AddTransient<IAnnualEvaluationRepository, AnnualEvaluationRepository>();
            services.AddTransient<IAnnualEvaluationDetailRepository, AnnualEvaluationDetailRepository>();
            services.AddTransient<IAnnualEvaluationGetKeyIdRepository, AnnualEvaluationGetKeyIdRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IMidTermEvaluationDataTableListRepository, MidTermEvaluationDataTableListRepository>();
            services.AddTransient<ICostcodeChangeRequestDataTableListRepository, CostcodeChangeRequestDataTableListRepository>();
            services.AddTransient<IApprovalDetailsDataTableListRepository, ApprovalDetailsDataTableListRepository>();
            services.AddTransient<ISiteMasterDataTableListRepository, SiteMasterDataTableListRepository>();
            services.AddTransient<IAnnualEvaluationDataTableListRepository, AnnualEvaluationDataTableListRepository>();

            #endregion View

            #endregion DigiForm

            #region DeskBooking

            #region Exec

            services.AddTransient<IDeskBookingCreateRepository, DeskBookingCreateRepository>();
            services.AddTransient<IDeskBookingRepository, DeskBookingRepository>();
            services.AddTransient<IDeskBookPlanningStatusRepository, DeskBookPlanningStatusRepository>();
            services.AddTransient<IDeskBookEmployeeProjectMappingRepository, DeskBookEmployeeProjectMappingRepository>();
            services.AddTransient<IDeskBookEmployeeProjectMappingDetails, DeskBookEmployeeProjectMappingDetails>();
            services.AddTransient<IDeskBookingPreferencesDetails, DeskBookingPreferencesDetails>();
            services.AddTransient<IDeskBookingPreferencesRepository, DeskBookingPreferencesRepository>();
            services.AddTransient<IDeskBookingStatusRepository, DeskBookingStatusRepository>();
            services.AddTransient<IBookingSummaryDetailRepository, BookingSummaryDetailRepository>();
            services.AddTransient<IBookingSummaryXLReport, BookingSummaryXLReport>();
            services.AddTransient<IBookingSummaryDeptXLReport, BookingSummaryDeptXLReport>();
            services.AddTransient<IDeskBookingAttendanceRepository, DeskBookingAttendanceRepository>();
            services.AddTransient<IEmpLocationMapRequestRepository, EmpLocationMapRequestRepository>();
            services.AddTransient<ICabinBookingRepository, CabinBookingRepository>();
            services.AddTransient<ICabinBookingsDataTableListRepository, CabinBookingsDataTableListRepository>();
            services.AddTransient<IImportDeskBookingsRepository, ImportDeskBookingsRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IDeskBookEmployeeProjectMappingDataTableListRepository, DeskBookEmployeeProjectMappingDataTableListRepository>();
            services.AddTransient<IDeskBookingDataTableListRepository, DeskBookingDataTableListRepository>();
            services.AddTransient<IAttendanceDateDataTableListRepository, AttendanceDateDataTableListRepository>();
            services.AddTransient<IDeskBookHistoryDataTableListRepository, DeskBookHistoryDataTableListRepository>();
            services.AddTransient<IDeskAreaUserMapHodDataTableListRepository, DeskAreaUserMapHodDataTableListRepository>();
            services.AddTransient<IDeskAreaUserMapHodDetailRepository, DeskAreaUserMapHodDetailRepository>();
            services.AddTransient<IAreaWiseDeskBookingDataTableListRepository, AreaWiseDeskBookingDataTableListRepository>();
            services.AddTransient<ISummaryDataTableListRepository, SummaryDataTableListRepository>();
            services.AddTransient<IDeskBookAttendanceDmsDataTableListRepository, DeskBookAttendanceDmsDataTableListRepository>();
            services.AddTransient<IDeskBookAttendanceHodDataTableListRepository, DeskBookAttendanceHodDataTableListRepository>();
            services.AddTransient<ICrossBookingSummaryXLListRepository, CrossBookingSummaryXLListRepository>();
            services.AddTransient<IBookingSummaryDataTableListRepository, BookingSummaryDataTableListRepository>();
            services.AddTransient<IDeskListDataTableListRepository, DeskListDataTableListRepository>();
            services.AddTransient<IEmpBookedDeskListDataTableListRepository, EmpBookedDeskListDataTableListRepository>();
            services.AddTransient<IDeskBookingDetailsRepository, DeskBookingDetailsRepository>();
            services.AddTransient<IDeskBookingAttendanceStatusDataTableListRepository, DeskBookingAttendanceStatusDataTableListRepository>();
            services.AddTransient<IEmpLocationMappingDataTableListRepository, EmpLocationMappingDataTableListRepository>();
            services.AddTransient<IBookedDeskDataTableListRepository, BookedDeskDataTableListRepository>();
            services.AddTransient<IDeskBookCabinBookingsDataTableListRepository, DeskBookCabinBookingsDataTableListRepository>();

            #endregion View

            #endregion DeskBooking

            #region HRMaster

            #region Exec

            services.AddTransient<IRegionRepository, RegionRepository>();
            services.AddTransient<IRegionDetailRepository, RegionDetailRepository>();
            services.AddTransient<IRegionHolidaysRepository, RegionHolidaysRepository>();
            services.AddTransient<IRegionHolidaysDetailRepository, RegionHolidaysDetailRepository>();

            #endregion Exec

            #region View

            services.AddTransient<IRegionDataTableListRepository, RegionDataTableListRepository>();
            services.AddTransient<IRegionHolidaysDataTableListRepository, RegionHolidaysDataTableListRepository>();

            #endregion View

            #endregion HRMaster

            #region Logbook

            #region Exec

            services.AddTransient<ILogbookReportRepository, LogbookReportRepository>();

            #endregion Exec

            #region View

            services.AddTransient<ILogbookReportDetailRepository, LogbookReportDetailRepository>();
            services.AddTransient<ILogbookDataTableListRepository, LogbookDataTableListRepository>();

            #endregion View

            #endregion Logbook

            services.AddTransient<ISelectTcmPLRepository, SelectTcmPLRepository>();

            services.AddTransient<ISelectRepository, SelectRepository>();
            services.AddTransient<IUserIdentityRolesActionsRepository, UserIdentityRolesActionsRepository>();
            services.AddTransient<IEmployeePolicyRepository, EmployeePolicyRepository>();
            services.AddTransient<IHoDEmpPolicyManageRepository, HoDEmpPolicyManageRepository>();
            services.AddTransient<IHREmpPolicyManageRepository, HREmpPolicyManageRepository>();
            services.AddTransient<IHRVaccineDateManageRepository, HRVaccineDateManageRepository>();
            services.AddTransient<IVaccinationSelfRepository, VaccinationSelfRepository>();
            services.AddTransient<IEmployeeDetailsRepository, EmployeeDetailsRepository>();
            services.AddTransient<IEmployeeTrainingRepository, EmployeeTrainingRepository>();
            services.AddTransient<IHRMastersRepository, HRMastersRepository>();
            services.AddTransient<IVaccinationOfficeRepository, VaccinationOfficeRepository>();
            services.AddTransient<ISwpTplVaccineBatchRepository, SwpTplVaccineBatchRepository>();
            services.AddTransient<ISwpTplVaccineBatchEmpRepository, SwpTplVaccineBatchEmpRepository>();
            services.AddTransient<ISwpTplVaccineBatchDetailsRepository, SwpTplVaccineBatchDetailsRepository>();
            services.AddTransient<IUploadExcelBLobRepository, UploadExcelBLobRepository>();
            services.AddTransient<ISWPCheckDetailsRepository, SWPCheckDetailsRepository>();
            services.AddTransient<ISwpRelationMastRepository, SwpRelationMastRepository>();
            services.AddTransient<ISWPOfficeVaccineBatch2Repository, SWPOfficeVaccineBatch2Repository>();

            services.AddTransient<IOffBoardingExitRepository, OffBoardingExitRepository>();
            services.AddTransient<IOffBoardingUserManagementRepository, OffBoardingUserManagementRepository>();

            return services;
        }
    }
}