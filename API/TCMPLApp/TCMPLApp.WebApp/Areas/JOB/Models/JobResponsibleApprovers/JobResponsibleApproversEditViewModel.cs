using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobResponsibleApproversEditViewModel
    {
        [Required]
        [Display(Name = "Job No")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "ERP PROJECT MANAGER")]
        public string EmpnoR01 { get; set; }

        [Required]
        [Display(Name = "ERP PROJECT MANAGER")]
        public string EmpnoNameR01 { get; set; }

        [Required]
        [Display(Name = "PROJECT DIRECTOR/SPONSOR")]
        public string EmpnoR02 { get; set; }
                
        [Display(Name = "PROJECT MANAGER 1")]
        public string EmpnoR03 { get; set; }
                
        [Display(Name = "PROJECT MANAGER 2")]
        public string EmpnoR04 { get; set; }
                
        [Display(Name = "PROJECT CONTROL")]
        public string EmpnoR05 { get; set; }

        public string EmpnoR05RequiredAttribute { get; set; }

        [Display(Name = "PROJECT ENGINEERING")]
        public string EmpnoR06 { get; set; }

        public string EmpnoR06RequiredAttribute { get; set; }

        [Display(Name = "PROJECT PROCUREMENT")]
        public string EmpnoR07 { get; set; }

        public string EmpnoR07RequiredAttribute { get; set; }

        [Display(Name = "PROJECT SITE")]
        public string EmpnoR08 { get; set; }

        public string EmpnoR08RequiredAttribute { get; set; }
    }
}
