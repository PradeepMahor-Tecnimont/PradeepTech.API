using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmployeeAadhaarDetailOut : DBProcMessageOutput
    {
        public string PAdhaarNo { get; set; }
        public string PAdhaarName { get; set; }
        public DateTime? PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }
        public string PHasAadhaar { get; set; }
        public string PFileName { get; set; }
    }
}