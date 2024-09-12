using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvConsumablesDetails : DBProcMessageOutput
    {

        [Display(Name = "Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PConsumableDate { get; set; }


        [Display(Name = "Type")]
        public string PConsumableTypeId { get; set; }

        [Display(Name = "Type")]
        public string PConsumableTypeDesc { get; set; }

        [Display(Name = "Description")]
        public string PConsumableDesc { get; set; }

        [Display(Name = "Quantity")]
        public decimal PQuantity { get; set; }

        [Display(Name = "RAM Capacity")]
        public string PRamCapacityDesc { get; set; }

        [Display(Name = "Po No")]
        public string PPoNumber { get; set; }

        [Display(Name = "Po Date")]
        public string PPoDate { get; set; }

        [Display(Name = "Vendor")]
        public string PVendor { get; set; }

        [Display(Name = "Invoive No")]
        public string PInvoiceNo { get; set; }

        [Display(Name = "Invoice Date")]
        public string PInvoiceDate { get; set; }

        [Display(Name = "Warranty End Date")]
        public string PWarrantyEndDate { get; set; }
    }
}