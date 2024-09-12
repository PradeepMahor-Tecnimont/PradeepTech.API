using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvEmpTransactionReturnViewModel
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
        [Display(Name = "Item")]
        public string ItemId { get; set; }

        [Required]
        [Display(Name = "Is usable")]
        public string ItemUsable { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }

    public class Items
    {
        public string ItemId { get; set; }
        public bool IsReturn { get; set; }
        public string IsUsable { get; set; }
    }
}