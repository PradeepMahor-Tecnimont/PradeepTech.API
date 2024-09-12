using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmployeeScanFileDetailOut : DBProcMessageOutput
    {
        public string PFileName { get; set; }
        public string PRefNumber { get; set; }
        public DateTime? PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
    }
}