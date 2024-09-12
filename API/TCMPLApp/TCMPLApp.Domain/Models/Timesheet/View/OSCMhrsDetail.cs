using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Timesheet.View
{
    public class OSCMhrsDetail : DBProcMessageOutput
    {
        public string POscmId { get; set; }        

        public string PYymm { get; set; }

        public string PParent { get; set; }

        public string PParentName { get; set; }

        public string PParentWithName { get; set; }

        public string PAssign { get; set; }

        public string PAssignName { get; set; }

        public string PAssignWithName { get; set; }

        public string PEmpno { get; set; }

        public string PEmpnoName { get; set; }

        public string PEmpnoWithName { get; set; }

        public string PProjno { get; set; }

        public string PWpcode { get; set; }

        public string PActivity { get; set; }

        public decimal? PHours { get; set; }

    }
}
