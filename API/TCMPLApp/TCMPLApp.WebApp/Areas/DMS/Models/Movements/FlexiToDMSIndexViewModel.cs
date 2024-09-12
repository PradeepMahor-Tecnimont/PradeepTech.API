namespace TCMPLApp.WebApp.Models
{
    public class FlexiToDMSIndexViewModel : Domain.Models.DMS.FlexiToDMSDataTableList
    {
        public FlexiToDMSIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}