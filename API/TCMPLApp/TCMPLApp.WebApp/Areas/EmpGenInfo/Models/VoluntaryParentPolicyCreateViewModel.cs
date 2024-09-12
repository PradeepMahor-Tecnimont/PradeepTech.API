using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class VoluntaryParentPolicyCreateViewModel
    {    
        public string KeyId { get; set; }

        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Required]
        [Display(Name = "Name")]
        public string Name { get; set; }

        [Required]
        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Required]
        [Display(Name = "Date of birth")]
        public DateTime? Dob { get; set; }

        [Required]
        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Required]
        [Display(Name = "Insured sum (Family floater)")]
        public string InsuredSumId { get; set; }
    }
}