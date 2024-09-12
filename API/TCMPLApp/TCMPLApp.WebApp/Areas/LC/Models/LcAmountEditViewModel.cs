using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LcAmountEditViewModel
    {
        [Required]
        public string ApplicationId { get; set; }

        [Required]
        public string LcKeyId { get; set; }

        [Required]
        [Display(Name = "Currency")]
        public string Currency { get; set; }

        [Required]
        [Display(Name = "Exchange rate date")]
        public DateTime ExchageRateDate { get; set; }

        [Required]
        [Display(Name = "Exchange rate")]
        public decimal ExchangeRate { get; set; }

        [Required]
        [Display(Name = "LC Amount")]
        public decimal LcAmount { get; set; }

        [Required]
        [Display(Name = "Amount in INR")]
        public decimal AmountInInr { get; set; }
    }
}