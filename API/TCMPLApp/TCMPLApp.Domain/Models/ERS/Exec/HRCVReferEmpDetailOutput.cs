using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.ERS
{
    public class HRCVReferEmpDetailOutput : DBProcMessageOutput
    {
        [Display(Name = "Empno")]
        public string PEmpno { get; set; }

        [Display(Name = "Name")]
        public string PEmpName { get; set; }

        [Display(Name = "Email id")]
        public string PEmpEmail { get; set; }

        [Display(Name = "Parent cost code")]
        public string PEmpParent { get; set; }

        [Display(Name = "Parent cost code name")]
        public string PEmpParentName { get; set; }

        [Display(Name = "Job title")]
        public string PShortDesc { get; set; }
    }
}
