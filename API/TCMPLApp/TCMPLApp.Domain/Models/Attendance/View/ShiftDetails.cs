using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;
namespace TCMPLApp.Domain.Models.Attendance
{
    public class ShiftDetails : DBProcMessageOutput
    {
        public string PShiftdesc { get; set; }
        public decimal? PTimeinHh { get; set; }
        public decimal? PTimeinMn { get; set; }     
        public decimal? PTimeoutHh { get; set; }      
        public decimal? PTimeoutMn { get; set; }     
        public decimal? PShift4allowance { get; set; }
        public string PShift4allowanceText { get; set; }    
        public decimal? PLunchMn { get; set; }   
        public decimal? POtApplicable { get; set; }
        public string POtApplicableText { get; set; }
    }
}
