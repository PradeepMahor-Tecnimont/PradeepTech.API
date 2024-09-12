using System;
using System.Collections.Generic;

namespace TCMPLApp.WebApp.Models
{
    public class TimesheetEmployeeIndexViewModel : TCMPLApp.Domain.Models.Timesheet.TSStatusDataTableList
    {
        public TimesheetEmployeeIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }


    }
}
