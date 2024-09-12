namespace TCMPLApp.WebApp.Models
{
    public class InvItemAMSAssetMappingViewModel : Domain.Models.DMS.InvItemAMSAssetMappingDataTableList
    {
        public InvItemAMSAssetMappingViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}