using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeMasterAddressEditViewModel
    {
        [Required]
        [StringLength(5)]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [StringLength(50)]
        [Display(Name = "Address 1")]
        public string Add1 { get; set; }

        [StringLength(50)]
        [Display(Name = "Address 2")]
        public string Add2 { get; set; }

        [StringLength(50)]
        [Display(Name = "Address 3")]
        public string Add3 { get; set; }

        [StringLength(50)]
        [Display(Name = "Address 4")]
        public string Add4 { get; set; }               

        [StringLength(115)]
        [Display(Name = "Job title")]
        public string Jobtitle { get; set; }
        
        [Display(Name = "Pin Code")]
        public Int32? Pincode { get; set; }
        
    }
}
