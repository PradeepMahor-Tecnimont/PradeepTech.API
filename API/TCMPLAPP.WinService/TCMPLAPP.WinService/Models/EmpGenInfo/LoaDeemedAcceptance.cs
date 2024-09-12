using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLAPP.WinService.Models
{
    public class LoaDeemedAcceptanceModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public List<LoaDeemedAcceptanceData> data { get; set; }
    }
    public class LoaDeemedAcceptanceData
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
