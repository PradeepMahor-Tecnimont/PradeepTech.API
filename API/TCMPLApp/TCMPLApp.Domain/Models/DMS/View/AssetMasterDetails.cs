using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetMasterDetails : DBProcMessageOutput
    {
        [Display(Name = "Asset Id")]
        public string PAssetId { get; set; }

        [Display(Name = "Asset Type")]
        public string PAssetType { get; set; }

        [Display(Name = "Model")]
        public string PModel { get; set; }

        [Display(Name = "Serial Number")]
        public string PSerialNum { get; set; }

        [Display(Name = "Warranty End Date")]
        public string PWarrantyEnd { get; set; }

        [Display(Name = "Sap Asset Code")]
        public string PSapAssetCode { get; set; }

        [Display(Name = "Sub Asset Type")]
        public string PSubAssetType { get; set; }

        public string PScrap { get; set; }
        public string PScrapDate { get; set; }
        public string PEmployee { get; set; }
        public string PEmpno { get; set; }
        public string PDeskid { get; set; }
        public string PStatus { get; set; }
        public string PRemarks { get; set; }
    }
}