using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetOnHoldAssetAddDetails : DBProcMessageOutput
    {
        public string PDeskId { get; set; }

        public string PAssetId { get; set; }
        public string PAssetDesc { get; set; }

        public string PEmpno { get; set; }
        public string PEmpname { get; set; }
        public string PRemarks { get; set; }
        public string PAssignDesc { get; set; }

        public decimal PActionTypeVal { get; set; }
        public string PActionTypeText { get; set; }
    }
}