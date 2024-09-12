using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeCloneViewModel
    {
        [Required]
        [StringLength(5)]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }
        
        [Required]
        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "New employee no")]
        public string EmpnoNew { get; set; }

        [Required]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of joining")]
        public DateTime? DoJ { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Required]
        [StringLength(3)]
        [Display(Name = "Office")]
        public string Office { get; set; }
    }
}
