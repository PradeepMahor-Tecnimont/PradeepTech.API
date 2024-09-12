using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Configuration;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Models.SWPVaccine;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class EmployeePolicyRepository : ExecRepository, IEmployeePolicyRepository
    {
        readonly DataContext _dataContext;
        

        public EmployeePolicyRepository(DataContext dataContext, ExecDBContext execDBContext):base(execDBContext)
        {
            
            _dataContext = dataContext;
        }

        public async Task<ProcedureResult> SWPPreCheck(string userWinUid)
        {
            var inParamList = new { Param_Win_Uid = userWinUid };
            var outParamList = new { param_swp_exists = "", param_user_can_do_swp = "", param_is_iphone_user = "" };
            var retVal = await ExecuteProc("selfservice.swp.check_details", inParamList, outParamList);
            return new ProcedureResult { Status=retVal.Status, Message = retVal.Message };
        }

        public async Task<ProcedureResult> Create(string userWinUid, EmployeePolicyExecModel employeePolicy)
        {
            var obj = new
            {
                Param_Win_Uid = userWinUid,
                param_is_accepted = employeePolicy.PolicyAccepted ? "OK" : "KO",
                param_download_speed = employeePolicy.DownloadSpeed,
                param_upload_speed = employeePolicy.UploadSpeed,
                param_monthly_quota = employeePolicy.MonthlyQuota,
                param_isp_name = employeePolicy.ISP,
                param_router_brand = employeePolicy.RouterBrand,
                param_router_model = employeePolicy.RouterModel,
                param_msauth_on_own_mob = employeePolicy.MSAuthOnOwnMob
            };
            var retVal = await ExecuteProc("selfservice.swp.swp_create", obj);
            return new ProcedureResult {  Status=retVal.Status,Message=retVal.Message};
        }

        public async Task<SwpVuEmpResponse> EmpSWPDetails(string userWinUid)
        {
            return await QueryFirstOrDefaultAsync<SwpVuEmpResponse>("select * from selfservice.SWP_VU_EMP_RESPONSE where empno = selfservice.swp_users.get_empno_from_win_uid(:param_win_uid)", new { param_win_uid = userWinUid });
        }

        public async Task<SwpEmpTraining> EmpTrainingDetails(string userWinUid)
        {

            var empTraining = await QueryFirstOrDefaultAsync<SwpEmpTraining>("select * from selfservice.SWP_EMP_TRAINING where empno = selfservice.swp_users.get_empno_from_win_uid(:param_win_uid)", new { param_win_uid = userWinUid });
            if (empTraining == null)
            {
                empTraining = new SwpEmpTraining
                {
                    Onedrive365 = false,
                    Planner = false,
                    Security = false,
                    Sharepoint16 = false,
                    Teams = false
                };
            }
            return empTraining;
        }


        public IEnumerable<DdlModel> SelectListISP()
        {
            var ddlFields = (from isp in _dataContext.SwpISPs
                             select new DdlModel
                             {
                                 Text = isp.IspName,
                                 Val = isp.IsEligible
                             }).AsEnumerable();
            return ddlFields;
        }

    }
}
