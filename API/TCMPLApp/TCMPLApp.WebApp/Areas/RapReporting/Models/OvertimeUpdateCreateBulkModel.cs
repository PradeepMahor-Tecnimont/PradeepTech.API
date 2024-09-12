using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{    
    public class OvertimeUpdateCreateBulkModel
    {
        [Required]
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }                

        [Required]
        [Display(Name = "Add no. of months")]
        [Range(1, 200)]
        public int Months { get; set; }

        [Required]
        [Display(Name = "OT %")]
        [Range(1, 100)]
        public byte OT { get; set; }
    }
}