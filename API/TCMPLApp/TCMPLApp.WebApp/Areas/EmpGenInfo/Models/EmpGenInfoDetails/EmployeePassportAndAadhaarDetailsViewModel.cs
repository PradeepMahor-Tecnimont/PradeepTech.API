using Microsoft.AspNetCore.Http;
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeePassportAndAadhaarDetailsViewModel
    {
        public PrimaryDetailViewModel PrimaryDetails { get; set; }
        public GetLockStatusDetailViewModel LockStatusDetailViewModel { get; set; }

        public string KeyId { get; set; }
        public string Empno { get; set; }

        [Display(Name = "Adhaar no")]
        [StringLength(12)]
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
        public DateTime? IssueDate { get; set; }

        [Display(Name = "Expiry date")]
        public DateTime? ExpiryDate { get; set; }

        [Display(Name = "Issue at")]
        public string IssuedAt { get; set; }

        public string FileType { get; set; }

        [Display(Name = "Clint File name")]
        public string ClintFileName { get; set; }

        [Display(Name = "Server file name")]
        public string ServerFileName { get; set; }

        public IFormFile file { get; set; }
    }

    public class AadhaarDetailsViewModel
    {
        public PrimaryDetailViewModel PrimaryDetails { get; set; }
        public GetLockStatusDetailViewModel LockStatusDetailViewModel { get; set; }

        public string KeyId { get; set; }

        [StringLength(5)]
        public string Empno { get; set; }

        [Display(Name = "Adhaar no")]
        [RequiredIf("HasAadhaar", "OK", "Vaule is required.")]
        [StringLength(12)]
        public string AdhaarNo { get; set; }

        [Display(Name = "Name as per AdhaarCard")]
        [RequiredIf("HasAadhaar", "OK", "Vaule is required.")]
        [StringLength(100)]
        public string AdhaarName { get; set; }

        [StringLength(2)]
        [Display(Name = "Have Aadhaar Card")]
        public string HasAadhaar { get; set; }

        [Display(Name = "")]
        public string HasScanFileAadhaar { get; set; }
    }

    public class PassportDetailsViewModel
    {
        public PrimaryDetailViewModel PrimaryDetails { get; set; }

        public GetLockStatusDetailViewModel LockStatusDetailViewModel { get; set; }

        public string KeyId { get; set; }

        [StringLength(5)]
        public string Empno { get; set; }

        [StringLength(2)]
        [Display(Name = "Have Passport")]
        public string HasPassport { get; set; }

        [StringLength(60)]
        [Display(Name = "Surname")]
        [RequiredIf("HasPassport", "OK", "Vaule is required.")]
        public string Surname { get; set; }

        [StringLength(100)]
        [Display(Name = "Given name")]
        [RequiredIf("HasPassport", "OK", "Vaule is required.")]
        public string GivenName { get; set; }

        [StringLength(30)]
        [Display(Name = "Passport no")]
        [RequiredIf("HasPassport", "OK", "Vaule is required.")]
        public string PassportNo { get; set; }

        [Display(Name = "Issue date")]
        [RequiredIf("HasPassport", "OK", "Vaule is required.")]
        [DateLessThanToday("Issue date should be past date")]
        public DateTime? IssueDate { get; set; }

        [Display(Name = "Expiry date")]
        [RequiredIf("HasPassport", "OK", "Vaule is required.")]
        [DateGreaterThan("IssueDate", "Expiry date should be greater then Issue date")]
        public DateTime? ExpiryDate { get; set; }

        [StringLength(50)]
        [Display(Name = "Issue at")]
        [RequiredIf("HasPassport", "OK", "Vaule is required.")]
        public string IssuedAt { get; set; }

        public string FileType { get; set; }

        [Display(Name = "Clint File name")]
        public string ClintFileName { get; set; }

        [Display(Name = "Server file name")]
        public string ServerFileName { get; set; }

        [Display(Name = "")]
        public string HasScanFilePassport { get; set; }
    }
}