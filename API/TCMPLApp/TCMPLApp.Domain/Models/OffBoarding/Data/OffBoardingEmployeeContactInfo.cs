using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingEmployeeContactInfo
    {
        [Required]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Address")]
        [MaxLength(200)]
        public string Address { get; set; }

        [Required]
        [Display(Name = "Primary mobile")]
        
        [RegularExpression(@"^([1-9][0-9]{9})$", ErrorMessage = "Invalid Mobile Number.")]
        public string MobilePrimary { get; set; }

        [Display(Name = "Alternate number")]
        [RegularExpression(@"^([0-9]{8,20})$", ErrorMessage = "Invalid Number.")]
        public string AlternateNumber { get; set; }

    }
}
