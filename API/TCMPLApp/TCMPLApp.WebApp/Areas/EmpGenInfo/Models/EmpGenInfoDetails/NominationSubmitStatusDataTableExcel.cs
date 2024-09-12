using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class NominationSubmitStatusDataTableExcel
    {
        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string Parent { get; set; }
        public string Doj { get; set; }
        public string Email { get; set; }
        public string Submitted { get; set; }
        public decimal PRollStatus { get; set; }
        public string HrDate { get; set; }
    }
}
