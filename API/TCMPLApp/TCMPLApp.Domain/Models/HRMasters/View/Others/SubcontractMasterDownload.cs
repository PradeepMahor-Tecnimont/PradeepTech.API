using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class SubcontractMasterDownload
    {
        [Required]
        [Display(Name = "Subcontract agency")]
        public string Subcontract { get; set; }
        
        public string Description { get; set; }
    }
}
