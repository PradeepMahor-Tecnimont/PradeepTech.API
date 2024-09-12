using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursClaimsViewModel : Domain.Models.Attendance.ExtraHoursClaimsDataTableList
    {
        public ExtraHoursClaimsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }


}
