namespace TCMPLApp.WebApp.Models
{
    public class BGProjectControlViewModel : Domain.Models.BG.BGProjectControlMasterDataTableList
    {
        public BGProjectControlViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}