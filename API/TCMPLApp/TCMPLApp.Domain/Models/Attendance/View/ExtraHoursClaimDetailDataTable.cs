using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class ExtraHoursClaimDetailDataTable
    {
        public string ClaimNo { get; set; }

        [Display(Name = "Claim period")]
        public string ClaimPeriod { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Day detail csv")]
        public string DayDetail { get; set; }

        [Display(Name = "Week detail csv")]
        public string WeekDetail { get; set; }

        [Display(Name = "Week extrahours applicable")]
        public decimal WeekExtrahoursApplicable { get; set; }

        [Display(Name = "Week extrahours claim")]
        public decimal WeekExtrahoursClaim { get; set; }

        
        [Display(Name = "Week claimed CO")]
        public decimal WeekClaimedCo { get; set; }

        [Display(Name = "Week holiday extrahours claimed")]
        public decimal WeekHolidayOtClaim { get; set; }

        [Display(Name = "Week holiday extrahours applicable")]
        public decimal WeekHolidayOtApplicable { get; set; }

        [Display(Name = "PDate")]
        public DateTime Pdate { get; set; }

        [Display(Name = "Timesheet work hours")]
        public string TsWorkHrs { get; set; }

        [Display(Name = "Time sheet extrahours")]
        public string TsExtraHrs { get; set; }

    }
}


