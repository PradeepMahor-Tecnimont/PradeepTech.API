using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace TCMPLApp.WebApp.Models
{
    public class LeavePLReviseReviewViewModel : LeavePLReviseDetailCombineViewModel
    {
        [Display(Name = "Resuming duty on")]
        public string ResumingDuty { get; set; }

        [Display(Name = "Last date of reporting duty")]
        public string LastReporting { get; set; }

        [Display(Name = "Applicaiton Discrepancies")]
        public string Discrepancies { get; set; }

        public decimal CalcLeavePeriod { get; set; }
        public bool IsLeaveApplicationOk { get; set; }

    }
}
