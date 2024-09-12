namespace TCMPLApp.WebApp.Models
{
    public class EmpOfficeLocationViewModel : Domain.Models.HRMasters.EmpOfficeLocationDataTableList
    {
        public EmpOfficeLocationViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
