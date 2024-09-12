using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class HolidayAttendanceViewModel : Domain.Models.Attendance.HolidayAttendanceDataTableList
    {
        public HolidayAttendanceViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}