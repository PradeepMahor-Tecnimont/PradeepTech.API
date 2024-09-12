using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.DataAccess.Models
{
    public class ParameterSpTcmPL
    {
        public string PDept { get; set; }
        public string PEmpno { get; set; }
        public string PEmpNo { get; set; }

        public Int64? PRowNumber { get; set; }
        public Int64? PPageLength { get; set; }

        public DateTime? PStartDate { get; set; }

        public DateTime? PEndDate { get; set; }

        public string PLeaveType { get; set; }

        public string POndutyType { get; set; }

        public Int32? PHalfDayOn { get; set; }

        public string PProjno { get; set; }
        public string PCareTaker { get; set; }

        public string PReason { get; set; }
        public Int32? PMedCertAvailable { get; set; }
        public string PContactAddress { get; set; }
        public string PContactStd { get; set; }
        public string PContactPhone { get; set; }
        public string POffice { get; set; }
        public string PFloor { get; set; }
        public string PWing { get; set; }

        public string PLeadEmpno { get; set; }
        public string PDiscrepancy { get; set; }
        public string PMedCertFileNm { get; set; }

        public string PApplicationId { get; set; }

        public decimal? PGroupNo { get; set; }

        public string PHh1 { get; set; }
        public string PMi1 { get; set; }
        public string PHh2 { get; set; }
        public string PMi2 { get; set; }
        public DateTime? PDate { get; set; }
        public string PType { get; set; }
        public string PSubType { get; set; }
        public string PLeadApprover { get; set; }

        public string PGuestName { get; set; }
        public string PGuestCompany { get; set; }

        public string PYyyymm { get; set; }
        public string PProject { get; set; }
        public string PApprover { get; set; }

        public string PForOt { get; set; }

        public string[] PSelectedCompoffDays { get; set; }

        public string[] PWeekendTotals { get; set; }

        public decimal? PSumCompoffHrs { get; set; }

        public decimal? PSumWeekdayExtraHrs { get; set; }

        public decimal? PSumHolidayExtraHrs { get; set; }

        public string PClaimNo { get; set; }

        public string[] POndutyApprovals { get; set; }
        public string[] PHolidayApprovals { get; set; }
        public string[] PLeaveApprovals { get; set; }
        public string[] PClaimApprovals { get; set; }

        public string[] PLeaveClaims { get; set; }

        public string[] PConsumables { get; set; }
        public string PConsumableId { get; set; }
        public string PConsumableDesc { get; set; }
        public string PConsumableType { get; set; }

        public decimal? PRamCapacity { get; set; }

        public string[] PInvGroupItems { get; set; }
        public string PInvItemGroupId { get; set; }

        public string PInvGroupDesc { get; set; }

        public decimal? PQuantity { get; set; }
        public decimal? PApprovedOt { get; set; }
        public decimal? PApprovedHhot { get; set; }

        public decimal? PApprovedCo { get; set; }

        public string PParent { get; set; }
        public string PAssignCode { get; set; }
        public string PAssignCsv { get; set; }
        public string PAssignCodesCsv { get; set; }

        public string PEmptypeCsv { get; set; }

        public string PGradeCsv { get; set; }
        public string PPrimaryWorkspaceCsv { get; set; }
        public string PLaptopUser { get; set; }
        public string PEligibleForSwp { get; set; }

        public decimal? PLeavePeriod { get; set; }

        public string PDescription { get; set; }

        public string PDeskid { get; set; }
        public string PWorkArea { get; set; }
        public string PAreaCategory { get; set; }

        public string PGenericSearch { get; set; }

        public string[] PWeeklyAttendance { get; set; }

        public string[] PEmpWorkspaceArray { get; set; }

        public string PUnqid { get; set; }
        public string[] PAssetToHomeArray { get; set; }

        public string PYyyy { get; set; }
        public string PYearmode { get; set; }

        public string PBankDesc { get; set; }
        public string PCurrencyCode { get; set; }
        public string PCurrencyDesc { get; set; }
        public string PVendorName { get; set; }
        public decimal? PIsActive { get; set; }
        public string PCompanyCode { get; set; }
        public string PPaymentYyyymm { get; set; }
        public decimal? PPaymentYyyymmHalf { get; set; }
        public string PVendorKeyId { get; set; }
        public string PCurrencyKeyId { get; set; }
        public string PInvoiceNo { get; set; }
        public string PSapDocNo { get; set; }
        public string PPurchaseOrder { get; set; }
        public string PIssuingBank { get; set; }
        public string PDiscountingBank { get; set; }
        public string PAdvisingBank { get; set; }
        public DateTime? PValidityDate { get; set; }
        public DateTime? PIssueDate { get; set; }
        public decimal? PLcNumber { get; set; }
        public string PDurationType { get; set; }
        public decimal? PNoOfDays { get; set; }
        public DateTime? PAcceptanceDate { get; set; }
        public DateTime? PPaymentDateEst { get; set; }
        public DateTime? PPaymentDateAct { get; set; }

        public decimal? PActualAmountPaid { get; set; }

        public string PLcChargesStatus { get; set; }

        public decimal? PBasicCharges { get; set; }

        public decimal? POtherCharges { get; set; }

        public decimal? PTax { get; set; }
        public decimal? PExchangeRate { get; set; }
        public decimal? PLcAmount { get; set; }
        public decimal? PAmountInInr { get; set; }

        public string PClintFileName { get; set; }
        public string PServerFileName { get; set; }
        public DateTime? PExchageRateDate { get; set; }
        public string PRemarks { get; set; }

        public DateTime? PLcClPaymentDate { get; set; }
        public decimal? PLcClActualAmount { get; set; }

        public decimal? PLcClOtherCharges { get; set; }

        public string PLcKeyId { get; set; }
        public decimal? PPo { get; set; }

        public decimal? PSap { get; set; }
        public decimal? PInvoice { get; set; }

        public decimal? PCommissionRate { get; set; }
        public int? PDays { get; set; }

        public string PDeskAssignmentStatus { get; set; }

        public int? PSendToTreasury { get; set; }

        public string PName { get; set; }
        public int? PActive { get; set; }
        public string PBu { get; set; }

        public int? PActivefuture { get; set; }

        public string PFinalProjno { get; set; }

        public string PNewcostcode { get; set; }

        public string PTcmno { get; set; }

        public int? PLck { get; set; }

        public string PProjType { get; set; }
        public string PNewProjno { get; set; }
        public string PCostcode { get; set; }
        public string PRealProjno { get; set; }
        public string PExpectedProjno { get; set; }
        public int? PNumberOfMonths { get; set; }

        public string[] PEmployees { get; set; }

        public byte[] PEmployeesJson { get; set; }
        public string PFlagId { get; set; }

        public string PExcludeSwsType { get; set; }

        public string[] PProjections { get; set; }

        public decimal? PIsExcludeX1Employees { get; set; }

        public string PIncludeEmployeeLocation { get; set; }
        public decimal? PWorkspaceCode { get; set; }
        public string PAdjustmentType { get; set; }
        public string PModuleId { get; set; }
        public string PModuleName { get; set; }

        public string PKeyId { get; set; }

        public string PLogMessage { get; set; }

        public string PParameterJson { get; set; }

        public string PProcessId { get; set; }
        public string PProcessItemId { get; set; }

        public string PProcessDesc { get; set; }

        public string PMailTo { get; set; }
        public string PMailCc { get; set; }
        public string PMailBcc { get; set; }
        public string PMailSubject { get; set; }
        public string PMailBody1 { get; set; }
        public string PMailBody2 { get; set; }
        public string PMailType { get; set; }
        public string PMailFrom { get; set; }
        public string PMailAttachmentsOsNm { get; set; }
        public string PMailAttachmentsBusinessNm { get; set; }

        public string PReportid { get; set; }
        public int? PShowall { get; set; }
        public string PLoc { get; set; }
        public DateTime? PIncdate { get; set; }
        public string PInctime { get; set; }
        public string PInctype { get; set; }
        public string PNature { get; set; }
        public int? PBHead { get; set; }
        public int? PBNeck { get; set; }
        public int? PBForearm { get; set; }
        public int? PBLegs { get; set; }
        public int? PBFace { get; set; }
        public int? PBShoulder { get; set; }
        public int? PBElbow { get; set; }
        public int? PBKnee { get; set; }
        public int? PBMouth { get; set; }
        public int? PBChest { get; set; }
        public int? PBWrist { get; set; }
        public int? PBAnkle { get; set; }
        public int? PBEar { get; set; }
        public int? PBAbdomen { get; set; }
        public int? PBHip { get; set; }
        public int? PBFoot { get; set; }
        public int? PBEye { get; set; }
        public int? PBBack { get; set; }
        public int? PBThigh { get; set; }
        public int? PBOther { get; set; }
        public string PEmpname { get; set; }
        public string PDesg { get; set; }
        public string PAge { get; set; }
        public string PSex { get; set; }
        public string PSubcontract { get; set; }
        public string PSubcontractname { get; set; }
        public string PAid { get; set; }
        public string PCauses { get; set; }
        public string PAction { get; set; }
        public int? PMailsend { get; set; }
        public string PRecipients { get; set; }
        public string PStatusstring { get; set; }
        public string PCorrectiveactions { get; set; }
        public string PCloser { get; set; }
        public DateTime? PCloserdate { get; set; }
        public string PAttchmentlink { get; set; }

        public string PShortDesc { get; set; }
        public string PLocation { get; set; }
        public string PPmname { get; set; }
        public string[] PBudget { get; set; }
        public string PCostcodeGroupId { get; set; }
        public string PProcessLog { get; set; }
        public string PJobKeyId { get; set; }
        public string PCandidateName { get; set; }
        public string PCandidateEmail { get; set; }
        public string PCandidateMobile { get; set; }
        public string PErsCvDispName { get; set; }
        public string PErsCvOsName { get; set; }

        public decimal? PCvStatus { get; set; }
        public string PJobRefCode { get; set; }
        public string PPan { get; set; }
        public DateTime? PJobOpenDate { get; set; }
        public string PJobType { get; set; }
        public string PJobLocation { get; set; }
        public string PJobDesc01 { get; set; }
        public string PJobDesc02 { get; set; }
        public string PJobDesc03 { get; set; }

        public decimal? PMailLogTypeCode { get; set; }
        public decimal? PProcessLogTypeCode { get; set; }
        public string PVacancyJobKeyId { get; set; }
        public byte[] PBlob { get; set; }
        public string PRefnum { get; set; }

        public String PAmendment { get; set; }

        public int? PVacancyStatus { get; set; }
        public DateTime? PVacancyOpenFromDate { get; set; }
        public DateTime? PVacancyOpenToDate { get; set; }

        public string PChangeJobReference { get; set; }

        public string PWinUid { get; set; }

        public decimal? PAttend { get; set; }
        public decimal? PBus { get; set; }
        public decimal? PDinner { get; set; }
        public string PAcceptableId { get; set; }
        public string PBankId { get; set; }
        public string PCompId { get; set; }
        public string PComp { get; set; }
        public string PCompDesc { get; set; }
        public string PDomain { get; set; }
        public string PAccetableName { get; set; }
        public string PBankName { get; set; }
        public string PCurrId { get; set; }
        public string PPayableId { get; set; }
        public string PGuaranteeTypeId { get; set; }
        public string PGuaranteeType { get; set; }
        public string PCurrDesc { get; set; }
        public decimal? PIsVisible { get; set; }
        public decimal? PIsClosed { get; set; }
        public DateTime? PBgFromDate { get; set; }
        public DateTime? PBgToDate { get; set; }
        public DateTime? PBgValFromDate { get; set; }
        public DateTime? PBgValToDate { get; set; }
        public DateTime? PBgClaimFromDate { get; set; }
        public DateTime? PBgClaimToDate { get; set; }

        public string PBgnum { get; set; }
        public DateTime? PBgdate { get; set; }
        public string PCompid { get; set; }
        public string PBgtype { get; set; }
        public string PPonum { get; set; }
        public string PProjnum { get; set; }
        public string PIssuebyid { get; set; }
        public string PIssuetoid { get; set; }
        public DateTime? PBgvaldt { get; set; }
        public DateTime? PBgclmdt { get; set; }
        public string PBankid { get; set; }
        public decimal? PReleased { get; set; }
        public DateTime? PReldt { get; set; }
        public string PReldetails { get; set; }

        public string PAmendmentnum { get; set; }
        public DateTime? PBgrecdt { get; set; }
        public string PCurrid { get; set; }
        public string PBgamt { get; set; }
        public string PConvrate { get; set; }
        public string PBgaccept { get; set; }
        public string PBgacceptrmk { get; set; }
        public string PDocurl { get; set; }
        public string PStatusTypeId { get; set; }
        public string PProjContlId { get; set; }
        public string PVendorId { get; set; }
        public string PPpcId { get; set; }
        public string PPpmId { get; set; }
        public string PVendorTypeId { get; set; }
        public string PVendorType { get; set; }
        public string PProjDirId { get; set; }
        public string PStatusTypeIdIn { get; set; }
        public string PMngrname { get; set; }
        public string PMngremail { get; set; }
        public string PRelationId { get; set; }
        public string PGender { get; set; }
        public string PInsuredSumId { get; set; }
        public DateTime? PDob { get; set; }
        public string PKeyIdDetail { get; set; }

        public string PDeskId { get; set; }
        public string PSeatNo { get; set; }
        public string PNoExist { get; set; }
        public string PCabin { get; set; }
        public string PDeskIdOld { get; set; }
        public string PWorkAreaCode { get; set; }
        public string PWorkAreaCategories { get; set; }
        public string PWorkAreaDesc { get; set; }
        public string PBay { get; set; }
        public string PAreaCatgCode { get; set; }
        public string PAreaDesc { get; set; }
        public string PBayId { get; set; }
        public string PBayDesc { get; set; }
        public string PAreaId { get; set; }
        public string PAreaInfo { get; set; }
        public string PDeskidOld { get; set; }

        public string POscsId { get; set; }
        public string POscmId { get; set; }
        public string PSesNo { get; set; }
        public DateTime? PSesDate { get; set; }
        public decimal? PSesAmount { get; set; }

        public DateTime? POscmDate { get; set; }
        public string PPoNumber { get; set; }
        public DateTime? PPoDate { get; set; }
        public decimal? PPoAmt { get; set; }
        public decimal? PCurPoAmt { get; set; }
        public string PProjno5 { get; set; }
        public string PProjno5Desc { get; set; }
        public string POscmVendor { get; set; }
        public string POscmVendorDesc { get; set; }
        public string POscmType { get; set; }
        public decimal? PLockOrigBudget { get; set; }
        public string PLockOrigBudgetDesc { get; set; }
        public decimal? POrigEstHoursTotal { get; set; }
        public decimal? PCurEstHoursTotal { get; set; }
        public decimal? PSesAmountTotal { get; set; }

        public string POscdId { get; set; }

        public decimal? POrigEstHrs { get; set; }

        public decimal? PCurEstHrs { get; set; }

        public string POschId { get; set; }
        public string POrigEstHrsStatus { get; set; }
        public string PCurEstHrsStatus { get; set; }
        public string PActionId { get; set; }
        public string POscswId { get; set; }
        public string PAssetId { get; set; }
        public string POldAssetId { get; set; }
        public string PItemTypeKeyId { get; set; }
        public string PAddonItemTypeId { get; set; }
        public string PAddonItemId { get; set; }

        public string PContainerItemTypeId { get; set; }
        public string PContainerItemId { get; set; }

        public string PItemTypeCode { get; set; }
        public string POpeningmonth { get; set; }
        public string PCategoryCode { get; set; }
        public string PItemAssignmentType { get; set; }
        public string PAsgmtCode { get; set; }
        public string PSubAssetType { get; set; }
        public string PTransId { get; set; }
        public string PTransDetId { get; set; }
        public DateTime? PTransDate { get; set; }
        public string PTransTypeId { get; set; }
        public string PItemId { get; set; }
        public string PItemUsable { get; set; }
        public string PTransTypeDesc { get; set; }
        public string PGuestEmpno { get; set; }
        public string PGuestCostcode { get; set; }
        public string PGuestProjno { get; set; }
        public string PGuestTargetDesk { get; set; }
        public DateTime? PGuestFromDate { get; set; }
        public DateTime? PGuestToDate { get; set; }

        public string PSessionId { get; set; }
        public decimal? PIsBlocked { get; set; }
        public string PCategory { get; set; }
        public decimal? PAssetFlag { get; set; }
        public string PActiontransId { get; set; }
        public string PTargetAsset { get; set; }
        public string PAssetidOld { get; set; }
        public string PSourceDesk { get; set; }
        public string PSourceEmp { get; set; }
        public string PAssetCategory { get; set; }
        public string[] PMovements { get; set; }
        public decimal? PActionType { get; set; }
        public DateTime? PFrom { get; set; }
        public DateTime? PTo { get; set; }
        public string PMovetype { get; set; }

        public string PPhase { get; set; }
        public string PTmagrp { get; set; }
        public decimal? PBlockbooking { get; set; }
        public decimal? PBlockot { get; set; }
        public string PNotes { get; set; }

        public decimal? PRevision { get; set; }

        public string PCompany { get; set; }
        public DateTime? PFormDate { get; set; }
        public decimal? PIsConsortium { get; set; }
        public string PPlantProgressNo { get; set; }
        public string PPlace { get; set; }
        public string PCountry { get; set; }
        public string PState { get; set; }
        public string PScopeOfWork { get; set; }
        public string PPlantType { get; set; }
        public string PBusinessLine { get; set; }
        public string PSubBusinessLine { get; set; }
        public string PProjectType { get; set; }
        public string PInvoiceToGrp { get; set; }
        public string PInvoiceToGrpName { get; set; }
        public string PClientName { get; set; }
        public string PContractNumber { get; set; }
        public DateTime? PContractDate { get; set; }
        public DateTime? PRevCloseDate { get; set; }
        public DateTime? PExpCloseDate { get; set; }
        public DateTime? PActualCloseDate { get; set; }

        public string PJobResponsibleRoleId { get; set; }
        public string PEmpnoR01 { get; set; }
        public string PEmpnoR02 { get; set; }
        public string PEmpnoR03 { get; set; }
        public string PEmpnoR04 { get; set; }
        public string PEmpnoR05 { get; set; }
        public string PEmpnoR06 { get; set; }
        public string PEmpnoR07 { get; set; }
        public string PEmpnoR08 { get; set; }
        public string PEmpnoR09 { get; set; }
        public string PEmpnoR10 { get; set; }
        public string PEmpnoR11 { get; set; }
        public string PTmaGroup { get; set; }
        public string PSubGroup { get; set; }
        public string PTmaGroupDesc { get; set; }
        public string PCode { get; set; }
        public string PPmEmpno { get; set; }
        public string PJsEmpno { get; set; }
        public string PRoleName { get; set; }
        public decimal? PInitiateApproval { get; set; }
        public string PJobNo { get; set; }
        public string PModuleLongDesc { get; set; }
        public string PModuleIsActive { get; set; }
        public string PFuncToCheckUserAccess { get; set; }
        public string PModuleSchemaName { get; set; }
        public string PModuleShortDesc { get; set; }
        public string PRoleId { get; set; }
        public string PRoleDesc { get; set; }
        public string PRoleIsActive { get; set; }
        public string PActionName { get; set; }
        public string PActionDesc { get; set; }
        public string PActionIsActive { get; set; }
        public string PModuleActionKeyId { get; set; }
        public string PModuleRoleKeyId { get; set; }
        public string PModuleRoleActionKeyId { get; set; }
        public string PPersonId { get; set; }
        public string PMetaId { get; set; }
        public string PIsActiveChar { get; set; }
        public string PShortDescription { get; set; }
        public string PNomName { get; set; }
        public string PNomAdd1 { get; set; }
        public string PRelation { get; set; }
        public DateTime? PNomDob { get; set; }
        public decimal? PSharePcnt { get; set; }
        public string PNomMinorGuardName { get; set; }
        public string PNomMinorGuardAdd1 { get; set; }
        public string PNomMinorGuardRelation { get; set; }
        public DateTime? PModifiedOn { get; set; }
        public string PAdhaarNo { get; set; }
        public string PAdhaarName { get; set; }
        public string PMember { get; set; }
        public decimal? POccupation { get; set; }
        public decimal? PFamilyRelation { get; set; }

        public string PBloodGroup { get; set; }
        public string PReligion { get; set; }
        public string PMaritalStatus { get; set; }
        public string PRAdd1 { get; set; }
        public string PRHouseNo { get; set; }
        public string PRCity { get; set; }
        public string PRDistrict { get; set; }
        public string PRCountry { get; set; }
        public decimal? PRPincode { get; set; }
        public string PPhoneRes { get; set; }
        public string PMobileRes { get; set; }
        public string PRefPersonName { get; set; }
        public string PRefPersonPhone { get; set; }
        public string PFAdd1 { get; set; }
        public string PFHouseNo { get; set; }
        public string PFCity { get; set; }
        public string PFDistrict { get; set; }
        public string PFCountry { get; set; }
        public decimal? PFPincode { get; set; }
        public string PCoBus { get; set; }
        public string PPickUpPoint { get; set; }
        public string PMobileOff { get; set; }
        public string PFax { get; set; }
        public string PVoip { get; set; }

        public string PFirstName { get; set; }
        public string PSurname { get; set; }
        public string PFatherName { get; set; }
        public string PPAdd1 { get; set; }
        public string PPHouseNo { get; set; }
        public string PPCity { get; set; }
        public string PPDistrict { get; set; }
        public decimal? PPPincode { get; set; }
        public string PPCountry { get; set; }
        public string PFState { get; set; }
        public string PPState { get; set; }
        public string PRState { get; set; }
        public string PPlaceOfBirth { get; set; }
        public string PCountryOfBirth { get; set; }
        public string PNationality { get; set; }
        public string PPPhone { get; set; }
        public decimal? PNoOfChild { get; set; }
        public string PPersonalEmail { get; set; }
        public string PPMobile { get; set; }
        public decimal? PIsPrimaryOpen { get; set; }
        public decimal? PIsSecondaryOpen { get; set; }
        public decimal? PIsNominationOpen { get; set; }
        public decimal? PIsMediclaimOpen { get; set; }
        public decimal? PIsAadhaarOpen { get; set; }
        public decimal? PIsPassportOpen { get; set; }
        public decimal? PIsGtliOpen { get; set; }
        public decimal? PNoDadHusbInName { get; set; }
        public string PHasPassport { get; set; }
        public string PGivenName { get; set; }
        public string PIssuedAt { get; set; }
        public string PPassportNo { get; set; }
        public DateTime? PExpiryDate { get; set; }
        public string PIsExport { get; set; }
        public string PFileType { get; set; }
        public string PFileName { get; set; }
        public string PRefNumber { get; set; }
        public string PHasAadhaar { get; set; }
        public string PExEmpno { get; set; }
        public string PSubmitStatus { get; set; }
        public string PFromCostcode { get; set; }
        public string PToCostcode { get; set; }
        public DateTime? PTransferDate { get; set; }
        public string PEmpName { get; set; }
        public string POfficeLocationCode { get; set; }
        public DateTime? PProposedDoj { get; set; }
        public DateTime? PRevisedDoj { get; set; }
        public string PJoinStatusCode { get; set; }
        public string PClient { get; set; }

        public decimal? PBlockreason { get; set; }
        public DateTime? PEmpResignDate { get; set; }
        public DateTime? PHrReceiptDate { get; set; }
        public DateTime? PDateOfRelieving { get; set; }
        public DateTime? PLastDateInOffice { get; set; }
        public string PEmpResignReason { get; set; }
        public string PPrimaryReason { get; set; }
        public string PSecondaryReason { get; set; }
        public string PAdditionalFeedback { get; set; }
        public string PInterviewComplete { get; set; }
        public decimal? PPercentIncrease { get; set; }
        public string PMovingToLocation { get; set; }
        public string PCurrentLocation { get; set; }
        public string PResignStatus { get; set; }
        public string PCommitmentOnrollback { get; set; }
        public string PDepartment { get; set; }
        public string PGrade { get; set; }
        public string PDesignation { get; set; }
        public string PPcModelList { get; set; }
        public string PMonitorModel { get; set; }
        public decimal? PDualMonitor { get; set; }
        public decimal? PVacantDesk { get; set; }
        public string PTelephoneModel { get; set; }
        public string PPrinterModel { get; set; }
        public string PDocstnModel { get; set; }
        public string PFromDept { get; set; }
        public string PToDept { get; set; }
        public string PResignStatusCode { get; set; }
        public DateTime? PJoiningDate { get; set; }
        public string[] PEmpWithCostcodeArray { get; set; }
        public string PLot { get; set; }
        public decimal? PStatus { get; set; }
        public string PEmpType { get; set; }

        public string PEmploymentType { get; set; }
        public string PSourcesOfCandidate { get; set; }
        public string PPreEmplmntMedclTest { get; set; }
        public string PRePreEmplmntMedclTest { get; set; }
        public string PRecForAppt { get; set; }
        public string PReRecAppt { get; set; }
        public string POfferLetter { get; set; }

        public DateTime? PMedclRequestDate { get; set; }
        public DateTime? PActualApptDate { get; set; }
        public DateTime? PMedclFitnessCert { get; set; }
        public DateTime? PRecIssued { get; set; }
        public DateTime? PRecReceived { get; set; }

        public Byte[] PMovemastJson { get; set; }
        public string PPrincipalEmpno { get; set; }
        public string POnBehalfEmpno { get; set; }
        public string PYear { get; set; }
        public string PEmpnoCsv { get; set; }

        public string PIsConsent { get; set; }

        public string PAssign { get; set; }
        public string PWpcode { get; set; }
        public string PActivity { get; set; }
        public decimal? PHours { get; set; }
        public string PYymm { get; set; }
        public DateTime? PEndByDate { get; set; }
        public DateTime? PRelievingDate { get; set; }
        public DateTime? PResignationDate { get; set; }
        public string PAddress { get; set; }
        public string PAlternateMobile { get; set; }
        public string PPrimaryMobile { get; set; }
        public string PEmailId { get; set; }
        public string PStartYear { get; set; }
        public string PEndYear { get; set; }
        public string PApprlActionId { get; set; }
        public string PMonth { get; set; }
        public string PVendor { get; set; }
        public DateTime? PInvoiceDate { get; set; }
        public DateTime? PWarrantyEndDate { get; set; }
        public DateTime? PEmpJoiningDate { get; set; }
        public string PSitemapId { get; set; }
        public decimal? PIsDisplayPremium { get; set; }
        public decimal? PIsDraft { get; set; }
        public decimal? PIsInitiateConfig { get; set; }
        public decimal? PIsApplicableToAll { get; set; }
        public string PJsonObj { get; set; }
        public string PUpdateType { get; set; }
        public string PFromYyyymm { get; set; }
        public string PToYyyymm { get; set; }
        public string PQuizId { get; set; }
        public string PQuestionId1 { get; set; }
        public string PQuestionId2 { get; set; }
        public string PQuestionId3 { get; set; }
        public string PQuestionId4 { get; set; }
        public string PQuestionId5 { get; set; }
        public string PQuestionId6 { get; set; }
        public string PQuestionId7 { get; set; }
        public string PQuestionId8 { get; set; }
        public string PQuestionId9 { get; set; }
        public string PQuestionId10 { get; set; }
        public decimal? PAnswerId1 { get; set; }
        public decimal? PAnswerId2 { get; set; }
        public decimal? PAnswerId3 { get; set; }
        public decimal? PAnswerId4 { get; set; }
        public decimal? PAnswerId5 { get; set; }
        public decimal? PAnswerId6 { get; set; }
        public decimal? PAnswerId7 { get; set; }
        public decimal? PAnswerId8 { get; set; }
        public decimal? PAnswerId9 { get; set; }
        public decimal? PAnswerId10 { get; set; }
        public decimal? PTransferType { get; set; }
        public string PCurrentCostcode { get; set; }
        public string PTargetCostcode { get; set; }
        public DateTime? PEffectiveTransferDate { get; set; }
        public string PDesgcode { get; set; }
        public string PProcessMail { get; set; }
        public string PApprovalAction { get; set; }
        public string POfficeCode { get; set; }
        public string POfficeName { get; set; }
        public string POfficeDesc { get; set; }
        public string PSmartDeskBookingEnabled { get; set; }
        public string PShift { get; set; }
        public string PDeskArea { get; set; }
        public DateTime? PAttendanceDate { get; set; }
        public DateTime? PFromDate { get; set; }
        public DateTime? PToDate { get; set; }

        public string PSiteName { get; set; }
        public string PSiteLocation { get; set; }
        public string PSiteCode { get; set; }
        public string PApprovalRemarks { get; set; }
        public decimal? PAcceptanceStatus { get; set; }
        public string PColleagueName { get; set; }
        public string PColleagueDept { get; set; }
        public string PColleagueRelation { get; set; }
        public string PColleagueLocation { get; set; }
        public string PColleagueEmpno { get; set; }
        public string PRelativeExists { get; set; }
        public string PHrComments { get; set; }
        public DateTime? PTransferEndDate { get; set; }
        public string PJobGroupCode { get; set; }
        public string PJobdisciplineCode { get; set; }
        public string PJobtitleCode { get; set; }
        public decimal? PPrintOrder { get; set; }
        public string PCostCode { get; set; }
        public string PAreaType { get; set; }
        public string PProjectNo { get; set; }

        public decimal? PIsRestricted { get; set; }
        public string PDeskType { get; set; }
        public string PTagId { get; set; }
        public string PObjId { get; set; }
        public string PObjTypeId { get; set; }
        public string PTag { get; set; }
        public string[] PDeskAreaDesk { get; set; }
        public string[] PDeskAreaUser { get; set; }
        public decimal? PIsPresent { get; set; }
        public decimal? PIsDeskBooked { get; set; }
        public decimal? PIsCrossAttend { get; set; }

        public string PEmailSent { get; set; }
        public string PGroupKeyId { get; set; }
        public string PRegionCode { get; set; }
        public string PRegionName { get; set; }
        public DateTime? PHoliday { get; set; }
        public string PWeekday { get; set; }
        public string PPayslipYyyymm { get; set; }
        public string PAdjType { get; set; }
        public string PAppNo { get; set; }
        public byte[] PLopJson { get; set; }
        public byte[] PEmpOfficeLocationJson { get; set; }

        public string PShowSatSun { get; set; }
        public string PApprovalFrom { get; set; }
        public string PYyymm { get; set; }
        public string PDelegationIsActive { get; set; }
        public string PShiftcode { get; set; }
        public string PShiftdesc { get; set; }
        public decimal? PTimeinHh { get; set; }
        public decimal? PTimeinMn { get; set; }
        public decimal? PTimeoutHh { get; set; }
        public decimal? PTimeoutMn { get; set; }
        public decimal? PShift4allowance { get; set; }
        public decimal? PLunchMn { get; set; }
        public decimal? POtApplicable { get; set; }

        public decimal? PChFdStartMi { get; set; }
        public decimal? PChFdEndMi { get; set; }
        public decimal? PChFhStartMi { get; set; }
        public decimal? PChFhEndMi { get; set; }
        public decimal? PChShStartMi { get; set; }
        public decimal? PChShEndMi { get; set; }
        public decimal? PFullDayWorkMi { get; set; }
        public decimal? PHalfDayWorkMi { get; set; }
        public decimal? PFullWeekWorkMi { get; set; }
        public decimal? PWorkHrsStartMi { get; set; }
        public decimal? PWorkHrsEndMi { get; set; }
        public decimal? PFirstPunchAfterMi { get; set; }
        public decimal? PLastPunchBeforeMi { get; set; }

        public decimal? PLunchStartMi { get; set; }
        public decimal? PLunchEndMi { get; set; }
        public decimal? PHdFhStartMi { get; set; }
        public decimal? PHdFhEndMi { get; set; }
        public decimal? PHdShStartMi { get; set; }
        public decimal? PHdShEndMi { get; set; }

        public string PProjnoFrom { get; set; }

        public string PProjnoTo { get; set; }

        public string PLogId { get; set; }
        public string PAssetType { get; set; }
        public string PGroupType { get; set; }
        public string PConfirmationStatus { get; set; }
        public string PEmptype { get; set; }
        public string PTlpcode { get; set; }
        public string PActivityType { get; set; }
        public decimal? PBudghrs { get; set; }
        public decimal? PNoOfDocs { get; set; }
        public decimal? PWorkDays { get; set; }
        public decimal? PWeekend { get; set; }
        public decimal? PHolidays { get; set; }
        public decimal? PLeave { get; set; }
        public decimal? PTotDays { get; set; }
        public decimal? PWorkingHr { get; set; }
        public DateTime? PApprby { get; set; }
        public DateTime? PPostby { get; set; }
        public string PSchemaname { get; set; }
        public decimal? POt { get; set; }

        public decimal? PMovement { get; set; }
        public decimal? PMovetotcm { get; set; }
        public decimal? PMovetosite { get; set; }
        public decimal? PMovetoothers { get; set; }
        public decimal? PExtSubcontract { get; set; }
        public decimal? PFutRecruit { get; set; }
        public decimal? PIntDept { get; set; }
        public decimal? PHrsSubcont { get; set; }

        public string PStartmonth { get; set; }
        public decimal? PChangedNemps { get; set; }
        public byte[] PParameterBlob { get; set; }
        public byte[] PEmpnoJson { get; set; }
        public byte[] PModuleUserRolesBulkJson { get; set; }
        public string PViewType { get; set; }
    }
}