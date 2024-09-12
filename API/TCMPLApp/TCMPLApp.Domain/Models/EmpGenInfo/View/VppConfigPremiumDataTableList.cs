using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models
{
    public class VppConfigPremiumDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Insured sum id")]
        public string InsuredSumId { get; set; }

        [Display(Name = "Persons")]
        public decimal Persons { get; set; }

        [Display(Name = "Premium")]
        public decimal Premium { get; set; }

        [Display(Name = "Lacs")]
        public decimal Lacs { get; set; }

        [Display(Name = "GST amount")]
        public decimal GstAmt { get; set; }

        [Display(Name = "Total premium")]
        public decimal TotalPremium { get; set; }

        [Display(Name = "Key id")]
        public string KeyId { get; set; }

        [Display(Name = "Config keyid")]
        public string ConfigKeyId { get; set; }

        [Display(Name = "Modified on")]
        public DateTime? ModifiedOn { get; set; }
    }
}