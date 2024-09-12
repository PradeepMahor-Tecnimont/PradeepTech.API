using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetOnHoldActionTransDetails : DBProcMessageOutput
    {
        public string PAssetId { get; set; }

        public string PSourceDesk { get; set; }

        public string PTargetAsset { get; set; }

        public string PRemarks { get; set; }

        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PActionDate { get; set; }

        public string PActionBy { get; set; }

        public string PSourceEmp { get; set; }

        public string PAssetidOld { get; set; }

        public decimal? PActionTypeVal { get; set; }

        public string PActionTypeText { get; set; }
    }
}