using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpPensionFundDetails : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PNomName { get; set; }

        public string PNomAdd1 { get; set; }

        public string PRelation { get; set; }

        public DateTime? PNomDob { get; set; }
        public DateTime? PModifiedOn { get; set; }
    }
}
