using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class AppUserMasterOutPut : DBProcMessageOutput
    {
        public IEnumerable<ExcelError> PEmpnoErrors { get; set; }
    }
}
