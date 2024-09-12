using System;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeDeactivateViewModel
    {
        [StringLength(5)]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Date of leaving")]
        public DateTime? Dol { get; set; }

        [Required]
        [StringLength(3)]
        [Display(Name = "Leaving Reason")]
        public string ReasonId { get; set; }

        [StringLength(200)]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}
