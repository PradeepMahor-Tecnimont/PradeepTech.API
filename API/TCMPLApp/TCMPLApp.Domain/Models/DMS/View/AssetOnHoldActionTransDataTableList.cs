using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetOnHoldActionTransDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Action trans id")]
        public string ActiontransId { get; set; }

        [Display(Name = "Asset id")]
        public string Assetid { get; set; }

        [Display(Name = "Source desk")]
        public string SourceDesk { get; set; }

        [Display(Name = "Target asset")]
        public string TargetAsset { get; set; }

        [Display(Name = "Action type")]
        public string ActionTypeText { get; set; }

        [Display(Name = "Action type")]
        public decimal ActionTypeVal { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Action date")]
        public DateTime? ActionDate { get; set; }

        [Display(Name = "Action by")]
        public string ActionByEmpno { get; set; }

        [Display(Name = "Action by")]
        public string ActionByEmpname { get; set; }

        [Display(Name = "Source employee")]
        public string SourceEmp { get; set; }

        [Display(Name = "Asset id old")]
        public string AssetIdOld { get; set; }
    }
}