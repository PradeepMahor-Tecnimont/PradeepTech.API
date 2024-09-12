using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGBankMasterDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Bank name")]
        public string BankName { get; set; }

        [Display(Name = "Company")]
        public string Comp { get; set; }

        [Display(Name = "Visible")]
        public decimal IsVisible { get; set; }

        [Display(Name = "Deleted")]
        public decimal IsDeleted { get; set; }

        [Display(Name = "Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Bank count")]
        public decimal? BankCount { get; set; }

    }
}