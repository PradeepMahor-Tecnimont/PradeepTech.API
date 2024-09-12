using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class CostcodeChangeRequestDetails : DBProcMessageOutput
    {
        public decimal PTransferTypeVal { get; set; }
        public string PTransferTypeText { get; set; }
        public string PEmpNo { get; set; }
        public string PEmpName { get; set; }
        public string PCurrentCostcodeVal { get; set; }
        public string PCurrentCostcodeText { get; set; }
        public string PTargetCostcodeVal { get; set; }
        public string PTargetCostcodeText { get; set; }
        public DateTime? PTransferDate { get; set; }
        public DateTime? PTransferEndDate { get; set; }
        public string PRemarks { get; set; }
        public decimal PStatusVal { get; set; }
        public string PStatusText { get; set; }
        public DateTime? PEffectiveTransferDate { get; set; }
        public string PDesgcodeVal { get; set; }
        public string PDesgcodeText { get; set; }
        public string PSiteCode { get; set; }
        public DateTime? PModifiedOn { get; set; }
        public string PModifiedBy { get; set; }

        public string PJobGroupCode { get; set; }

        public string PJobGroup { get; set; }

        public string PJobdisciplineCode { get; set; }

        public string PJobdiscipline { get; set; }

        public string PJobtitleCode { get; set; }

        public string PJobtitle { get; set; }

        public string PTargetHodRemarks { get; set; }

        public string PHrRemarks { get; set; }

        public string PHrHodRemarks { get; set; }

        public string PDesgcodeNew { get; set; }

        public string PJobGroupCodeNew { get; set; }

        public string PJobdisciplineCodeNew { get; set; }

        public string PJobtitleCodeNew { get; set; }

        public string PDesgNew { get; set; }

        public string PJobGroupNew { get; set; }

        public string PJobdisciplineNew { get; set; }

        public string PJobtitleNew { get; set; }

        public string PSiteName { get; set; }

        public string PSiteLocation { get; set; }

    }
}