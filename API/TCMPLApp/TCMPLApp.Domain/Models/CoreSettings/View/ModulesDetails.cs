using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModulesDetails : DBProcMessageOutput
    {
        public string PModuleName { get; set; }
        public string PModuleLongDesc { get; set; }
        public string PModuleIsActive { get; set; }
        public string PModuleSchemaName { get; set; }
        public string PFuncToCheckUserAccess { get; set; }
        public string PModuleShortDesc { get; set; }

    }
}
