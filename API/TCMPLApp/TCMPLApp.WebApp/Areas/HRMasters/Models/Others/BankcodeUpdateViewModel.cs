using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{ 
    public class BankcodeUpdateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Bank code")]
        public string Bankcode { get; set; }
        
        [StringLength(50)]
        [Display(Name = "Description")]
        public string Bankcodedesc { get; set; }

    }
}
