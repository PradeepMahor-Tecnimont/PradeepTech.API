using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobPmJsDetail : DBProcMessageOutput
    {          
        public string PPmEmpno { get; set; }
                        
        public string PJsEmpno { get; set; }
    }
}
