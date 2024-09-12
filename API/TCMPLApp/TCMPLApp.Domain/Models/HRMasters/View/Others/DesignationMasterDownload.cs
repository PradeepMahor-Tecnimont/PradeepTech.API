using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class DesignationMasterDownload
    {
        [Display(Name = "Designation code")]
        public string Desgcode { get; set; }

        [Display(Name = "Designation")]
        public string Desg { get; set; }

        [Display(Name = "New Designation")]
        public string DesgNew { get; set; }

        [Display(Name = "Order")]
        public string Ord { get; set; }

        [Display(Name = "Subcode")]
        public string Subcode { get; set; }
    }
}