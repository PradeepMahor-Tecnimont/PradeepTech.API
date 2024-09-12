using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaDeskImportOutput : DBProcMessageOutput
    {        
        public string[] PDeskAreaDeskErrors { get; set; }
    }
}
