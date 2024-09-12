using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class SwpOfficeVaccineBatch2AddRegistration
    {
        public string CommandText { get => SWPVaccineProcedures.VaccineRegistrationAdd; }
        public string ParamWinUid { get; set; }
        public string ParamVaccineFor { get; set; }
        public DateTime ParamPreferredDate { get; set; }
        public string JabNumber { get; set; }
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }

    }
}
