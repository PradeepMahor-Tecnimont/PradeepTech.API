namespace TCMPLApp.WebApp.Models
{
    public class DMSGuestMasterViewModel : Domain.Models.DMS.DMSGuestMasterDataTableList
    {
        public DMSGuestMasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}