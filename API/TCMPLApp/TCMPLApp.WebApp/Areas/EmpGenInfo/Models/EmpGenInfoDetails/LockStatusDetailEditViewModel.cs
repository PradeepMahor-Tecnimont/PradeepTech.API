using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LockStatusDetailEditViewModel
    {
        public string EmpNo { get; set; }
        public string Parent { get; set; }
        public string EmpName { get; set; }

        [Display(Name = "Primary")]
        public decimal? IsPrimaryOpen { get; set; } = -1;

        [Display(Name = "Secondary")]
        public decimal? IsSecondaryOpen { get; set; } = -1;

        [Display(Name = "Nomination")]
        public decimal? IsNominationOpen { get; set; } = -1;

        [Display(Name = "Mediclaim")]
        public decimal? IsMediclaimOpen { get; set; } = -1;

        [Display(Name = "Aadhaar")]
        public decimal? IsAadhaarOpen { get; set; } = -1;

        [Display(Name = "Passport")]
        public decimal? IsPassportOpen { get; set; } = -1;

        [Display(Name = "GTLI")]
        public decimal? IsGtliOpen { get; set; } = -1;
    }
}
