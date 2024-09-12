
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;



namespace TCMPLApp.WebApp.Models
{
    public class OffBoardingExitsCreateViewModel
    {
        [Display(Name = "EmpNo")]
        [Required]
        public string Empno { get; set; }


        [Display(Name = "EmployeeName")]
        public string EmployeeName { get; set; }


        [Display(Name = "End by date")]
        [Required]
        public DateTime EndByDate { get; set; }


        [Display(Name = "Relieving date")]
        [Required]
        public DateTime RelievingDate { get; set; }

        [Display(Name = "Resignation date")]
        [Required]
        public DateTime ResignationDate { get; set; }




        [Display(Name = "Remarks")]
        [Required]
        [MaxLength(200)]
        public string Remarks { get; set; }


        [Display(Name = "Address")]
        [MaxLength(200)]
        public string Address { get; set; }

        [Display(Name = "Primary mobile")]
        [RegularExpression(@"^([1-9][0-9]{9})$", ErrorMessage = "Invalid Mobile Number.")]
        public string MobilePrimary { get; set; }

        [Display(Name = "Alternate number")]
        [RegularExpression(@"^([0-9]{8,20})$", ErrorMessage = "Invalid Number.")]
        public string AlternateNumber { get; set; }

        [Display(Name = "Email Id")]
        public string EmailId { get; set; }

    }
}
