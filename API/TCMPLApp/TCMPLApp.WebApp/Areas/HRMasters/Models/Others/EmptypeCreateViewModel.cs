using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmptypeCreateViewModel
    {        
        [Required]
        [StringLength(1)]
        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Description")]
        [StringLength(50)]
        public string Empdesc { get; set; }

        [Display(Name = "Remarks")]
        [StringLength(50)]
        public string Empremarks { get; set; }

        [Display(Name = "Timesheet")]
        public int? Tm { get; set; }

        [Display(Name = "Print logo")]
        public int? Printlogo { get; set; }

        [StringLength(2)]
        [Display(Name = "Sort order")]
        public string Sortorder { get; set; }
    }
}
