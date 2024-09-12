using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{ 
    public class ManhoursProjectionsOutput : DBProcMessageOutput
    {
        public string[] PProjectionsErrors { get; set; }
    }
}
