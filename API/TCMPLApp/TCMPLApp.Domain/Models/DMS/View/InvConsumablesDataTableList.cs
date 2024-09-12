using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvConsumablesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Id")]
        public string ConsumableId { get; set; }


        [Display(Name = "Date")]
        public DateTime ConsumableDate { get; set; }
        
        [Display(Name = "Description")]
        public string ConsumableDesc { get; set; }
        
        [Display(Name = "ItemType")]
        public string ItemTypeKeyId { get; set; }

        [Display(Name = "Quantity")]
        public decimal Quantity { get; set; }
        public decimal TotalIssued { get; set; }
        public decimal TotalReserved { get; set; }
        public decimal TotalNonUsable { get; set; }

        [Display(Name = "Po Number")]
        public string PoNumber { get; set; }

        [Display(Name = "Vendor")]
        public string Vendor { get; set; }

        [Display(Name = "Warranty End Date")]
        public DateTime? WarrantyEndDate { get; set; }

    }
}