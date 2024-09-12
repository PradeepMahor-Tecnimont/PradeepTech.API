using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookEmployeeProjectMappingOutPut : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PEmpName { get; set; }
        public string PProjno { get; set; }
        public string PProjName { get; set; }
    }
}
