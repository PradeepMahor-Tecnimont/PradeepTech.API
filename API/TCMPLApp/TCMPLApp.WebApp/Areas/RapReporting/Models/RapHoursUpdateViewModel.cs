using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class RapHoursUpdateViewModel
    {
        [Display(Name = "YYMM")]
        public string Yymm { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Work days")]
        public decimal? WorkDays { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Weekend")]
        public decimal? Weekend { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Holidays")]
        public decimal? Holidays { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Leave")]
        public decimal? Leave { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Total days")]
        public decimal? TotDays { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Working hours")]
        public decimal? WorkingHr { get; set; }
    }
}
