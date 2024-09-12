using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeePassportAndAadhaarDetailsUpdateViewModel
    {
        [Required]
        public string KeyId { get; set; }

        [StringLength(20)]
        public string Empno { get; set; }

        [Display(Name = "Adhaar no")]
        public string AdhaarNo { get; set; }

        [Display(Name = "Name as per AdhaarCard")]
        public string AdhaarName { get; set; }

        [Display(Name = "Do You Have Aadhaar Card?")]
        public string HasAadhar { get; set; }

        [Display(Name = "Do You Have Passport?")]
        public string HasPassport { get; set; }

        [Display(Name = "Surname")]
        public string Surname { get; set; }

        [Display(Name = "Given name")]
        public string GivenName { get; set; }

        [Display(Name = "Passport no")]
        public string PassportNo { get; set; }

        [Display(Name = "Issue date")]
        public string IssueDate { get; set; }

        [Display(Name = "Expiry date")]
        public string ExpiryDate { get; set; }

        [Display(Name = "Issue at")]
        public string IssuedAt { get; set; }
    }
}
