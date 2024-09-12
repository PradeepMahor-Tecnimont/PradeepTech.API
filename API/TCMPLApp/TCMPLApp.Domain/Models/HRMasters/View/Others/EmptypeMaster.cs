using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmptypeMaster
    {
        [Required]
        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Description")]
        public string Empdesc { get; set; }

        [Display(Name = "Remarks")]
        public string Empremarks { get; set; }

        [Display(Name = "Timesheet")]
        public int? Tm { get; set; }

        [Display(Name = "Print logo")]
        public int? Printlogo { get; set; }

        [Display(Name = "Sort order")]
        public string Sortorder { get; set; }

        public int? Emps { get; set; }
    }
}
