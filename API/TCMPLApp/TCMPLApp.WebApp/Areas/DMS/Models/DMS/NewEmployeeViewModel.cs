namespace TCMPLApp.WebApp.Models
{
    public class NewEmployeeViewModel : Domain.Models.DMS.NewEmployeeDataTableList
    {
        public NewEmployeeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}