using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class OSCMhrsUpdate : DBProcMessageOutput
    {
        
        public string POscmId { get; set; }

        public string POscdId { get; set; }

        public string PEmpno { get; set; }
        
        public string PProjno { get; set; }
        
        public string PWpcode { get; set; }
        
        public string PActivity { get; set; }
        
        public decimal? PHours { get; set; }

    }
}
