using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.SWPVaccine;



namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface ISWPOfficeVaccineBatch2Repository
    {

        public  Task<SwpOfficeVaccineBatch2AddRegistration> AddRegistration(SwpOfficeVaccineBatch2AddRegistration swpOfficeVaccineBatch2AddRegistration);

        public  Task<SwpOfficeVaccineBatch2AddFamilyMember> AddFamilyMember(SwpOfficeVaccineBatch2AddFamilyMember swpOfficeVaccineBatch2AddFamilyMember );

        public Task<SwpOfficeVaccineBatch2RemoveFamilyMember> RemoveFamilyMember(SwpOfficeVaccineBatch2RemoveFamilyMember swpOfficeVaccineBatch2RemoveFamilyMember );

        public Task<SwpOfficeVaccineBatch2ResetRegistration> ResetRegistration(SwpOfficeVaccineBatch2ResetRegistration swpOfficeVaccineBatch2ResetRegistration);

    }
}
