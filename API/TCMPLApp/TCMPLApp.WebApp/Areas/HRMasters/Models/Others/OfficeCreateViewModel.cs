using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class OfficeCreateViewModel
    {
        [Required]
        [StringLength(2)]        
        public string Office { get; set; }
        
        [StringLength(25)]        
        public string Name { get; set; }
    }
}
