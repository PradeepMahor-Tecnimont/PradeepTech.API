using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{ 
    public class OvertimeUpdateOutput : DBProcMessageOutput
    {
        public string[] POvertimesErrors { get; set; }
    }
}
