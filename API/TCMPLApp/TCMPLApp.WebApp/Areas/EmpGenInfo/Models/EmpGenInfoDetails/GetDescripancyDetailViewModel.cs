using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class GetDescripancyDetailViewModel
    {
        [Display(Name = "")]
        public string PrimaryStatus { get; set; }

        [Display(Name = "")]
        public string PrimaryText { get; set; }

        [Display(Name = "")]
        public string NominationStatus { get; set; }

        [Display(Name = "")]
        public string NominationText { get; set; }

        [Display(Name = "")]
        public string GratuityStatus { get; set; }

        [Display(Name = "")]
        public string GratuityText { get; set; }

        [Display(Name = "")]
        public string EpfStatus { get; set; }

        [Display(Name = "")]
        public string EpfText { get; set; }

        [Display(Name = "")]
        public string EpsaStatus { get; set; }

        [Display(Name = "")]
        public string EpsaText { get; set; }

        [Display(Name = "")]
        public string EpsmStatus { get; set; }

        [Display(Name = "")]
        public string EpsmText { get; set; }

        [Display(Name = "")]
        public string MediclaimStatus { get; set; }

        [Display(Name = "")]
        public string MediclaimText { get; set; }

        public string CanMediclaimEdit { get; set; }
        public string CanMediclaimAdd { get; set; }

        [Display(Name = "")]
        public string PpAaStatus { get; set; }

        [Display(Name = "")]
        public string PpAaText { get; set; }

        [Display(Name = "")]
        public string AaStatus { get; set; }

        [Display(Name = "")]
        public string AaText { get; set; }

        [Display(Name = "")]
        public string GtliStatus { get; set; }

        [Display(Name = "")]
        public string CanPrintGTLI { get; set; }

        [Display(Name = "")]
        public string GtliText { get; set; }

        [Display(Name = "")]
        public string SupAnnuStatus { get; set; }

        [Display(Name = "")]
        public string SupAnnuText { get; set; }
    }
}