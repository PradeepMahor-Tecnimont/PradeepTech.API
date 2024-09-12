namespace TCMPLApp.WebApp.Models
{
    public class BGAcceptableViewModel : Domain.Models.BG.BGAcceptableMasterDataTableList
    {
        public BGAcceptableViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}