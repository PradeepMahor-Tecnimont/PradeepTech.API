using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvConsumablesDetailDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string ConsumableDetId { get; set; }

        public string ConsumableId { get; set; }


        [Display(Name = "Item type")]
        public string ItemTypeDesc { get; set; }

        [Display(Name = "Item")]
        public string ItemId { get; set; }

        [Display(Name = "MfgId")]
        public string MfgId { get; set; }

        [Display(Name = "Usable")]
        public string IsUsable { get; set; }

        [Display(Name = "New")]
        public string IsNew { get; set; }

        [Display(Name = "Issued")]
        public string IsIssued { get; set; }

        [Display(Name = "Delete")]
        public decimal? DeleteItem { get; set; }
    }
}