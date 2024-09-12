using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ExptPrjcDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Year month")]
        public string Yymm { get; set; }

        [Display(Name = "Hours")]
        public decimal Hours { get; set; }
    }
}
