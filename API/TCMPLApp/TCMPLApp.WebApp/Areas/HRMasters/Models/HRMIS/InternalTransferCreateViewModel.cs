using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InternalTransferCreateViewModel
    {
        [Required]
        [StringLength(5)]
        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Travel date")]
        public DateTime? TransferDate { get; set; }

        [StringLength(4)]
        [Display(Name = "From CostCode")]
        public string FromCostcode { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "To Costcode")]
        public string ToCostcode { get; set; }
    }
}
