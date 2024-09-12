using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class GetLockStatusDetailViewModel
    {
        [Display(Name = "Is primary open")]
        public string IsPrimaryOpen { get; set; }

        [Display(Name = "Is secondary open")]
        public string IsSecondaryOpen { get; set; }

        [Display(Name = "Is nomination open")]
        public string IsNominationOpen { get; set; }

        [Display(Name = "Is mediclaim open")]
        public string IsMediclaimOpen { get; set; }

        [Display(Name = "Is aadhaar open")]
        public string IsAadhaarOpen { get; set; }

        [Display(Name = "Is passport open")]
        public string IsPassportOpen { get; set; }

        [Display(Name = "Is Gtli open")]
        public string IsGtliOpen { get; set; }


    }
}