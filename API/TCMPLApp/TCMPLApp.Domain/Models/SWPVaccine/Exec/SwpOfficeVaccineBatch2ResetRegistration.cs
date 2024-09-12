using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class SwpOfficeVaccineBatch2ResetRegistration
    {
        public string CommandText { get => SWPVaccineProcedures.VaccineRegistrationReset; }
        public string ParamWinUid { get; set; }
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }

    }
}
