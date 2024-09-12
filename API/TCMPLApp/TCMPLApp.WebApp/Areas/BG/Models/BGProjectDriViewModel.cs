namespace TCMPLApp.WebApp.Models
{
    public class BGProjectDriViewModel : Domain.Models.BG.BGProjectDriMasterDataTableList
    {
        public BGProjectDriViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}