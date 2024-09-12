using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleUserRolesDetails : DBProcMessageOutput
    {
        public string PModuleId { get; set; }
        public string PRoleId { get; set; }
        public string PEmpno { get; set; }
        public string PPersonId { get; set; }
        public string PModuleRoleKeyId { get; set; }
    }
}
