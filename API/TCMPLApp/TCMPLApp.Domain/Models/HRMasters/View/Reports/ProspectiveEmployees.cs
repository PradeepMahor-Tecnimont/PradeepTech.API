using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class ProspectiveEmployees
    {
        public string EmpName { get; set; }
        public string Dept { get; set; }

        public string DeptName { get; set; }

        public DateTime ProposedDoj { get; set; }
    }
}
