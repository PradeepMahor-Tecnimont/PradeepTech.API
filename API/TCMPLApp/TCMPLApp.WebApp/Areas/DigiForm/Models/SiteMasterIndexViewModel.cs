namespace TCMPLApp.WebApp.Models
{
    public class SiteMasterIndexViewModel : TCMPLApp.Domain.Models.DigiForm.SiteMasterDataTableList
    {
        public SiteMasterIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
