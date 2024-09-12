namespace TCMPLApp.WebApp.Models
{
    public class BGPPMViewModel : Domain.Models.BG.BGPPMMasterDataTableList
    {
        public BGPPMViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}