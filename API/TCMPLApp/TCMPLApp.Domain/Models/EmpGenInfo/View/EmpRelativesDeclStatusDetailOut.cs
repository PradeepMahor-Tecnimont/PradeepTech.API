using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models
{
    public class EmpRelativesDeclStatusDetailOut : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public decimal PDeclStatus { get; set; }
        public string PDeclStatusText { get; set; }
    }
}
