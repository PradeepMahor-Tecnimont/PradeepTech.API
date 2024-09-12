using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftLunchDetailsUpdateViewModel
    {
        [Required]
        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }
        public string Shiftdesc { get; set; }

        [Required]
        [Display(Name = "Lunch Start time")]
        public string LunchStartMi { get; set; }

        [Required]
        [Display(Name = "Lunch End time")]
        public string LunchEndMi { get; set; }
    }
}
