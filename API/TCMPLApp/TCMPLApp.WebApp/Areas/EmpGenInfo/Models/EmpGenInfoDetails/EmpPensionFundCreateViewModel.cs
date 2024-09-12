using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpPensionFundCreateViewModel
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

        [Required]
        [Display(Name = "Nominee Birth Date")]
        public DateTime? NomDob { get; set; }
    }
}