namespace TCMPLApp.WebApp.Models
{
    public class BGVendorViewModel : Domain.Models.BG.BGVendorMasterDataTableList
    {
        public BGVendorViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}