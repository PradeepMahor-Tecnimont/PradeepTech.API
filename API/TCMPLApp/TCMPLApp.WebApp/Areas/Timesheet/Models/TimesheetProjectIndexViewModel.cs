using System;
using System.Collections.Generic;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.WebApp.Models
{
    public class TimesheetProjectIndexViewModel : TSProjectDataTableList
    {
        public TimesheetProjectIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
