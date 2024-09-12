namespace TCMPLApp.WebApp.Models
{
    public class BGCurrencyViewModel : Domain.Models.BG.BGCurrencyMasterDataTableList
    {
        public BGCurrencyViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}