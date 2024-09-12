using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class GratuityNominationCreateViewModel
    {
        [StringLength(5)]
        public string Empno { get; set; }

        [Required]
        [StringLength(60)]
        [Display(Name = "Nominee Name")]
        public string NomName { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Nominee Address")]
        public string NomAdd1 { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Nominee Birth Date")]
        public DateTime? NomDob { get; set; }

        [Required]
        [StringLength(3)]
        [Display(Name = "Share (%)")]
        [Range(1, 100, ErrorMessage = "Value must be between 1 to 100")]
        public string SharePcnt { get; set; }
    }
}