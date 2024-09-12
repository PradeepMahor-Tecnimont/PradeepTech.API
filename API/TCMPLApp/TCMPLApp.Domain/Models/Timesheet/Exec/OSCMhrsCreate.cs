using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class OSCMhrsCreate : DBProcMessageOutput
    {
        
        public string PYymm { get; set; }
        
        public string PParent { get; set; }
        
        public string PAssign { get; set; }
        
        public string PEmpno { get; set; }
        
        public string PProjno { get; set; }
        
        public string PWpcode { get; set; }
        
        public string PActivity { get; set; }
        
        public decimal? PHours { get; set; }

    }
}
