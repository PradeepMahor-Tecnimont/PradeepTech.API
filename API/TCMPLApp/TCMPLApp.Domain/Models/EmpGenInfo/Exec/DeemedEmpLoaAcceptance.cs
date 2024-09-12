using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class DeemedEmpLoaAcceptance : Common.DBProcMessageOutput
    {
        public IEnumerable<DeemedLoaAcceptanceEmployees> PEmpList { get; set; }
    }

    public class DeemedLoaAcceptanceEmployees
    {
        public string EmployeeNo { get; set; }
        public string EmployeeName { get; set; }
        public string CurrDate { get; set; }
        public string AcceptanceDate { get; set; }
        public decimal StatusCode { get; set; }
        public string AcceptanceStatus { get; set; }
        public string Email { get; set; }
    }
}