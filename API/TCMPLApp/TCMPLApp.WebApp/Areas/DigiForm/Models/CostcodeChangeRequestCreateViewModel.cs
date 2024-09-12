using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class CostcodeChangeRequestCreateViewModel
    {
        [Required]
        [Display(Name = "Transfer type")]
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
        [Display(Name = "Transfer / Travel date")]
        public DateTime? TransferDate { get; set; }

        [Display(Name = "Transfer end date")]
        public DateTime? TransferEndDate { get; set; }

        [Display(Name = "Site name")]
        public string SiteCode { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
        public decimal Status { get; set; }
        public string BtnName { get; set; }
    }
}
