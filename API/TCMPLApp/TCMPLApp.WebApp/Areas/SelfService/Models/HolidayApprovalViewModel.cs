using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class HolidayApprovalViewModel : Domain.Models.Attendance.HolidayAttendanceApprovalDataTableList
    {
        public HolidayApprovalViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}