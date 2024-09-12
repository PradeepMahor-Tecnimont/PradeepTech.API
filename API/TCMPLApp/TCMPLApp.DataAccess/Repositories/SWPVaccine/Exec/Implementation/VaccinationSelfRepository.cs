using System;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Configuration;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Data;
using ClosedXML.Excel;
using System.IO;
using System.Collections.Generic;
using TCMPLApp.DataAccess.Base;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class VaccinationSelfRepository : ExecRepository, IVaccinationSelfRepository
    {
        
        readonly DataContext _dataContext;
        

        public VaccinationSelfRepository(IConfiguration configuration, DataContext dataContext, ExecDBContext execDBContext) : base(execDBContext)
        {
            _dataContext = dataContext;
        }

        public async Task<SwpVaccineDate> VaccineDateDetails(string userWinUid)
        {
            return await QueryFirstOrDefaultAsync<SwpVaccineDate>("select * from selfservice.SWP_Vaccine_Dates where empno = selfservice.swp_users.get_empno_from_win_uid(:param_win_uid)", new { param_win_uid = userWinUid });
        }


        public async Task<ProcedureResult> Create(string userWinUid, string VaccineType, DateTime firstJabDate, DateTime? secondJabDate)
        {
            var obj = new { Param_Win_Uid = userWinUid,param_vaccine_type= VaccineType, param_first_jab = firstJabDate, param_second_jab = secondJabDate};
            var retVal = await ExecuteProc("selfservice.swp_vaccinedate.add_new", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }

        public async Task<ProcedureResult> UpdateSelfJabs(string userWinUid, DateTime? secondJabDate, DateTime? boosterJabDate)
        {
            var obj = new { Param_Win_Uid = userWinUid, param_second_jab_date = secondJabDate, param_booster_jab_date = boosterJabDate };

            var retVal = await ExecuteProc("selfservice.swp_vaccinedate.update_self_jab", obj);
            return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        }

        //public async Task<ProcedureResult> UpdateVaccineType(string userWinUid,string vaccineType, DateTime? secondJabDate,DateTime? boosterJabDate)
        //{
        //    var obj = new { Param_Win_Uid = userWinUid, 
        //        param_vaccine_type = vaccineType,  
        //        param_second_jab = secondJabDate,
        //        param_booster_date = boosterJabDate };
        //    var retVal = await ExecuteProc("selfservice.swp_vaccinedate.update_vaccine_type", obj);
        //    return new ProcedureResult { Status = retVal.Status, Message = retVal.Message };
        //}

        public IEnumerable<DdlModel> SelectListVaccineTypes()
        {
            var ddlFields = (from v in _dataContext.SwpVaccineMaster
                             select new DdlModel
                             {
                                 Text = v.VaccineType,
                                 Val = v.VaccineType
                             }).AsEnumerable();
            return ddlFields;
        }
    }
}
