using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftConfigDetailsUpdateViewModel
    {
        [Required]
        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }
        public string Shiftdesc { get; set; }

        [Required]
        [Display(Name = "Full Day Start time")]
        public string ChFdStartMi { get; set; }

        [Required]
        [Display(Name = "Full Day End time")]
        public string ChFdEndMi { get; set; }

        [Required]
        [Display(Name = "First half Start time")]
        public string ChFhStartMi { get; set; }

        [Required]
        [Display(Name = "First half End time")]
        public string ChFhEndMi { get; set; }

        [Required]
        [Display(Name = "Second half Start time")]
        public string ChShStartMi { get; set; }

        [Required]
        [Display(Name = "Second half End time")]
        public string ChShEndMi { get; set; }

        [Required]
        [Display(Name = "Full Day Working Hours ")]
        public decimal? FullDayWorkMi { get; set; }

        [Required]
        [Display(Name = "Half Day Working Hours ")]
        public decimal? HalfDayWorkMi { get; set; }

        [Required]
        [Display(Name = "Full Week Working Hours")]
        public decimal? FullWeekWorkMi { get; set; }

        [Required]
        [Display(Name = "Working Hours Start")]
        public string WorkHrsStartMi { get; set; }

        [Required]
        [Display(Name = "Working Hours End")]
        public string WorkHrsEndMi { get; set; }

        [Required]
        [Display(Name = "First Punch")]
        public string FirstPunchAfterMi { get; set; }

        [Required]
        [Display(Name = "Last Punch")]
        public string LastPunchBeforeMi { get; set; }
    }
}
