namespace TCMPLApp.WebApp.Models
{
    public class LoPForExcessLeaveViewModel : Domain.Models.Attendance.LoPForExcessLeaveDataTableList
    {
        public LoPForExcessLeaveViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public string salaryMonth { get; set; }
        public string salaryMonthStatus { get; set; }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
