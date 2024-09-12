using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.ERS
{
    public class HRCVReferEmpDetailViewModel
    {        
        public string JobKeyId { get; set; }
        
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmpName { get; set; }

        [Display(Name = "Email id")]
        public string EmpEmail { get; set; }

        [Display(Name = "Parent cost code")]
        public string EmpParent { get; set; }

        [Display(Name = "Parent cost code name")]
        public string EmpParentName { get; set; }

        [Display(Name = "Job title")]
        public string ShortDesc { get; set; }
    }
}
