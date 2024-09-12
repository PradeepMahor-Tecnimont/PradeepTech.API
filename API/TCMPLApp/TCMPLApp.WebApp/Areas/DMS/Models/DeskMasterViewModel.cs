namespace TCMPLApp.WebApp.Models
{
    public class DeskMasterViewModel : Domain.Models.DMS.DeskMasterDataTableList
    {
        public DeskMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}