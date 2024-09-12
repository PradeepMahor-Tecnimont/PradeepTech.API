using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpGenInfoPassportAndAadhaarDetailsCreateViewModel
    {
        public PrimaryDetailViewModel PrimaryDetails { get; set; }

        [Required]
        [StringLength(16)]
        [Display(Name = "Aadhaar No")]
        public string AadharNo { get; set; }

        [Required]
        [Display(Name = "Name as per Aadhaar Card")]
        public string EmpAadhaarName { get; set; }

        [Required]
        [Display(Name = "Surname")]
        public string Surname { get; set; }

        [Required]
        [Display(Name = "Do You Have Aadhaar Card?")]
        public decimal? AadharCardAvailability { get; set; }

        [Required]
        [Display(Name = "Given Name ")]
        public string EmpPassportName { get; set; }

        [Required]
        [Display(Name = "Passport No")]
        public string PassportNo { get; set; }

        [Required]
        [Display(Name = "Issue Date")]
        public DateTime? IssueDate { get; set; }

        [Required]
        [Display(Name = "Issued At")]
        public string IssuedAt { get; set; }

        [Required]
        [Display(Name = "Expiry Date")]
        public DateTime? ExpiryDate { get; set; }

        [Required]
        [Display(Name = "Do You Have Passport?")]
        public decimal? PassportAvailability { get; set; }
    }
}