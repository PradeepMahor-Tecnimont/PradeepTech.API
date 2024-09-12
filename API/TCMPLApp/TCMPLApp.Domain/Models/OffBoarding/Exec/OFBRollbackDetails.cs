using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBRollbackDetails : DBProcMessageOutput
    {
        public DateTime PEndByDate { get; set; }

        public DateTime? PRelievingDate { get; set; }
        public DateTime? PResignationDate { get; set; }
        public string PRemarks { get; set; }
        public string PAddress { get; set; }
        public string PPrimaryMobile { get; set; }
        public string PAlternateMobile { get; set; }
        public string PEmailId { get; set; }
        public string PEmpRollbackExists { get; set; }
    }
}
