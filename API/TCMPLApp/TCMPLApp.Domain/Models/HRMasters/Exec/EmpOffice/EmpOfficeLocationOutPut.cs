using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmpOfficeLocationOutPut : DBProcMessageOutput
    {
        public IEnumerable<ExcelError> PEmpOfficeLocationErrors { get; set; }
    }
}
