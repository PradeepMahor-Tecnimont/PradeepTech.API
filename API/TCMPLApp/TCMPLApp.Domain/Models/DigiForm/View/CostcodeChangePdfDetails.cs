using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class CostcodeChangePdfDetails : DBProcMessageOutput
    {
        public DateTime? PDate { get; set; }
        public string PFromNameOfEmp { get; set; }
        public string PFromDept { get; set; }

        public string PEmpNo { get; set; }
        public string PNameOfEmp { get; set; }

        public string PParentCodeVal { get; set; }
        public string PParentCodeText { get; set; }
        public string PAssignCodeVal { get; set; }
        public string PAssignCodeText { get; set; }

        public DateTime? PTransferDate { get; set; }
        public DateTime? PTransferToDate { get; set; }

        public string PRemarks { get; set; }

        public string PHodOfTransferredCostCentre { get; set; }
        public string PHodOfParentCostCode { get; set; }
        public string PHodOfAssignCostCode { get; set; }
        public DateTime? PEffectiveTransferDate { get; set; }
        public string PDesgcodeVal { get; set; }
        public string PDesgcodeText { get; set; }
        public string PHodOfTransferCostCode { get; set; }
        public DateTime? PHrApprlDate { get; set; }
        public string PHrApprlBy { get; set; }
        public string PSiteCode { get; set; }
    }
}