using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ActionsDetails : DBProcMessageOutput
    {
        public string PModuleId { get; set; }
        public string PActionName { get; set; }
        public string PActionDesc { get; set; }
        public string PActionIsActive { get; set; }
        public string PModuleActionKeyId { get; set; }
    }
}
