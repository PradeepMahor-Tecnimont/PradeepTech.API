using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ExcludeEmployeeCreateViewModel
    {
        [Display(Name = "Employee")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Start date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "End date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Reason")]
        [MaxLength(400)]
        [Required]
        public string Reason { get; set; }
    }
}