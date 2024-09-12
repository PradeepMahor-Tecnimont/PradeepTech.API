using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class MediclaimDetailsUpdateViewModel
    {
        [Required]
        public string KeyId { get; set; }

        [StringLength(5)]
        public string Empno { get; set; }

        [Required]
        [StringLength(60)]
        [Display(Name = "Name of Member")]
        public string Member { get; set; }

        [Required]
        [Display(Name = "Date of Birth")]
        public DateTime? Dob { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Relation with employee")]
        public string FamilyRelation { get; set; }

        [Required]
        [StringLength(2)]
        [Display(Name = "Occupation")]
        public string Occupation { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Pre-Existing Diseases")]
        public string PreExistingDiseases { get; set; }
    }
}