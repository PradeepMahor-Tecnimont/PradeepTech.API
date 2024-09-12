using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class CostcodeChangeRequestEditViewModel
    {
        public string KeyId { get; set; }

        [Required]
        [Display(Name = "Transfer Type")]
        public decimal TransferType { get; set; }

        [Required]
        [Display(Name = "Employee")]
        public string EmpNo { get; set; }

        [Required]
        [Display(Name = "Current cost code")]
        public string CurrentCostcode { get; set; }
        public string CurrentCostcodeName { get; set; }

        [Required]
        [Display(Name = "Target cost code")]
        public string TargetCostcode { get; set; }

        [Required]
        [Display(Name = "Transfer date")]
        public DateTime? TransferDate { get; set; }

        [Display(Name = "Transfer end date")]
        public DateTime? TransferEndDate { get; set; }


        [Display(Name = "Site Name")]
        public string SiteCode { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
        public decimal Status { get; set; }
        public string BtnName { get; set; }
    }
}
