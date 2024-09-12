namespace TCMPLApp.WebApp.Models
{
    public class OfficeViewModel : Domain.Models.DMS.OfficeDataTableList
    {
        public OfficeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}