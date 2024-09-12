using System;
using System.Collections.Generic;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.WebApp.Models
{
    public class TimesheetStatusPartialIndexViewModel : TSStatusPartialDataTableList
    {
        public TimesheetStatusPartialIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }


    }
}
