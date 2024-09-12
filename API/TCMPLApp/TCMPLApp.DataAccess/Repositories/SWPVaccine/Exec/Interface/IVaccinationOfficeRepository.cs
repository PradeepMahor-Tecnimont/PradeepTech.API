using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Data;
using System;
using System.Collections.Generic;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IVaccinationOfficeRepository
    {
        public IEnumerable<SwpBusRoute> BusRoutes();

        public Task<ProcedureResult> AddRegistration(string userWinUid, VaccinationOffice vaccinationOffice);

        public Task<SwpVaccinationOffice> GetRegistrationDetails(string userWinUid);

        public  Task<IEnumerable<VaccinationOfficeRegistrations>> GetRegistrationList();

        public Task<SwpTplVaccineBatch> GetRegistrationBatch();


        public Task<ProcedureResult> RemoveRegistration(string empno);

        public Task<SwpEmployeeRegistrationBatch2> GetEmployeeRegistrationBatch2(string userWinUid);

        public Task<IEnumerable< SwpEmployeeFamilyRegistrationBatch2>> GetEmployeeFamilyRegistrationBatch2(string userWinUid);



    }
}
