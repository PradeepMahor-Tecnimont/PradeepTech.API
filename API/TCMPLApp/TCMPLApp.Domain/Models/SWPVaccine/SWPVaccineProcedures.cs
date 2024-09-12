using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public static class SWPVaccineProcedures
    {
        public static string UploadExcelFile = "SELFSERVICE.swp_training.upload_training_excel";

        public static string CheckSWPDetails = "SELFSERVICE.SWP.CHECK_DETAILS";

        public static string VaccineRegistrationAddFamilyMemeber = "SELFSERVICE.SWP_OFFICE_VACCINE_BATCH_2.ADD_FAMILY_MEMBER";
        
        public static string VaccineRegistrationAdd = "SELFSERVICE.SWP_OFFICE_VACCINE_BATCH_2.ADD_REGISTRATION";

        public static string VaccineRegistrationRemoveFamilyMemeber  = "SELFSERVICE.SWP_OFFICE_VACCINE_BATCH_2.REMOVE_FAMILY_MEMBER";

        public static string VaccineRegistrationReset = "SELFSERVICE.SWP_OFFICE_VACCINE_BATCH_2.RESET_REGISTRATION"; 

    }
}
