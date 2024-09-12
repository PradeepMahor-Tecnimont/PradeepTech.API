using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpProvidentFundDetails : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PNomName { get; set; }

        public string PNomAdd1 { get; set; }

        public string PRelation { get; set; }

        public DateTime? PNomDob { get; set; }

        public decimal? PSharePcnt { get; set; }

        public string PNomMinorGuardName { get; set; }

        public string PNomMinorGuardAdd1 { get; set; }
                
        public string PNomMinorGuardRelation { get; set; }
    }
}
