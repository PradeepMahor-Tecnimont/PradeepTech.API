using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaUserImportOutput : DBProcMessageOutput
    {        
        public string[] PDeskAreaUserErrors { get; set; }
    }
}
