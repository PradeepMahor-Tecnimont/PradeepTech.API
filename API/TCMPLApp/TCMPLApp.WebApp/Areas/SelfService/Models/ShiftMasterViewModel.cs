namespace TCMPLApp.WebApp.Models
{
    public class ShiftMasterViewModel : Domain.Models.Attendance.ShiftMasterDataTableList
    {
        public ShiftMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
