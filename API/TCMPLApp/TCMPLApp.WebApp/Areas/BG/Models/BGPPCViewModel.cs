namespace TCMPLApp.WebApp.Models
{
    public class BGPPCViewModel : Domain.Models.BG.BGPPCMasterDataTableList
    {
        public BGPPCViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}