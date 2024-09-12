using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.OffBoarding;

namespace TCMPLApp.DataAccess.Repositories.OffBoarding
{
    public class OffBoardingExitRepository : Base.ExecRepository, IOffBoardingExitRepository
    {

        //private readonly static string MakerRoleId = "R03";
        //private readonly static string CheckerRoleId = "R04";
        //private readonly static string HoDRoleId = "R02";
        //private readonly static string HRManagerRoleId = "R06";


        private readonly static string ApprovalPending = "KO";
        private readonly static string ApprovalApproved = "OK";


        public OffBoardingExitRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {
        }

        public async Task<IEnumerable<OffBoardingExit>> GetExitsListAsync()
        {
            return await QueryAsync<OffBoardingExit>(OffBoardingQueries.InitOffBoardingExitList);
        }

        public async Task<OffBoardingExit> GetEmployeeExitDetails(string Empno)
        {
            return await QueryFirstOrDefaultAsync<OffBoardingExit>(OffBoardingQueries.GetEmployeeExitDetails, new { pEmpno = Empno });

        }

        public async Task<IEnumerable<OffBoardingExitsContactDetails>> GetEmployeeContactDetailsList(DateTime StartDate, DateTime EndDate)
        {
            return await QueryAsync<OffBoardingExitsContactDetails>(OffBoardingQueries.InitOffBoardingExitContactDetailsList, new { pStartDate = StartDate, pEndDate = EndDate });
        }


        public async Task<OffBoardingExitAddNew> ExitAddNewAsync(OffBoardingExitAddNew offBoardingExitAddNew)
        {
            var retval = await ExecuteProcAsync(offBoardingExitAddNew);
            return retval;
        }


        public async Task<OffBoardingExitsModExit> ExitModifyAsync(OffBoardingExitsModExit offBoardingExitsModExit)
        {
            var retval = await ExecuteProcAsync(offBoardingExitsModExit);
            return retval;
        }


        public async Task<IEnumerable<DdlModel>> GetEmployeeForExitsSelectAsync()
        {
            return await QueryAsync<DdlModel>(OffBoardingQueries.EmployeeForExitsSelect);
        }

        #region M A K E R

