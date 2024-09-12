using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class LeaveClaimsViewModel : Domain.Models.Attendance.LeaveClaimsDataTableList
    {
        public LeaveClaimsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}