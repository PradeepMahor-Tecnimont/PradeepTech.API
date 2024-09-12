using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmpOfficeDetails : DBProcMessageOutput
    {
        //public string Empno { get; set; }

        public string PName { get; set; }
        public string PGrade { get; set; }
        public string PParent { get; set; }
        public string PAssign { get; set; }
        public string PEmptype { get; set; }
        public string PEmpOffice { get; set; }


    }
}
