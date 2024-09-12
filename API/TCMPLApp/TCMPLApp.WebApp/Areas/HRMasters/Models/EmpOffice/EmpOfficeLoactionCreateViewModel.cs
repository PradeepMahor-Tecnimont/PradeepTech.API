using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpOfficeLoactionCreateViewModel
    {
        [Required]
        [StringLength(2)]
        [Display(Name = "Office Location")]
        public string OfficeLocationCode { get; set; }

        [Required]
        [Display(Name = "Start Date")]
        public DateTime? StartDate { get; set; }
    }
}
