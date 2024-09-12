using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftConfigDetailsViewModel
    {
        
        [Display(Name = "Shift Code")]
        public string Shiftcode { get; set; }
        public string Shiftdesc { get; set; }
        
        [Display(Name = "Full Day Start time")]
        public string ChFdStartMi { get; set; }
        
        [Display(Name = "Full Day End time")]
        public string ChFdEndMi { get; set; }
        
        [Display(Name = "First half Start time")]
        public string ChFhStartMi { get; set; }
        
        [Display(Name = "First half End time")]
        public string ChFhEndMi { get; set; }
        
        [Display(Name = "Second half Start time")]
        public string ChShStartMi { get; set; }
        
        [Display(Name = "Second half End time")]
        public string ChShEndMi { get; set; }
        
        [Display(Name = "Full Day Working Hours ")]
        public decimal? FullDayWorkMi { get; set; }
        
        [Display(Name = "Half Day Working Hours ")]
        public decimal? HalfDayWorkMi { get; set; }
        
        [Display(Name = "Full Week Working Hours")]
        public decimal? FullWeekWorkMi { get; set; }
        
        [Display(Name = "Working Hours Start")]
        public string WorkHrsStartMi { get; set; }
        
        [Display(Name = "Working Hours End")]
        public string WorkHrsEndMi { get; set; }

        [Display(Name = "First Punch")]
        public string FirstPunchAfterMi { get; set; }

        [Display(Name = "Last Punch")]
        public string LastPunchBeforeMi { get; set; }
    }
}
