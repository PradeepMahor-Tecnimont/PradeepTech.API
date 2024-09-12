using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{


    public class SwpEmployeeFamilyRegistrationBatch2
    {
        public string Empno { get; set; }
        public string FamilyMemberName { get; set; }
        public string Relation { get; set; }
        public Int32 YearOfBirth { get; set; }
        public DateTime ModifiedOn { get; set; }

        public string KeyId{ get; set; }
    }
}
