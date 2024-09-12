using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobResponsibleApproversDetailViewModel
    {
        [Display(Name = "Job no")]
        public string Projno { get; set; }

        [Display(Name = "ERP PROJECT MANAGER")]
        public string EmpnoR01 { get; set; }

        [Display(Name = "PROJECT DIRECTOR/SPONSOR")]
        public string EmpnoR02 { get; set; }

        [Display(Name = "PROJECT MANAGER 1")]
        public string EmpnoR03 { get; set; }

        [Display(Name = "PROJECT MANAGER 2")]
        public string EmpnoR04 { get; set; }

        [Display(Name = "PROJECT CONTROL")]
        public string EmpnoR05 { get; set; }

        [Display(Name = "PROJECT ENGINEERING")]
        public string EmpnoR06 { get; set; }

        [Display(Name = "PROJECT PROCUREMENT")]
        public string EmpnoR07 { get; set; }

        [Display(Name = "PROJECT SITE")]
        public string EmpnoR08 { get; set; }

        //[Display(Name = "AFC ERP PHASES")]
        //public string EmpnoR09 { get; set; }

        //[Display(Name = "MD")]
        //public string EmpnoR10 { get; set; }

        //[Display(Name = "AFC")]
        //public string EmpnoR11 { get; set; }
    }
}
