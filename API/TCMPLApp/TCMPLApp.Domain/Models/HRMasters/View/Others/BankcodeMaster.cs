using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class BankcodeMaster
    {
        [Required]
        [Display(Name = "Bank code")]
        public string Bankcode { get; set; }

        [Display(Name = "Description")]
        public string Bankcodedesc { get; set; }

        public int? Emps { get; set; }
    }
}
