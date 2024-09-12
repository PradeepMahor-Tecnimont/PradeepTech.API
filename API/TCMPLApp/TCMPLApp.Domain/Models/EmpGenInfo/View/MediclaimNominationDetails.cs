using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class MediclaimNominationDetails : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PMember { get; set; }
        public DateTime? PDob { get; set; }
        public decimal? PRelationVal { get; set; }
        public decimal? POccupationVal { get; set; }
        public string PRelationText { get; set; }
        public string POccupationText { get; set; }
        public string PRemarks { get; set; }
        public DateTime? PModifiedOn { get; set; }


    }
}
