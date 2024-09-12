using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HolidayAttendanceCreateViewModel
    {
        [Display(Name = "Location")]
        [Required]
        public string Office { get; set; }

        [Display(Name = "Holiday attendance date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime HolidayAttendanceDate { get; set; }

        [Display(Name = "Project")]
        [Required]
        public string Project { get; set; }

        [Display(Name = "Select Lead Engineer /1st Level Approver")]
        [Required]
        public string Approvers { get; set; }

        [Display(Name = "From time")]
        [Required]
        public string StartTime { get; set; }

        [Display(Name = "To time")]
        [Required]
        public string EndTime { get; set; }

        [Display(Name = "Remarks")]
        [MaxLength(60)]
        public string Remarks { get; set; }
    }
}