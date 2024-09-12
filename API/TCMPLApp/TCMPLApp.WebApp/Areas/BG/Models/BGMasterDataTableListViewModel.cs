using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class BGMasterDataTableListViewModel : Domain.Models.BG.BGMasterDataTableList
    {
        public BGMasterDataTableListViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}