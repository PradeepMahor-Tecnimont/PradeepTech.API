using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class SwpEmployeeRegistrationBatch2
    {
        public string Empno { get; set; }
        public string VaccinationFor { get; set; }
        public DateTime PreferredDate { get; set; }
        public string JabNumber { get; set; }
        public DateTime ModifiedOn { get; set; }
    }
}
