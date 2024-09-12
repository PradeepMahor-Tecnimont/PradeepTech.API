using System;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscHoursDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string OscdId { get; set; }

        public string OschId { get; set; }

        [Display(Name = "Year month")]
        public string Yyyymm { get; set; }

        [Display(Name = "Original est hours")]
        public double? OrigEstHrs { get; set; }

        [Display(Name = "Original est hours status")]
        public string OrigEstHrsStatus { get; set; }

        [Display(Name = "Current est hours")]
        public double? CurEstHrs { get; set; }

        [Display(Name = "Current est hours status")]
        public string CurEstHrsStatus { get; set; }

        public double? LockOrigBudget { get; set; }
    }
}