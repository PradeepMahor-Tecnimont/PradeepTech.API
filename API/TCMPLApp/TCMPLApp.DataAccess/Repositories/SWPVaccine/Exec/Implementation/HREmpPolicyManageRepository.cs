using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Configuration;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Data;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class HREmpPolicyManageRepository : ExecRepository, IHREmpPolicyManageRepository
    {
        
        private readonly DataContext _dataContext;
        

        public HREmpPolicyManageRepository(IConfiguration configuration, DataContext dataContext, ExecDBContext execDBContext):base(execDBContext)
        {
            

            
            _dataContext = dataContext;
        }

        public async Task<IEnumerable<SwpVuEmpResponse>> GetPendingApprovalList(string userWinUid, string FilterBy, string FilterByDept)
        {
            string strSql = "";
            string param_approval_state = "";


            object inParamList = null;


            if (FilterBy == "null" || string.IsNullOrEmpty(FilterBy))
            {
                FilterBy = "Pending";
            }

            if (FilterByDept == "null" || string.IsNullOrEmpty(FilterByDept))
            {
                FilterByDept = "ALL";
            }


            strSql = @" Select * from  selfservice.SWP_VU_EMP_RESPONSE ";

            if (FilterByDept.ToUpper() != "ALL")
            {
                strSql += " where PARENT=:param_dept ";
                inParamList = new { param_dept = FilterByDept };
            }

            if (FilterBy != "All")
            {
                if (FilterByDept.ToUpper() != "ALL")
                    strSql += " And ";
                else
                    strSql += " Where ";

                strSql += " nvl(HoD_Apprl,'OO') = 'OK' and nvl(HR_Apprl,'OO') = :param_hr_approval ";

                switch (FilterBy)
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
                if (inParamList == null)
                    inParamList = new { param_hr_approval = param_approval_state };
                else
                    inParamList = new { param_hr_approval = param_approval_state, param_dept = FilterByDept };

            }

            return await QueryAsync<SwpVuEmpResponse>(strSql, inParamList);
        }

        public IEnumerable<DataField> GetHRfilterListForDropDown()
        {
            List<DataField> HrfilterList = new List<DataField>();
            HrfilterList.Add(new DataField() {  DataTextField = "Pending", DataValueField = "Pending" });
            HrfilterList.Add(new DataField() {DataTextField = "Approved", DataValueField     = "Approved" });
            HrfilterList.Add(new DataField() { DataTextField = "Rejected", DataValueField = "Rejected" });
            HrfilterList.Add(new DataField() { DataTextField = "All", DataValueField = "All" });

            return HrfilterList;
        }

        public async Task<IEnumerable<DataField>> GetDeptListForDropDown()
        {
            //List<DataField> list = null;

            string strSql = @"select costcode as DataValueField , costcode ||' - '||name as DataTextField from selfservice.ss_costmast where active=1  ORDER BY name";

            var list = await QueryAsync<DataField>(strSql);

            //list = vDeptList.Select(i => new SelectListItem()
            //{
            //    Text = i.Text,
            //    Value = i.Val
            //}).ToList();

            //var newItem = new SelectListItem { Text = "All", Value = "All" };
            //list.Add(newItem);

            return list;
        }

        public async Task<ProcedureResult> Reject(string empNo, string win_Hr_Uid)
        {
            var obj = new { param_empno = empNo, param_hr_win_uid = win_Hr_Uid };
            var retVal = await ExecuteProc("selfservice.swp.swp_hr_reject", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }

        public async Task<ProcedureResult> Approve(string jSon, string win_Hr_Uid)
        {
            var obj = new { p_json = jSon, param_hr_win_uid = win_Hr_Uid };
            var retVal = await ExecuteProc("selfservice.swp.swp_hr_appr", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }

        public async Task<ProcedureResult> Reset(string empNo, string win_Hr_Uid)
        {
            var obj = new { param_empno = empNo, param_hr_win_uid = win_Hr_Uid };
            var retVal = await ExecuteProc("selfservice.swp.swp_hr_reset", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }

        public dynamic GetdataTable(string userWinUid, string FilterBy, string FilterByDept)
        {

            var retVal = _dataContext.SwpVuEmpResponses.Select(t => new { 
                                                        t.Empno,
                                                        t.Name,
                                                        t.Parent,
                                                        t.ParentName,
                                                        t.Grade,
                                                        t.Emptype,
                                                        PolicAcceptedStatus = t.IsPolicyAccepted,
                                                        HoDApprovalStatus = t.IsHodApproved,
                                                        HRApprovalStatus = t.IsHrApproved
                                                }).OrderBy(t=> t.Empno);

            return retVal;
        }


    }
}