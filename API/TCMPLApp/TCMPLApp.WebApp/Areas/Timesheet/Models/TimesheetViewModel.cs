using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.Timesheet
{
    public class TimesheetViewModel
    {
        public TimesheetViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
