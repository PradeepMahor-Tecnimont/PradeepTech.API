using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcAcceptanceDetailsViewModel
    {
        public string ApplicationId { get; set; }

        [Display(Name = "LC acceptance date")]
        public string AcceptanceDate { get; set; }

        [Display(Name = "LC payment due date (per acceptance)")]
        public string PaymentDateAct { get; set; }

        [Display(Name = "Actual amount paid ")]
        public string ActualAmountPaid { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "LC closure payment date")]
        public string LcClPaymentDate { get; set; }

        [Display(Name = "LC closure actual amount ")]
        public string LcClActualAmount { get; set; }

        [Display(Name = "LC closure other charges")]
        public string LcClOtherCharges { get; set; }

        [Display(Name = "LC closed on date")]
        public string LcClModOn { get; set; }

        [Display(Name = "LC closed by")]
        public string LcClModBy { get; set; }

        [Display(Name = "LC closure remarks")]
        public string LcClRemarks { get; set; }

        public int Status { get; set; }

        [Display(Name = "LC Status ")]
        public string LcStatusText { get; set; }

        public int LcStatusVal { get; set; }
        public int SendToTreasury { get; set; }
    }
}