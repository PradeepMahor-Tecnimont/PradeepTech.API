using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class AttendanceStatusDatesDataTableList
    {
        [Display(Name = "Date")]
        public DateTime? DDateList { get; set; }

    }


    public class AttendanceStatusWeekNamesDataTableList
    {
        [Display(Name = "Week name")]
        public string WeekName { get; set; }


        [Display(Name = "Start date")]
        public DateTime StartDate { get; set; }


        [Display(Name = "End date")]
        public DateTime EndDate { get; set; }


    }
}
