namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursFlexiClaimsViewModel : Domain.Models.Attendance.ExtraHoursFlexiClaimsDataTableList
    {
        public ExtraHoursFlexiClaimsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}