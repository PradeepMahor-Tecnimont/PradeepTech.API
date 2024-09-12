using System.Collections.Generic;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleUserRoleOutPut : DBProcMessageOutput
    {
        public IEnumerable<ExcelError> PEmpnoErrors { get; set; }
    }
}
