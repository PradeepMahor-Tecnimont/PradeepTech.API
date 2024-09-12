namespace TCMPLApp.WebApp.Models
{
    public class BGPayableViewModel : Domain.Models.BG.BGPayableMasterDataTableList
    {
        public BGPayableViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}