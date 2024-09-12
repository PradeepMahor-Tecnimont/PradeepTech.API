using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class DesignationUpdateViewModel
    {
        [Required]
        [StringLength(6)]
        [Display(Name = "Designation code")]
        public string Desgcode { get; set; }

        [Required]
        [StringLength(45)]
        [Display(Name = "Designation")]
        public string Desg { get; set; }

        [StringLength(3)]
        [Display(Name = "Order")]
        public string Ord { get; set; }

        [StringLength(35)]
        [Display(Name = "Subcode")]
        public string Subcode { get; set; }

        [Required]
        [StringLength(75)]
        [Display(Name = "New Designation")]
        public string DesgNew { get; set; }
    }
}