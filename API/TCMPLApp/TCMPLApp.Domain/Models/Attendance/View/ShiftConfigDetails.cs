using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class ShiftConfigDetails : DBProcMessageOutput
    {
        public string PShiftDesc { get; set; }
        public decimal? PChFdStartMi { get; set; }
        public decimal? PChFdEndMi { get; set; }
        public decimal? PChFhStartMi { get; set; }
        public decimal? PChFhEndMi { get; set; }
        public decimal? PChShStartMi { get; set; }
        public decimal? PChShEndMi { get; set; }
        public decimal? PFullDayWorkMi { get; set; }
        public decimal? PHalfDayWorkMi { get; set; }
        public decimal? PFullWeekWorkMi { get; set; }
        public decimal? PWorkHrsStartMi { get; set; }
        public decimal? PWorkHrsEndMi { get; set; }
        public decimal? PFirstPunchAfterMi { get; set; }
        public decimal? PLastPunchBeforeMi { get; set; }
    }
}
