using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.LC
{
    public class BankDataTableList
    {
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Bank description")]
        public string BankDesc { get; set; }

        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}