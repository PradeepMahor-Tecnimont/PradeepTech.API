using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Data;
using System.Collections.Generic;
using System;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IHRVaccineDateManageRepository
    {
        public IEnumerable<SwpVuEmpVaccineDate> GetEmpVaccineDateList();
        public Task<ProcedureResult> DeleteEmpVaccineDates(string empNo, string win_Hr_Uid);

        public dynamic GetEmpVaccineDateTable();

        public Task<SwpVaccineDate> EmpVaccineDateDetails(string empNo);

        public Task<ProcedureResult> UpdateEmpVaccineDates(string win_Hr_Uid, string forEmpno, DateTime secondJabDate, DateTime? BoosterJabDate);

        public Task<ProcedureResult> AddEmpVaccineDates(string win_Hr_Uid, string ForEmpno, string VaccineType, DateTime FirstJabDate, DateTime? SecondJabDate,DateTime? BoosterJabDate);

    }
}
