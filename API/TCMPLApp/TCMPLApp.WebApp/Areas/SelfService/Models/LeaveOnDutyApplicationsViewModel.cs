using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class LeaveOnDutyApplicationsViewModel : Domain.Models.Attendance.LeaveOnDutyApplicationsDataTableList
    {
        public LeaveOnDutyApplicationsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}