        public async Task<IEnumerable<OffBoardingExit>> MakerGetExitsPendingListAsync(string MakerEmpNo)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.MakerOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = MakerEmpNo,
                                                            pApproverRoleId = OffBoardingHelper.RoleMakerApprover,
                                                            pApprovalStatus = ApprovalPending
                                                        }
                                                    );
        }

        public async Task<IEnumerable<OffBoardingExit>> MakerGetExitsHistoryListAsync(string MakerEmpNo)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.MakerOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = MakerEmpNo,
                                                            pApproverRoleId = OffBoardingHelper.RoleMakerApprover,
                                                            pApprovalStatus = ApprovalApproved
                                                        }
                                                    );
        }

        public async Task<OffBoardingEmployeeExitApprovals> GetExitsApprovalDetailAsync(string EmpNo, string ActionId, string RoleId)
        {
            return await QueryFirstOrDefaultAsync<OffBoardingEmployeeExitApprovals>(OffBoardingQueries.GetExitsApprovalDetail, new { pEmpno = EmpNo, pActionId = ActionId, pRoleId = RoleId });
        }

        public async Task<OffBoardingExitFirstApproval> MakerExitsApproveAsync(OffBoardingExitFirstApproval offBoardingExitMakerApproval)
        {
            return await ExecuteProcAsync(offBoardingExitMakerApproval);
        }

        #endregion M A K E R


        #region C H E C K E R

        public async Task<IEnumerable<OffBoardingExit>> CheckerGetExitsPendingListAsync(string CheckerEmpNo, string ActionId)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.ApproverOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = CheckerEmpNo,
                                                            pApproverRoleId = OffBoardingHelper.RoleCheckerApprover,
                                                            pApprovalStatus = ApprovalPending,
                                                            pActionId = ActionId
                                                        }
                                                    );
        }

        public async Task<IEnumerable<OffBoardingExit>> CheckerGetExitsHistoryListAsync(string CheckerEmpNo, string ActionId)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.ApproverOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = CheckerEmpNo,
                                                            pApproverRoleId = OffBoardingHelper.RoleCheckerApprover,
                                                            pApprovalStatus = ApprovalApproved,
                                                            pActionId = ActionId
                                                        }
                                                    );
        }

        public async Task<OffBoardingEmployeeExitApprovals> CheckerGetExitsApprovalDetailAsync(string EmpNo, string ApproverEmpno, string RoleId)
        {
            return await QueryFirstOrDefaultAsync<OffBoardingEmployeeExitApprovals>(OffBoardingQueries.GetExitsApprovalDetail, new { pEmpno = EmpNo, pApproverEmpno = ApproverEmpno, pRoleId = RoleId });
        }

        public async Task<OffBoardingExitSecondApproval> CheckerExitsApproveAsync(OffBoardingExitSecondApproval offBoardingExitCheckerApproval)
        {
            return await ExecuteProcAsync(offBoardingExitCheckerApproval);
        }

        public async Task<IEnumerable<OffBoardingEmployeeExitApprovals>> GetDescendantExitApprovals(string OFBEmpno, string SecondApproverActionId)
        {

            return await QueryAsync<OffBoardingEmployeeExitApprovals>(OffBoardingQueries.GetDescendantExitApprovals, new { pOFBEmpno = OFBEmpno, pSecondApproverActionId = SecondApproverActionId });

        }


        public async Task<OffBoardingChildApprovalsStatus> GetDescendantExitApprovalsStatus(OffBoardingChildApprovalsStatus offBoardingChildApprovalsStatus)
        {
            return await ExecuteProcAsync<OffBoardingChildApprovalsStatus>(offBoardingChildApprovalsStatus);
        }


        public async Task<IEnumerable<OffBoardingEmployeeExitApprovals>> GetGroupApprovalsAsync(string OFBEmpno, string ActionId)
        {
            return await QueryAsync<OffBoardingEmployeeExitApprovals>(OffBoardingQueries.GetGroupApprovals, new { pOfbEmpno = OFBEmpno, pCheckerActionId = ActionId });
        }

        #endregion C H E C K E R


        #region H o D

        public async Task<IEnumerable<OffBoardingExit>> HoDGetExitsPendingListAsync(string HoDEmpNo)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.HoDOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = HoDEmpNo,
                                                            pApproverRoleId = OffBoardingHelper.RoleOffBoardingEmployeeHoD,
                                                            pApprovalStatus = ApprovalPending
                                                        }
                                                    );
        }

        public async Task<IEnumerable<OffBoardingExit>> HoDGetExitsHistoryListAsync(string HoDEmpNo)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.HoDOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = HoDEmpNo,
                                                            pApproverRoleId = OffBoardingHelper.RoleOffBoardingEmployeeHoD,
                                                            pApprovalStatus = ApprovalApproved
                                                        }
                                                    );
        }


        public async Task<OffBoardingExitHoDApproval> HoDExitsApproveAsync(OffBoardingExitHoDApproval offBoardingExitHoDApproval)
        {
            return await ExecuteProcAsync(offBoardingExitHoDApproval);
        }

        #endregion H o D


        #region  H R   M A N A G E R 

        public async Task<IEnumerable<OffBoardingExit>> HRManagerGetExitsPendingListAsync(string HRManagerEmpno)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.HRManagerOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = HRManagerEmpno,
                                                            pApproverRoleId = OffBoardingHelper.RoleOffBoardingFinalApprover,
                                                            pApprovalStatus = ApprovalPending
                                                        }
                                                    );
        }

        public async Task<IEnumerable<OffBoardingExit>> HRManagerGetExitsHistoryListAsync(string HRManagerEmpno)
        {
            return await QueryAsync<OffBoardingExit>(
                                                        OffBoardingQueries.HRManagerOffBoardingExitList,
                                                        new
                                                        {
                                                            pApproverEmpno = HRManagerEmpno,
                                                            pApproverRoleId = OffBoardingHelper.RoleOffBoardingFinalApprover,
                                                            pApprovalStatus = ApprovalApproved
                                                        }
                                                    );
        }


        public async Task<OffBoardingExitHRManagerApproval> HRManagerExitsApproveAsync(OffBoardingExitHRManagerApproval OffBoardingExitHRManagerApproval)
        {
            return await ExecuteProcAsync(OffBoardingExitHRManagerApproval);
        }


        public async Task<IEnumerable<OffBoardingEmployeeExitApprovals>> GetDepartmentExitApprovals(string OFBEmpno)
        {

            return await QueryAsync<OffBoardingEmployeeExitApprovals>(OffBoardingQueries.GetDepartmentExitApprovals, new { pOFBEmpno = OFBEmpno });

        }


        public async Task<OffBoardingCheckHrManagerCanApprove> CheckHRManagerCanApproveExit(OffBoardingCheckHrManagerCanApprove offBoardingCheckHrManagerCanApprove)
        {
            return await ExecuteProcAsync(offBoardingCheckHrManagerCanApprove);
        }
        #endregion  H R   M A N A G E R 


        #region U s e r   C o n t a c t   I n f o 

        public async Task<OffBoardingExitUpdateUserContactInfo> UpdateEmployeeContactInfo(OffBoardingExitUpdateUserContactInfo offBoardingExitUpdateUserContactInfo)
        {
            return await ExecuteProcAsync(offBoardingExitUpdateUserContactInfo);
        }

        public async Task<OffBoardingEmployeeContactInfo> GetEmployeeContactInfo(string Empno)
        {
            return await QueryFirstOrDefaultAsync<OffBoardingEmployeeContactInfo>(OffBoardingQueries.GetEmployeeContactInfo, new { pEmpno = Empno });
        }


        #endregion U s e r   C o n t a c t   I n f o 


        public async Task<OffBoardingResetApproval> ResetApprovalAsync(OffBoardingResetApproval offBoardingResetApproval)
        {
            return await ExecuteProcAsync(offBoardingResetApproval);
        }


        public async Task<OffBoardingFilesAddFile> AddFileAsync(OffBoardingFilesAddFile offBoardingFilesAddFile)
        {
            return await ExecuteProcAsync(offBoardingFilesAddFile);
        }

        public async Task<OffBoardingRemoveFile> DeleteFileAsync(OffBoardingRemoveFile offBoardingRemoveFile)
        {
            return await ExecuteProcAsync(offBoardingRemoveFile);
        }


        public async Task<IEnumerable<OffBoardingFilesUploaded>> GetFilesUploadedListByGroupAsync(string Empno, string GroupName)
        {
            return await QueryAsync<OffBoardingFilesUploaded>(OffBoardingQueries.GetFilesUploadedByGroup, new { pEmpno = Empno, pGroupName = GroupName });
        }

        public async Task<IEnumerable<OffBoardingFilesUploaded>> GetAllFilesUploadedListAsync(string Empno)
        {
            return await QueryAsync<OffBoardingFilesUploaded>(OffBoardingQueries.GetFilesUploaded, new { pEmpno = Empno });
        }

        public async Task<OffBoardingFilesUploaded> GetFileUploadedByKeyIdAsync(string KeyId)
        {
            return await QueryFirstOrDefaultAsync<OffBoardingFilesUploaded>(OffBoardingQueries.GetFileUploadedByKeyId, new { pKeyId = KeyId });
        }


        public async Task<OffBoardingActions> GetActionAttributesAsync(string ActionId)
        {
            return await QueryFirstOrDefaultAsync<OffBoardingActions>(OffBoardingQueries.GetActions, new { pActionId = ActionId });
        }




    }
}
