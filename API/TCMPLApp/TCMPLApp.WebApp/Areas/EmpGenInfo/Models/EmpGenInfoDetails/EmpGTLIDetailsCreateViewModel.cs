using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;
using System;
using System.ComponentModel;

namespace TCMPLApp.WebApp.Models
{
    public class EmpGTLIDetailsCreateViewModel
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

        [StringLength(60)]
        [Display(Name = "Guardian Name")]
        [DefaultValue("NA")]
        public string NomMinorGuardName { get; set; }

        [StringLength(200)]
        [Display(Name = "Guardian Address")]
        [DefaultValue("NA")]
        public string NomMinorGuardAdd1 { get; set; }

        [StringLength(50)]
        [Display(Name = "Relation with Minor")]
        [DefaultValue("NA")]
        public string NomMinorGuardRelation { get; set; }
    }
}