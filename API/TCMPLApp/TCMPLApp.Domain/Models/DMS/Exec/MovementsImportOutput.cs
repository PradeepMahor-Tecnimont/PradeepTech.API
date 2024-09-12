using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class MovementsImportOutput : DBProcMessageOutput
    {        
        public string[] PMovementsErrors { get; set; }
    }
}
