using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftLunchDetailsViewModel
    {
        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }
        public string Shiftdesc { get; set; }

        [Display(Name = "Lunch Start time")]
        public string LunchStartMi { get; set; }

        [Display(Name = "Lunch End time")]
        public string LunchEndMi { get; set; }
    }
}
