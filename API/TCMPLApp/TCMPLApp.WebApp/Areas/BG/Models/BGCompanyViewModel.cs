namespace TCMPLApp.WebApp.Models
{
    public class BGCompanyViewModel : Domain.Models.BG.BGCompanyMasterDataTableList
    {
        public BGCompanyViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}