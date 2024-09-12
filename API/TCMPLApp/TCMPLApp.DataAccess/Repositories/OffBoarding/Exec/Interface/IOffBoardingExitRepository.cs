using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public interface IOffBoardingExitRepository
    {

        public Task<OffBoardingExit> GetEmployeeExitDetails(string Empno);


        #region I N I T I A T O R
        public Task<IEnumerable<OffBoardingExit>> GetExitsListAsync();

        public Task<IEnumerable<OffBoardingExitsContactDetails>> GetEmployeeContactDetailsList(DateTime StartDate, DateTime EndDate);

        public Task<OffBoardingExitAddNew> ExitAddNewAsync(OffBoardingExitAddNew offBoardingExitAddNew);

        public Task<IEnumerable<DdlModel>> GetEmployeeForExitsSelectAsync();

        public Task<OffBoardingExitsModExit> ExitModifyAsync(OffBoardingExitsModExit offBoardingExitsModExit);


        #endregion I N I T I A T O R

        #region M A K E R

        public Task<IEnumerable<OffBoardingExit>> MakerGetExitsPendingListAsync(string MakerEmpNo);
        public Task<IEnumerable<OffBoardingExit>> MakerGetExitsHistoryListAsync(string MakerEmpNo);

        public Task<OffBoardingEmployeeExitApprovals> GetExitsApprovalDetailAsync(string EmpNo, string ActionId, string RoleId);

        public Task<OffBoardingExitFirstApproval> MakerExitsApproveAsync(OffBoardingExitFirstApproval offBoardingExitMakerApproval);

        #endregion M A K E R

        public Task<OffBoardingActions> GetActionAttributesAsync(string ActionId);

        #region C H E C K E R

        public Task<IEnumerable<OffBoardingExit>> CheckerGetExitsPendingListAsync(string CheckerEmpNo, string ActionId);
        public Task<IEnumerable<OffBoardingExit>> CheckerGetExitsHistoryListAsync(string CheckerEmpNo, string ActionId);

        public Task<OffBoardingExitSecondApproval> CheckerExitsApproveAsync(OffBoardingExitSecondApproval offBoardingExitCheckerApproval);

        public Task<IEnumerable<OffBoardingEmployeeExitApprovals>> GetDescendantExitApprovals(string OFBEmpno, string SecondApproverActionId);

        public Task<OffBoardingChildApprovalsStatus> GetDescendantExitApprovalsStatus(OffBoardingChildApprovalsStatus offBoardingChildApprovalsStatus);

        public Task<IEnumerable<OffBoardingEmployeeExitApprovals>> GetGroupApprovalsAsync(string OFBEmpno, string ActionId);


        #endregion C H E C K E R

        #region H o D

        public Task<IEnumerable<OffBoardingExit>> HoDGetExitsPendingListAsync(string HoDEmpNo);
        public Task<IEnumerable<OffBoardingExit>> HoDGetExitsHistoryListAsync(string HoDEmpNo);

        public Task<OffBoardingExitHoDApproval> HoDExitsApproveAsync(OffBoardingExitHoDApproval offBoardingExitHoDApproval);

        #endregion


        #region H R   M A N A G E R 

        public Task<IEnumerable<OffBoardingExit>> HRManagerGetExitsPendingListAsync(string HoDEmpNo);
        public Task<IEnumerable<OffBoardingExit>> HRManagerGetExitsHistoryListAsync(string HoDEmpNo);

        public Task<OffBoardingExitHRManagerApproval> HRManagerExitsApproveAsync(OffBoardingExitHRManagerApproval offBoardingExitHRManagerApproval);

        public Task<IEnumerable<OffBoardingEmployeeExitApprovals>> GetDepartmentExitApprovals(string OFBEmpno);

        public Task<OffBoardingCheckHrManagerCanApprove> CheckHRManagerCanApproveExit(OffBoardingCheckHrManagerCanApprove offBoardingCheckHrManagerCanApprove);

        #endregion H R   M A N A G E R 


        #region U s e r   I n f o 

        public Task<OffBoardingExitUpdateUserContactInfo> UpdateEmployeeContactInfo(OffBoardingExitUpdateUserContactInfo offBoardingExitUpdateUserContactInfo);

        public Task<OffBoardingEmployeeContactInfo> GetEmployeeContactInfo(string Empno);

        #endregion U s e r   I n f o 

        public Task<OffBoardingFilesAddFile> AddFileAsync(OffBoardingFilesAddFile offBoardingFilesAddFile);

        public Task<IEnumerable<OffBoardingFilesUploaded>> GetAllFilesUploadedListAsync(string Empno);
        public Task<IEnumerable<OffBoardingFilesUploaded>> GetFilesUploadedListByGroupAsync(string Empno, string GroupName);

        public Task<OffBoardingFilesUploaded> GetFileUploadedByKeyIdAsync(string KeyId);

        public Task<OffBoardingResetApproval> ResetApprovalAsync(OffBoardingResetApproval offBoardingResetApproval);

        public Task<OffBoardingRemoveFile> DeleteFileAsync(OffBoardingRemoveFile offBoardingRemoveFile);

    }
}
