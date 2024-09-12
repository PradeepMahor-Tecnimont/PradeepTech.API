using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.RapReporting
{
    public class RapNavDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Main")]
        public string Main { get; set; }

        [Display(Name = "Sub Category")]
        public string Sub { get; set; }

        [Display(Name = "Report Type")]
        public string RepType { get; set; }

        [Display(Name = "Report")]
        public string Report { get; set; }
    }
}
