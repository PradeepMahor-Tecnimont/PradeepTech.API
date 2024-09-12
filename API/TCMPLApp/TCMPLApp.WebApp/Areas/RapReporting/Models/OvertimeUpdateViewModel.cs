using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{    
    public class OvertimeUpdateViewModel
    {
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Range(1, 100)]
        [Display(Name = "OT %")]
        public byte? OT { get; set; }
    }
}