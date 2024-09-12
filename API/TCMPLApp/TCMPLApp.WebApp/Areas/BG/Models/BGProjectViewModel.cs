namespace TCMPLApp.WebApp.Models
{
    public class BGProjectViewModel : Domain.Models.BG.BGProjectMasterDataTableList
    {
        public BGProjectViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}