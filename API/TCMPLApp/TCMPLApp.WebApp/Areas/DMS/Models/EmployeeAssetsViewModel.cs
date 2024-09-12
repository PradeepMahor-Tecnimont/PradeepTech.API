using System.Collections.Generic;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeeAssetsViewModel
    {
        public string Desk { get; set; }
        public string Empno { get; set; }
        public string Employee { get; set; }
        public string Grade { get; set; }
        public string Parent { get; set; }
        public string Assign { get; set; }

        public IEnumerable<EmployeeAssetsDataTableList> employeeAssetsDataTableList { get; set; }
    }
}