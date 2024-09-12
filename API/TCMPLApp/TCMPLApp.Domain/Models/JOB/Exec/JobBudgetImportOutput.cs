using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobBudgetImportOutput : DBProcMessageOutput
    {        
        public string[] PBudgetErrors { get; set; }
    }
}
