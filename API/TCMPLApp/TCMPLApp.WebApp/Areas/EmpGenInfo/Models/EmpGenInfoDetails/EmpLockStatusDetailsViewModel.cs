namespace TCMPLApp.WebApp.Models
{
    public class EmpLockStatusDetailsViewModel : Domain.Models.EmpGenInfo.EmpLockStatusDetailsDataTableList
    {
    
        public EmpLockStatusDetailsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
