namespace TCMPLApp.WebApp.Models
{
    public class BGVendorTypeViewModel : Domain.Models.BG.BGVendorTypeMasterDataTableList
    {
        public BGVendorTypeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}