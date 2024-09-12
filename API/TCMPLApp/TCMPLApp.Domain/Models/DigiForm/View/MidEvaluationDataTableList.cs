using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class MidEvaluationDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Abbr")]
        public string Abbr { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Employee Type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Costcode")]
        public string Parent { get; set; }

        [Display(Name = "Date of Joining")]
        public DateTime? Doj { get; set; }

        public decimal Isdeleted { get; set; }
        public string HodApproval { get; set; }
        public string Status { get; set; }
    }
}