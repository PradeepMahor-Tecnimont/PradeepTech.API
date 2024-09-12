namespace TCMPLApp.WebApp.Models
{
    public class ProspectiveEmployeesViewModel : Domain.Models.HRMasters.ProspectiveEmployeesDataTableList
    {
        public ProspectiveEmployeesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
