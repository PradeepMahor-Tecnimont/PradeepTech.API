using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class SwpOfficeVaccineBatch2AddFamilyMember
    {
        public string CommandText { get => SWPVaccineProcedures.VaccineRegistrationAddFamilyMemeber; }
        public string ParamWinUid { get; set; }
        public string ParamFamilyMemberName { get; set; }
        public string ParamRelation { get; set; }
        public Int32 ParamYearOfBirth { get; set; }
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }

    }
}
