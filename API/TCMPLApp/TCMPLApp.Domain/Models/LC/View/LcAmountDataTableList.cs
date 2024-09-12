using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcAmountDataTableList
    {
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Lc key id")]
        public string LcKeyId { get; set; }

        [Display(Name = "Currency key id")]
        public string CurrencyKeyId { get; set; }

        [Display(Name = "Currency code")]
        public string CurrencyCode { get; set; }

        [Display(Name = "Currency desc")]
        public string CurrencyDesc { get; set; }

        [Display(Name = "Exchange rate date")]
        public string ExchangeRateDate { get; set; }

        [Display(Name = "Exchange rate")]
        public string ExchangeRate { get; set; }

        [Display(Name = "Lc amount")]
        public string LcAmount { get; set; }

        [Display(Name = "Amount in inr")]
        public string AmountInInr { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}