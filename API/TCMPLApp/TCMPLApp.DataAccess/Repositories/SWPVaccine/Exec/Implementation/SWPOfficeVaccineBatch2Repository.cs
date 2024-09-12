using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Models.SWPVaccine;




namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class SWPOfficeVaccineBatch2Repository : ExecRepository, ISWPOfficeVaccineBatch2Repository
    {
        public SWPOfficeVaccineBatch2Repository(TCMPLApp.Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {
        }

        public async Task<SwpOfficeVaccineBatch2AddRegistration> AddRegistration(SwpOfficeVaccineBatch2AddRegistration swpOfficeVaccineBatch2AddRegistration)
        {
            return await ExecuteProcAsync(swpOfficeVaccineBatch2AddRegistration);
        }

        public async Task<SwpOfficeVaccineBatch2AddFamilyMember> AddFamilyMember(SwpOfficeVaccineBatch2AddFamilyMember swpOfficeVaccineBatch2AddFamilyMember)
        {
            return await ExecuteProcAsync(swpOfficeVaccineBatch2AddFamilyMember);
        }

        public async Task<SwpOfficeVaccineBatch2RemoveFamilyMember> RemoveFamilyMember(SwpOfficeVaccineBatch2RemoveFamilyMember swpOfficeVaccineBatch2RemoveFamilyMember)
        {
            return await ExecuteProcAsync(swpOfficeVaccineBatch2RemoveFamilyMember);
        }

        public async Task<SwpOfficeVaccineBatch2ResetRegistration> ResetRegistration(SwpOfficeVaccineBatch2ResetRegistration  swpOfficeVaccineBatch2ResetRegistration)
        {
            return await ExecuteProcAsync(swpOfficeVaccineBatch2ResetRegistration);
        }

    }
}