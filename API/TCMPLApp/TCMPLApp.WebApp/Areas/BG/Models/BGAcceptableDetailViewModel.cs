using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGAcceptableDetailViewModel
    {
        [Display(Name = "Acceptable id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Acceptable name")]
        public string AccetableName { get; set; }

        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }

        [Display(Name = "IsDeleted")]
        public decimal IsDeleted { get; set; }

        [Display(Name = "Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}