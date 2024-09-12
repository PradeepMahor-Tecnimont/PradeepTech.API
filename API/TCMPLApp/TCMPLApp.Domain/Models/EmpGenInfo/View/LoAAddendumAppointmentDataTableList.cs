using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class LoAAddendumAppointmentDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }

        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee Type")]
        public string Emptype { get; set; }

        [Display(Name = "Acceptance Status Value")]
        public decimal AcceptanceStatusVal { get; set; }

        [Display(Name = "Acceptance Status")]
        public string AcceptanceStatusText { get; set; }

        public string EmailStatus { get; set; }

        [Display(Name = "Acceptance Date")]
        public DateTime? AcceptanceDate { get; set; }
    }
}