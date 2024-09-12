using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public static class OffBoardingProcedure
    {

        public static string OffBoardingExitFirstApproval
        {
            get => "TCMPL_HR.OFB_EXIT.approve_level_first";
        }

        public static string OffBoardingExitSecondApproval
        {
            get => "TCMPL_HR.OFB_EXIT.approve_level_second";
        }

        public static string OffBoardingExitHoDApproval
        {
            get => "TCMPL_HR.OFB_EXIT.APPROVE_HOD";
        }

        public static string OffBoardingExitHRManagerApproval
        {
            get => "TCMPL_HR.OFB_EXIT.APPROVE_HR_MANAGER";
        }

        public static string OffBoardingExitAddNew
        {
            get => "TCMPL_HR.OFB_EXIT.ADD_EXIT";
        }

        public static string OffBoardingChildApprovalsStatus
        {
            get => "TCMPL_HR.OFB_APPROVAL_STATUS.CHECK_CHILD_APPROVALS";
        }

        public static string OffBoardingCheckHRManagerCanApprove
        {
            get => "TCMPL_HR.OFB_APPROVAL_STATUS.HR_MANAGER_CAN_APPROVE";
        }

        public static string OffBoardingExitUpdateUserContactInfo
        {
            get => "TCMPL_HR.OFB_EXIT.UPDATE_USER_CONTACT_INFO";
        }
        public static string OffBoardingAddUserAccess
        {
            get => "TCMPL_HR.OFB_USER.ADD_USER_ACCESS";
        }
        public static string OffBoardingRemoveUserRoleAction
        {
            get => "TCMPL_HR.OFB_USER.REMOVE_USER_ROLE_ACTION";
        }


        public static string OffBoardingFilesAddFile
        {
            get => "TCMPL_HR.OFB_FILES_MANAGE.ADD_FILE";
        }

        public static string OffBoardingFilesRemoveFile
        {
            get => "TCMPL_HR.OFB_FILES_MANAGE.REMOVE_FILE";
        }

        public static string OffBoardingResetApproval
        {
            get => "TCMPL_HR.OFB_EXIT.RESET_APPROVAL";
        }

        public static string OffBoardingExitModifyExit
        {
            get => "TCMPL_HR.OFB_EXIT.MOD_EXIT";
        }

    }

}
