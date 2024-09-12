using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.WebApp.Models
{
    public class PunchDetailsViewModel : PunchDetailsDataTableList
    {
        public PunchDetailsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

    }
}
