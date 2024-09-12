using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class GTLINominationSubmitStatusDataTableExcel
    {
        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string Parent { get; set; }
        public string Doj { get; set; }
        public string Email { get; set; }
        public string HrVerified { get; set; }
        public decimal PRollStatus { get; set; }
        public string HrDate { get; set; }
    }
}
