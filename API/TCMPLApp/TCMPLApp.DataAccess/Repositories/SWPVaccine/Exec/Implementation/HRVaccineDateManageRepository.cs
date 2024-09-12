using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class HRVaccineDateManageRepository : ExecRepository, IHRVaccineDateManageRepository
    {
        
        private readonly DataContext _dataContext;
        
        public HRVaccineDateManageRepository(IConfiguration configuration,DataContext dataContext, ExecDBContext execDBContext) : base (execDBContext)
        {
            
            
            _dataContext = dataContext;
        }

        public IEnumerable<SwpVuEmpVaccineDate> GetEmpVaccineDateList()
        {
            //return  _execContext.QueryAsync<SwpVuEmpVaccineDate>("Select * from SWP_VU_EMP_Vaccine_Date", null);
            return _dataContext.SwpVuEmpVaccineDate.Select(t => t);

        }
        public async Task<ProcedureResult> DeleteEmpVaccineDates(string empNo, string win_Hr_Uid)
        {
            var obj = new { param_empno = empNo, param_hr_win_uid = win_Hr_Uid };
            var retVal = await ExecuteProc("selfservice.swp_vaccinedate.delete_emp_vaccine_dates", obj);
            return retVal;
        }

        public dynamic GetEmpVaccineDateTable()
        {
            return _dataContext.SwpVuEmpVaccineDate.Select(t => t);

            //return _execContext.QueryForDataTable("Select * from SWP_VU_EMP_Vaccine_Date", null);
        }
    
    
        public async Task<SwpVaccineDate> EmpVaccineDateDetails(string Empno)
        {
            return await QueryFirstOrDefaultAsync<SwpVaccineDate>("select * from selfservice.SWP_Vaccine_Dates where empno = selfservice.swp_users.get_empno_from_win_uid(:p_empno)", new { p_empno = Empno});
        }


        public async Task<ProcedureResult> UpdateEmpVaccineDates(string win_Hr_Uid, string ForEmpno, DateTime SecondJabDate, DateTime? BoosterJabDate)
        {
            var obj = new { param_win_uid = win_Hr_Uid, param_for_empno = ForEmpno, param_second_jab_date = SecondJabDate, param_booster_jab_date = BoosterJabDate };
            var retVal = await ExecuteProc("selfservice.swp_vaccinedate.update_emp_jab", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }

        public async Task<ProcedureResult> AddEmpVaccineDates(string win_Hr_Uid, string ForEmpno,string VaccineType,DateTime FirstJabDate, DateTime? SecondJabDate,DateTime? BoosterJabDate)
        {
            var obj = new { param_win_uid = win_Hr_Uid, 
                param_for_empno = ForEmpno, 
                param_first_jab_date = FirstJabDate,
                param_second_jab_date = SecondJabDate,
                param_vaccine_type = VaccineType,
                param_booster_jab_date = BoosterJabDate
            };
            var retVal = await ExecuteProc("selfservice.swp_vaccinedate.add_emp_vaccine_dates", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }


    }
}
