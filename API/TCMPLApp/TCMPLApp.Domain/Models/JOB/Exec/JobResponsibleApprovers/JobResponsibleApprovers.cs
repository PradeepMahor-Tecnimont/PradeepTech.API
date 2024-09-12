using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobResponsibleApprovers : DBProcMessageOutput
    {        
        public string PProjno { get; set; }        
        public string PEmpnoR01 { get; set; }
        public string PEmpnoR02 { get; set; }
        public string PEmpnoR03 { get; set; }
        public string PEmpnoR04 { get; set; }
        public string PEmpnoR05 { get; set; }
        public string PEmpnoR06 { get; set; }
        public string PEmpnoR07 { get; set; }
        public string PEmpnoR08 { get; set; }
        //public string PEmpnoR09 { get; set; }
        //public string PEmpnoR10 { get; set; }
        //public string PEmpnoR11 { get; set; }

    }
}
