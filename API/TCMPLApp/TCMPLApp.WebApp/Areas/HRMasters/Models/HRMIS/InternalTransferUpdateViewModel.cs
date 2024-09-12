using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;
using System;
using System.ComponentModel;

namespace TCMPLApp.WebApp.Models
{
    public class InternalTransferUpdateViewModel
    {
        [Required]
        [StringLength(8)]
        public string KeyId { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmployeeName { get; set; }

        [Required]
        [Display(Name = "Travel date")]
        public DateTime? TransferDate { get; set; }

        [Display(Name = "From CostCode")]
        public string FromCostcode { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "To Costcode")]
        public string ToCostcode { get; set; }
    }
}
