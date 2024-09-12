using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSDepartmentBulkAction : DBProcMessageOutput
    {        
        public string PYymm { get; set; }        
        public string PCostcode { get; set; }
        public string PStatusstring { get; set; }
        public string PActionName { get; set; }      

    }
}
