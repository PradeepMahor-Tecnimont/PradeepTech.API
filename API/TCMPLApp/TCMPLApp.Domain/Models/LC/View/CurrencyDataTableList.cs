using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.LC
{
    public class CurrencyDataTableList
    {
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Currency code")]
        public string CurrencyCode { get; set; }

        [Display(Name = "Currency description")]
        public string CurrencyDesc { get; set; }

        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}