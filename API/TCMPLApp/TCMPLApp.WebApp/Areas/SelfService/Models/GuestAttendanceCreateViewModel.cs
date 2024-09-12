using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class GuestAttendanceCreateViewModel
    {
        [Display(Name = "Guest name(s) Use comma(,) to separate guest names(limit 250 char)")]
        [MaxLength(250)]
        [Required]
        public string GuestName { get; set; }

        [Display(Name = "Guest company")]
        [MaxLength(30)]
        [Required]
        public string GuestCompany { get; set; }

        [Display(Name = "Meeting date")]
        [Required]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime StartDate { get; set; }

        [Display(Name = "Meeting time")]
        [Required]
        public string FromHRS { get; set; }

        [Display(Name = "Meeting Place(Office)")]
        [Required]
        public string MeetingPlace { get; set; }

        [Display(Name = "Remarks")]
        [MaxLength(60)]
        [Required]
        public string Remarks { get; set; }
    }
}