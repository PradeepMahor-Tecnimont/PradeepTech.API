using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class PunchDetailsDataTableList
    {


        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "dd")]
        public string Dd { get; set; }

        [Display(Name = "Day")]
        public string Ddd { get; set; }

        [Display(Name = "Punch date")]
        public DateTime PunchDate { get; set; }

        [Display(Name = "Shift code")]
        public string ShiftCode { get; set; }

        [Display(Name = "Week of the year")]
        public string WkOfYear { get; set; }

        [Display(Name = "First punch")]
        public string FirstPunch { get; set; }

        [Display(Name = "Last punch")]
        public string LastPunch { get; set; }

        [Display(Name = "Penalty hourt")]
        public decimal PenaltyHrs { get; set; }

        [Display(Name = "Is odd punch")]
        public decimal IsOddPunch { get; set; }

        [Display(Name = "Is Leave deputation tour")]
        public decimal IsLdt { get; set; }

        [Display(Name = "Is sunday")]
        public decimal IsSunday { get; set; }

        [Display(Name = "Is last work day for week")]
        public decimal IsLwd { get; set; }

        [Display(Name = "Is Late come app")]
        public decimal IsLcApp { get; set; }

        [Display(Name = "Is short leave app")]
        public decimal IsSleaveApp { get; set; }

        [Display(Name = "Short leave app counter")]
        public decimal SlAppCntr { get; set; }

        [Display(Name = "Early go hours")]
        public decimal Ego { get; set; }

        [Display(Name = "Worked hours")]
        public decimal WrkHrs { get; set; }

        [Display(Name = "Delta hours")]
        public decimal DeltaHrs { get; set; }

        [Display(Name = "Extra hours")]
        public decimal ExtraHrs { get; set; }

        [Display(Name = "Last day carry forward delta hours")]
        public decimal LastDayCfwdDhrs { get; set; }

        [Display(Name = "Sum of worked hours for week")]
        public decimal WkSumWorkHrs { get; set; }

        [Display(Name = "Sum of delta hours for week")]
        public decimal WkSumDeltaHrs { get; set; }

        [Display(Name = "Brought forward delta hours for week")]
        public decimal WkBfwdDeltaHrs { get; set; }

        [Display(Name = "Carry forward delta hours for week")]
        public decimal WkCfwdDeltaHrs { get; set; }

        [Display(Name = "Week penalty hours")]
        public decimal WkPenaltyLeaveHrs { get; set; }

        [Display(Name = "Punch count")]
        public decimal PunchCount { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }


        [Display(Name = "Compensatory off")]
        public decimal CompOffHrs { get; set; }


        [Display(Name = "TimeSheet work hours")]
        public string StrTsWorkHrs { get; set; }


        [Display(Name = "TimeSheet extra hours")]
        public string StrTsExtraHrs { get; set; }




        [Display(Name = "Worked hours")]
        public string StrWrkHrs { get; set; }

        [Display(Name = "Delta hours")]
        public string StrDeltaHrs { get; set; }

        [Display(Name = "Extra hours")]
        public string StrExtraHrs { get; set; }

        [Display(Name = "Sum of worked hours for week")]
        public string StrWkSumWorkHrs { get; set; }

        [Display(Name = "Sum of delta hours for week")]
        public string StrWkSumDeltaHrs { get; set; }

        [Display(Name = "Brought forward delta hours for week")]
        public string StrWkBfwdDeltaHrs { get; set; }

        [Display(Name = "Carry forward delta hours for week")]
        public string StrWkCfwdDeltaHrs { get; set; }

        [Display(Name = "Week penalty hours")]
        public string StrWkPenaltyLeaveHrs { get; set; }

        [Display(Name = "Week Sum Weekday Extra Hours")]

        public decimal WkSumWeekdayExtraHrs { get; set; }

        [Display(Name = "Week Sum Holiday Extra Hours")]

        public decimal WkSumHolidayExtraHrs { get; set; }


    }

    public class FlexiPunchDetailsDataTableList
    {


        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "dd")]
        public string Dd { get; set; }

        [Display(Name = "Day")]
        public string Ddd { get; set; }

        [Display(Name = "Punch date")]
        public DateTime PunchDate { get; set; }

        [Display(Name = "Shift code")]
        public string Shiftcode { get; set; }

        [Display(Name = "Week of the year")]
        public string WkOfYear { get; set; }

        [Display(Name = "First punch")]
        public int FirstPunch { get; set; }

        [Display(Name = "Last punch")]
        public int LastPunch { get; set; }

        [Display(Name = "Penalty hours")]
        public int PenaltyHrs { get; set; }

        [Display(Name = "Is odd punch")]
        public int IsOddPunch { get; set; }

        [Display(Name = "Is Leave deputation tour")]
        public int IsLdt { get; set; }

        [Display(Name = "Is sunday")]
        public int IsSunday { get; set; }

        [Display(Name = "Is last work day for week")]
        public int IsLwd { get; set; }

        [Display(Name = "Is Late come app")]
        public int IsLcApp { get; set; }

        [Display(Name = "Is short leave app")]
        public int IsSleaveApp { get; set; }

        [Display(Name = "Short leave app counter")]
        public int SlAppCntr { get; set; }

        [Display(Name = "Early go hours")]
        public int Ego { get; set; }

        [Display(Name = "Worked hours")]
        public int WorkHrs { get; set; }

        [Display(Name = "Delta hours")]
        public int Deltahrs { get; set; }

        [Display(Name = "Extra hours")]
        public int ExtraHrs { get; set; }

        [Display(Name = "Last day carry forward delta hours")]
        public int LastDayCfwdDhrs { get; set; }


        [Display(Name = "Punch count")]
        public int PunchCount { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }


        [Display(Name = "Compensatory off")]
        public int CompOffHrs { get; set; }


        [Display(Name = "TimeSheet work hours")]
        public string StrTsWorkHrs { get; set; }


        [Display(Name = "TimeSheet extra hours")]
        public string StrTsExtraHrs { get; set; }




        [Display(Name = "Worked hours")]
        public string StrWrkHrs { get; set; }

        [Display(Name = "Delta hours")]
        public string StrDeltaHrs { get; set; }

        [Display(Name = "Extra hours")]
        public string StrExtraHrs { get; set; }

        [Display(Name = "Sum of worked hours for week")]
        public string StrWkSumWorkHrs { get; set; }

        [Display(Name = "Sum of delta hours for week")]
        public string StrWkSumDeltaHrs { get; set; }

        [Display(Name = "Brought forward delta hours for week")]
        public string StrWkBfwdDeltaHrs { get; set; }

        [Display(Name = "Carry forward delta hours for week")]
        public string StrWkCfwdDeltaHrs { get; set; }

        [Display(Name = "Week penalty hours")]
        public string StrWkPenaltyLeaveHrs { get; set; }

        [Display(Name = "Week Sum Weekday Extra Hours")]

        public int WkSumWeekdayExtraHrs { get; set; }

        [Display(Name = "Week Sum Holiday Extra Hours")]

        public int WkSumHolidayExtraHrs { get; set; }

        [Display(Name = "Sum of estimated worked hours for week")]
        public int WkSumEstWorkHrs { get; set; }

        [Display(Name = "Sum of estimated worked hours for week")]
        public int WkSumLdtHrs { get; set; }


        [Display(Name = "Sum of worked hours for week")]
        public int WkSumWorkHrs { get; set; }

        [Display(Name = "Sum of delta hours for week")]
        public int WkSumDeltaHrs { get; set; }

        [Display(Name = "Sum of deducted hours for week")]
        public int WkSumDeductionHrs { get; set; }

        [Display(Name = "Sum of absent hours for week")]
        public int WkSumAbsentHrs { get; set; }

        [Display(Name = "Sum of Swp Exception/WFH hours for week")]
        public int WkSumSwpExceptionWfhHrs { get; set; }


        [Display(Name = "Week actual total hrs")]
        public int WkActualTotalHrs
        {
            get
            {
                return WkSumWorkHrs + WkSumLdtHrs + WkSumAbsentHrs + WkSumSwpExceptionWfhHrs + WkSumDeductionHrs;
            }
        }



        [Display(Name = "Week excess / shortfall")]
        public int WkExcessShortFallHrs { get { return WkActualTotalHrs - WkSumEstWorkHrs; } }


        [Display(Name = "Week shortfall deductions")]
        public int WkShortFallDeductionsHrs
        {
            get
            {
                if (WkExcessShortFallHrs >= 0)
                    return 0;
                else
                {
                    decimal val = ((decimal)WkExcessShortFallHrs / (decimal)60);
                    decimal rounded = Math.Round(val);
                    if (val < rounded)
                        rounded = rounded - 1;

                    return (int)rounded;
                }
            }
        }


    }

}
