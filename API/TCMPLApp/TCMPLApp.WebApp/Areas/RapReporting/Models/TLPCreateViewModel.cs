using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class TLPCreateViewModel
    {
        [Required]
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "TLP code")]
        public string Tlpcode { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string Name { get; set; }
    }
}
