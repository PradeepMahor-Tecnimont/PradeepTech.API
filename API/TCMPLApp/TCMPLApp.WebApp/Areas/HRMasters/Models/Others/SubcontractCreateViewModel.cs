using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class SubcontractCreateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Subcontract agency")]
        public string Subcontract { get; set; }
        
        [StringLength(45)]        
        public string Description { get; set; }
    }
}
