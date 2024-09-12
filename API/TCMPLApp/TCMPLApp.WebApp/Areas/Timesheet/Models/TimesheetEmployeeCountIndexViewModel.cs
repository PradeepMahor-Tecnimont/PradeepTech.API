using System;
using System.Collections.Generic;

namespace TCMPLApp.WebApp.Models
{
    public class TimesheetEmployeeCountIndexViewModel : TCMPLApp.Domain.Models.Timesheet.TSEmployeeCountDataTableList
    {
        public TimesheetEmployeeCountIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }


    }
}
