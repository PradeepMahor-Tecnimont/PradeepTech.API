using System;

namespace TCMPLApp.WebApp.Models
{
    public class HRAnnualEvaluationPendingDataTableListExcel
    {
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Abbr { get; set; }
        public string Grade { get; set; }
        public string Emptype { get; set; }
        public string Email { get; set; }
        public string Assign { get; set; }
        public string Parent { get; set; }
        public DateTime? Doj { get; set; }
        //public decimal Isdeleted { get; set; }
        public string HodApproval { get; set; }
        public string Status { get; set; }
    }
}
