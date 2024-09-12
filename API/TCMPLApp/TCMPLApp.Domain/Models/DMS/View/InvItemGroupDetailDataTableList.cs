using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemGroupDetailDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Id")]
        public string GroupKeyId { get; set; }

        [Display(Name = "Item Id")]
        public string ItemId { get; set; }

        [Display(Name = "SAP Asset Code")]
        public decimal SapAssetCode { get; set; }

    }
}