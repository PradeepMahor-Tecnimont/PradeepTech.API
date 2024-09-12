using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class ScopeOfWorkDetails : DBProcMessageOutput
    {
        public string PDescription { get; set; }

        public string PShortDescription { get; set; }
    }
}
