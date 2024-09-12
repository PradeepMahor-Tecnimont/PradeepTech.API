using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public static class OffBoardingHelper
    {
        #region OldRoleAndActions

        public const string ActionMakerGense = "A0101";
        public const string ActionMakerAFC = "A0203";
        public const string ActionMakerITEquip = "A0204";
        public const string ActionMakerITMobile = "A0205";
        public const string ActionMakerTimeMgmt = "A0206";
        public const string ActionMakerPF = "A0207";
        public const string ActionMakerPayroll = "A0208";
        public const string ActionCheckerLibrary = "A0209";
        public const string ActionCheckerGense = "A0210";
        public const string ActionMakerStationery = "A0211";
        public const string ActionCheckerIT = "A0212";
        public const string ActionCheckerAFC = "A0213";
        public const string ActionCheckerPayroll = "A0214";
        public const string ActionCheckerTimeMgmt = "A0215";
        public const string ActionCheckerTimePF = "A0216";
        public const string ActionOffBoardingEmployeeHoD = "A0217";
        public const string ActionHRManager = "A0218";

        public const string RoleOffBoardingEmployee = "R0211";
        public const string RoleOffBoardingEmployeeHoD = "R0202";
        public const string RoleMakerApprover = "R0203";
        public const string RoleCheckerApprover = "R0204";
        public const string RoleInitiator = "R0205";
        public const string RoleOffBoardingFinalApprover = "R0206";
        public const string RoleManageRoles = "R0299";

        public const string CommonActionResetApprovals = "C0201";
        public const string CommonActionViewApprovals = "C0202";
        public const string CommonActionUploadFiles = "C0203";
        public const string CommonActionViewFiles = "C0204";
        public const string CommonActionViewOffBoardingStatus = "C0205";
        public const string CommonActionPrintExitForm = "C0206";

        #endregion OldRoleAndActions

        public const string ActionApproveRollbackRequest = "A198";
        public const string ActionCreateRollbackRequest = "A197";
        public const string ActionPrintExitForm = "A193";

        //First Approval
        public const string ActionFirstApprovalTimeManagement = "A175";
        public const string ActionFirstApprovalGENSE = "A177";
        public const string ActionFirstApprovalStationary = "A179";
        public const string ActionFirstApprovalAFC = "A180";
        public const string ActionFirstApprovalITEquipments = "A182";
        public const string ActionFirstApprovalITMobiles = "A183";
        public const string ActionFirstApprovalPF = "A186";
        public const string ActionFirstApprovalPayRoll = "A188";

        //Final Approval
        public const string ActionFinalApprovalTimeManagement = "A176";
        public const string ActionFinalApprovalGENSE = "A178";
        public const string ActionFinalApprovalAFC = "A181";
        public const string ActionFinalApprovalIT = "A184";
        public const string ActionFinalApprovalLibrary = "A185";
        public const string ActionFinalApprovalPF = "A187";
        public const string ActionFinalApprovalPayRoll = "A189";

        public const string ActionHodApproval = "A174";
        public const string ActionManagerHR = "A190";
        public const string ActionResetApprovals = "A191";
        public const string ActionViewApprovals = "A192";
        public const string ActionViewExitDetails = "A194";
        public const string ActionActionForApprovalTile = "A195";
        public const string ActionInitializeOffBoarding = "A196";

        public const string ActionNormalReport = "A199";
        public const string ActionClassifiedReport = "A200";
        public const string ActionViewSelfOFB = "A201";

        public const string ActionViewAllApprovals = "A202";
        public const string ActionViewHistory = "A203";

    }

}