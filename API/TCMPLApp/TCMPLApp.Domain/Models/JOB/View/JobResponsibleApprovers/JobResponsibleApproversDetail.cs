using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobResponsibleApproversDetail : DBProcMessageOutput
    {        
        [Display(Name = "ERP PROJECT MANAGER")]
        public string PEmpnoR01 { get; set; }

        [Display(Name = "ERP PROJECT MANAGER")]
        public string PEmpnoNameR01 { get; set; }

        [Display(Name = "PROJECT DIRECTOR/SPONSOR")]
        public string PEmpnoR02 { get; set; }

        [Display(Name = "PROJECT MANAGER 1")]
        public string PEmpnoR03 { get; set; }

        [Display(Name = "PROJECT MANAGER 2")]
        public string PEmpnoR04 { get; set; }

        [Display(Name = "PROJECT CONTROL")]
        public string PEmpnoR05 { get; set; }

        public string PEmpnoR05RequiredAttribute { get; set; }

        [Display(Name = "PROJECT ENGINEERING")]
        public string PEmpnoR06 { get; set; }

        public string PEmpnoR06RequiredAttribute { get; set; }

        [Display(Name = "PROJECT PROCUREMENT")]
        public string PEmpnoR07 { get; set; }

        public string PEmpnoR07RequiredAttribute { get; set; }

        [Display(Name = "PROJECT SITE")]
        public string PEmpnoR08 { get; set; }

        public string PEmpnoR08RequiredAttribute { get; set; }

    }
}
