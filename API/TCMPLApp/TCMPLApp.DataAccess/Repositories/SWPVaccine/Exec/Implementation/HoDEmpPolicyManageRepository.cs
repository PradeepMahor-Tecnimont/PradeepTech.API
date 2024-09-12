using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class HoDEmpPolicyManageRepository : ExecRepository, IHoDEmpPolicyManageRepository
    {
        //private readonly ExecContext _execContext;
        

        public HoDEmpPolicyManageRepository(IConfiguration configuration, ExecDBContext execDBContext) : base(execDBContext)
        {
            
            //_execContext = new ExecContext(configuration);
        }

        public IEnumerable<DataField> GetHodfilterListForDropDown()
        {
            List<DataField> HodfilterList = new List<DataField>();
            HodfilterList.Add(new DataField() { DataTextField = "Pending", DataValueField = "Pending" });
            HodfilterList.Add(new DataField() { DataTextField = "Approved", DataValueField = "Approved" });
            HodfilterList.Add(new DataField() { DataTextField = "Rejected", DataValueField = "Rejected" });
            HodfilterList.Add(new DataField() { DataTextField = "All", DataValueField = "All" });

            return HodfilterList;
        }

        public async Task<IEnumerable<SwpVuEmpResponse>> GetPendingApprovalList(string userWinUid, string FilterByStatus)
        {
            string strSql = "";

            object inParamList;

            if (FilterByStatus == "null" || string.IsNullOrEmpty(FilterByStatus))
            {
                FilterByStatus = "Pending";
            }

            strSql = SWPVaccineQueries.HoDSWPPendingApprovals;

            if (FilterByStatus == "All")
            {
                inParamList = new { Param_Win_Uid = userWinUid };
            }
            else
            {
                strSql += " And Nvl(HoD_apprl,'OO') = :Param_HOD_APPRL";

                string param_approval_state = "";

                switch (FilterByStatus)
                {
                    case "Pending":
                        param_approval_state = "OO";
                        break;
                    case "Approved":
                        param_approval_state = "OK";
                        break;
                    case "Rejected":
                        param_approval_state = "KO";
                        break;
                }
                inParamList = new { Param_Win_Uid = userWinUid, Param_HOD_APPRL = param_approval_state };
            }

            return await QueryAsync<SwpVuEmpResponse>(strSql, inParamList);
        }

        public async Task<ProcedureResult> Reject(string empNo, string Win_Hod_Uid)
        {
            var obj = new { param_empno = empNo, param_hod_win_uid = Win_Hod_Uid };
            var retVal = await ExecuteProc("selfservice.swp.swp_hod_reject", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }

        public async Task<ProcedureResult> Approve(string jSon, string Win_Hod_Uid)
        {
            var obj = new { p_json = jSon, param_hod_win_uid = Win_Hod_Uid };
            var retVal = await ExecuteProc("selfservice.swp.swp_hod_appr", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }
    }
}