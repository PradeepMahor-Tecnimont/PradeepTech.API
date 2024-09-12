using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;


namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleRolesActionsDetails : DBProcMessageOutput
    {
        public string PModuleId { get; set; }
        public string PRoleId { get; set; }
        public string PActionId { get; set; }
        public string PModuleRoleActionKeyId { get; set; }
        public string PModuleRoleKeyId { get; set; }
    }
}
