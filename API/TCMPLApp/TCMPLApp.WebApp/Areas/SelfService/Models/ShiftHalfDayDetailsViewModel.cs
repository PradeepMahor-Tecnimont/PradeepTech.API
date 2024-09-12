using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftHalfDayDetailsViewModel
    {
        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }
        public string Shiftdesc { get; set; }

        [Display(Name = "First Half Start time")]
        public string HdFhStartMi { get; set; }

        [Display(Name = "First Half End time")]
        public string HdFhEndMi { get; set; }

        [Display(Name = "Second Half Start time")]
        public string HdShStartMi { get; set; }

        [Display(Name = "Second Half End time")]
        public string HdShEndMi { get; set; }
    }
}
