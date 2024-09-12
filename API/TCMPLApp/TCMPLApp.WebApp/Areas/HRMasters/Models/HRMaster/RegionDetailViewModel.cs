using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;
using System;
using System.ComponentModel;

namespace TCMPLApp.WebApp.Models
{
    public class RegionDetailViewModel
    {
        [Display(Name = "Region Code")]
        public string RegionCode { get; set; }

        [Display(Name = "Region Name")]
        public string RegionName { get; set; }

        [Display(Name = "Modified On")]

        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }
    }
}
