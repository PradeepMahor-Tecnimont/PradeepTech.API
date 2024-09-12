using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{ 
    public class EmployeesOutput : DBProcMessageOutput
    {
        public string[] PEmployeesErrors { get; set; }
    }
}
