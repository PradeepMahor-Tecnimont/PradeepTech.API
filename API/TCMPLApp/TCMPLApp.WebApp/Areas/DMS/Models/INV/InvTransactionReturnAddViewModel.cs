using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvTransactionReturnAddViewModel
    {
        public string TransId { get; set; }

        [Display(Name = "Transaction date")]
        public DateTime? TransDate { get; set; }

        [Display(Name = "Transaction type")]
        public string TransTypeId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Empno")]
        public string EmpName { get; set; }

        [Required]
        [Display(Name = "Item")]
        public string ItemId { get; set; }

        [Required]
        [Display(Name = "Is usable")]
        public string ItemUsable { get; set; }
    }
}