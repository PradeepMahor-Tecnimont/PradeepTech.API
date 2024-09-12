using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class TSPostedHoursDataTableList
    {
        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "From Timemast")]
        public decimal PFromTimeMast { get; set; }

        [Display(Name = "From Daily + OT")]
        public decimal PFromTimeDailyOt { get; set; }

        [Display(Name = "From Timetran")]
        public decimal PFromTimetran { get; set; }

        [Display(Name = "Blank")]
        public string PBlank { get; set; }

        [Display(Name = "From Osc Master")]
        public decimal PFromOscMaster { get; set; }

        [Display(Name = "From Osc Details")]
        public decimal PFromOscDetail { get; set; }

        [Display(Name = "From Timetran Osc")]
        public decimal PFromTimetranOsc { get; set; }


    }
}
