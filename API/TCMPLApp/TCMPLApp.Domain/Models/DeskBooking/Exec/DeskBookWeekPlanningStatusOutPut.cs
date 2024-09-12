using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookWeekPlanningStatusOutPut : DBProcMessageOutput
    {
        public DateTime? PPlanStartDate { get; set; }
        public DateTime? PPlanEndDate { get; set; }

        public DateTime PCurrStartDate { get; set; }
        public DateTime PCurrEndDate { get; set; }

        public string PPlanningExists { get; set; }

        public string PPwsOpen { get; set; }
        public string PSwsOpen { get; set; }
        public string POwsOpen { get; set; }
    }
    public class WeekPlanningStatusDeptOutPut : DeskBookWeekPlanningStatusOutPut
    {
        public string PDeptOwsQuotaExists { get; set; }
        public decimal? PDeptOwsQuota { get; set; }
    }
}
