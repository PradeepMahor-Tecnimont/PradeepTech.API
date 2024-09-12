using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftHalfDayDetailsUpdateViewModel
    {
        [Required]
        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }
        public string Shiftdesc { get; set; }

        [Required]
        [Display(Name = "First Half Start time")]
        public string HdFhStartMi { get; set; }

        [Required]
        [Display(Name = "First Half End time")]
        public string HdFhEndMi { get; set; }

        [Required]
        [Display(Name = "Second Half Start time")]
        public string HdShStartMi { get; set; }

        [Required]
        [Display(Name = "Second Half End time")]
        public string HdShEndMi { get; set; }
    }
}
