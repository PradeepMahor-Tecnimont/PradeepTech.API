using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemAddOnDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string TransId { get; set; }

        [Display(Name = "Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? TransDate { get; set; }

        [Display(Name = "Transaction type")]
        public string TransType { get; set; }


        [Display(Name = "Transaction type")]
        public string TransTypeDesc { get; set; }


        [Display(Name = "Container item")]
        public string ContainerItemId { get; set; }

        [Display(Name = "Container item description")]
        public string ContainerItemDesc { get; set; }


        [Display(Name = "Addon item")]
        public string AddonItemId { get; set; }

        [Display(Name = "Mfg Id")]
        public string MfgId { get; set; }

        [Display(Name = "Addon item description")]
        public string AddonItemDesc { get; set; }



        [Display(Name = "Updated by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }


    }
}