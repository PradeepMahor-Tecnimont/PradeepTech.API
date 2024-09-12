using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class HolidayCreateViewModel
    {
        [Required]
        [Display(Name = "Holiday date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime Holiday { get; set; }

        [Display(Name = "Description")]
        [StringLength(60)]
        public string Description { get; set; }
    }
}
