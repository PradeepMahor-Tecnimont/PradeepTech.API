using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscActualHoursBookedDataTableList
    {
        public decimal? RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string Yymm { get; set; }
        public string Costcode { get; set; }
        public string Empno { get; set; }
        public string Wpcode { get; set; }
        public string Activity { get; set; }
        public string Grp { get; set; }
        public decimal Hours { get; set; }

        [Display(Name = "OT hours")]
        public decimal Othours { get; set; }

        [Display(Name = "Total hours")]
        public decimal TotalHours { get; set; }
    }
}