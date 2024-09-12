using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class NewEmployeeDetails : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public DateTime? PJoiningDate { get; set; }
        public string PDept { get; set; }
        public string PModifiedBy { get; set; }
        public DateTime? PModifiedOn { get; set; }

    }
}
