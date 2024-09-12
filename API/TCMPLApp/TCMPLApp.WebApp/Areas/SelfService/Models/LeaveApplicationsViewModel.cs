using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class LeaveApplicationsViewModel : Domain.Models.Attendance.LeaveApplicationsDataTableList
    {
        public LeaveApplicationsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
