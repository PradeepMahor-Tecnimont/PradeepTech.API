using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.SWP
{
    public class ExcludeEmployeeOutPut : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PEmpName { get; set; }
        public string PStartDate { get; set; }
        public string PEndDate { get; set; }
        public string PReason { get; set; }
        public string PIsActive { get; set; }
        public string PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
    }
}