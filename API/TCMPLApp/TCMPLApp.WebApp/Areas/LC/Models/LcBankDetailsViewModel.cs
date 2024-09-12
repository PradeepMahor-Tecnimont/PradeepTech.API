using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcBankDetailsViewModel
    {
        public string ApplicationId { get; set; }

        [Display(Name = "Issuing bank")]
        public string IssuingBankId { get; set; }

        [Display(Name = "Discounting bank")]
        public string DiscountingBankId { get; set; }

        [Display(Name = "Advising bank")]
        public string AdvisingBankId { get; set; }

        [Display(Name = "Issuing bank")]
        public string IssuingBank { get; set; }

        [Display(Name = "Discounting bank")]
        public string DiscountingBank { get; set; }

        [Display(Name = "Advising bank")]
        public string AdvisingBank { get; set; }

        [Display(Name = "Validity date")]
        public string ValidityDate { get; set; }

        [Display(Name = "Duration type")]
        public string DurationTypeVal { get; set; }

        [Display(Name = "Duration type")]
        public string DurationTypeText { get; set; }

        [Display(Name = "Tenure (No Of Days)")]
        public string TenureNoOfDays { get; set; }

        [Display(Name = "LC number")]
        public string LCNumber { get; set; }

        [Display(Name = "Issue date")]
        public string IssueDate { get; set; }

        [Display(Name = "LC payment due date (theoretical)")]
        public string PaymentDateEst { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "LC status")]
        public decimal LcStatusVal { get; set; }

        [Display(Name = "LC status")]
        public string LcStatusText { get; set; }

        [Display(Name = "Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        public int CreateEditStatus { get; set; }
        public int SendToTreasury { get; set; }
    }
}