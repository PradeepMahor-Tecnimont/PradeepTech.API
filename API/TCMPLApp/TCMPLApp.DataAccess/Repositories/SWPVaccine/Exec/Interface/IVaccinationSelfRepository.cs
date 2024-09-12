using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Data;
using System;
using System.Collections.Generic;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IVaccinationSelfRepository
    {
        public Task<SwpVaccineDate> VaccineDateDetails(string userWinUid);
        public Task<ProcedureResult> Create(string userWinUid, string VaccineType, DateTime firstJabDate, DateTime? secondJabDate);

        public Task<ProcedureResult> UpdateSelfJabs(string userWinUid, DateTime? secondJabDate, DateTime? boosterJabDate);
        //public Task<ProcedureResult> UpdateVaccineType(string userWinUid, string vaccineType, DateTime? secondJabDate);


        public IEnumerable<DdlModel> SelectListVaccineTypes();

    }
}
