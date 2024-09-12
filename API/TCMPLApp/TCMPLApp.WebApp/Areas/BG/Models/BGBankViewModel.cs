namespace TCMPLApp.WebApp.Models
{
    public class BGBankViewModel : Domain.Models.BG.BGBankMasterDataTableList
    {
        public BGBankViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}