using Microsoft.AspNetCore.Http;
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvConsumableBulkCreateViewModel
    {
        [Display(Name = "Consumable type")]
        [Required]
        public string ConsumableType { get; set; }

        [Display(Name = "Consumable description")]
        [Required]
        public string ConsumableDesc { get; set; }

        [Display(Name = "Quantity")]
        [Range(1, 1000, ErrorMessage = "Quantity should be between 1 & 1000")]
        [Required]
        public Int32 Quantity { get; set; }

        [Display(Name = "RAM Capacity")]
        public int? RAMCapacity { get; set; }

        public IFormFile file { get; set; }

        [Display(Name = "PO Number")]
        public string PO { get; set; }

        [Display(Name = "PO Date")]
        public DateTime? PODate { get; set; }

        [Display(Name = "Vendor")]
        public string Vendor { get; set; }

        [Display(Name = "Invoice No")]
        public string Invoice { get; set; }

        [Display(Name = "Invoice Date")]
        public DateTime? InvoiceDate { get; set; }

        [Display(Name = "Warranty End Date")]
        public DateTime? WarrantyEndDate { get; set; }
    }
}