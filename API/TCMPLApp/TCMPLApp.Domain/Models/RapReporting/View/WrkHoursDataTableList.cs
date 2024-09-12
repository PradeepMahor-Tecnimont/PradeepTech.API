using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class WrkHoursDataTableList
    {
        [Display(Name = "YYMM")]
        public string Yymm { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Working hrs")]
        public decimal WorkingHrs { get; set; }

        [Display(Name = "Approved by")]
        public DateTime? Apprby { get; set; }

        [Display(Name = "Posted bt")]
        public DateTime? Postby { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
