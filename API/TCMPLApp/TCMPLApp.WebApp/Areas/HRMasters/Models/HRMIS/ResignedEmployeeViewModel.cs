namespace TCMPLApp.WebApp.Models
{
    public class ResignedEmployeeViewModel : Domain.Models.HRMasters.ResignedEmployeeDataTableList
    {
        public ResignedEmployeeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
