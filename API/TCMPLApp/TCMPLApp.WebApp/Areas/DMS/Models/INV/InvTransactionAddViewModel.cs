using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvTransactionAddViewModel
    {
        public string TransId { get; set; }

        [Display(Name = "Transaction date")]
        public DateTime? TransDate { get; set; }

        [Display(Name = "Transaction type")]
        public string TransTypeId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Item type")]
        public string ItemTypeCode { get; set; }

        [Required]
        [Display(Name = "Item")]
        public string ItemId { get; set; }
    }
}