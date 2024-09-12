using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscDetailCreateViewModel
    {
        [Required]
        public string OscmId { get; set; }

        [Required]
        public string LockOrigBudgetDesc { get; set; }

        [Required]
        [Display(Name = "Cost code")]
        public string CostCode { get; set; }
    }
}