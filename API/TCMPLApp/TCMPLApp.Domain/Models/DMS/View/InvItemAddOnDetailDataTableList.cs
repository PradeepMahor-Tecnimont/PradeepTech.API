using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemAddOnDetailDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string TransDetId { get; set; }

        // public string TransId { get; set; }

        [Display(Name = "Item type")]
        public string ItemTypeDesc { get; set; }

        [Display(Name = "Item")]
        public string ItemId { get; set; }

        [Display(Name = "Item details")]
        public string ItemDetails { get; set; }

        [Display(Name = "Usable")]
        public string ItemUsable { get; set; }

        [Display(Name = "Delete")]
        public decimal? DeleteItem { get; set; }
    }
}