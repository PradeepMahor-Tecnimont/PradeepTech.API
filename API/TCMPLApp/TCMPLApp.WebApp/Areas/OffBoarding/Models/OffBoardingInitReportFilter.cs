using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OffBoardingInitReportFilter
    {
        public DateTime StartDate { get; set; }

        [DateGreaterThanAttribute("StartDate", "End date should be greater than StartDate")]
        public DateTime EndDate { get; set; }
    }
}
