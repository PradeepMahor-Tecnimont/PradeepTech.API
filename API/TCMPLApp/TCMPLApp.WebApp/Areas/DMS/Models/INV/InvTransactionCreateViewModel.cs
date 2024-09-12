using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvTransactionCreateViewModel
    {
        [Required]
        [Display(Name = "Transaction date")]
        public DateTime? TransDate { get; set; }

        [Required]
        [Display(Name = "Transaction type")]
        public string TransTypeId { get; set; }

        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Item type")]
        public string ItemTypeCode { get; set; }

        [Required]
        [Display(Name = "Item")]
        public string ItemId { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}