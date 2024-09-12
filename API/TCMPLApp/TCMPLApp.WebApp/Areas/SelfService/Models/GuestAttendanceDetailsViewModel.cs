using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class GuestAttendanceDetailsViewModel
    {
        [Display(Name = "Guest name(s) Use comma(,) to separate guest names(limit 250 char)")]
        public string GuestName { get; set; }

        [Display(Name = "Guest company")]
        public string GuestCompany { get; set; }

        [Display(Name = "Meeting date")]
        public string MeetingDate { get; set; }

        [Display(Name = "Meeting time")]
        public string MeetingTime { get; set; }

        [Display(Name = "Meeting Place(Office)")]
        public string MeetingPlace { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}