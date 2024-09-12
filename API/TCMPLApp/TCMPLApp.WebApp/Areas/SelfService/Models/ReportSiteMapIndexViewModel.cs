using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.WebApp.Models
{
    public class ReportSiteMapIndexViewModel : ReportSiteMapDataTableList
    {
        public ReportSiteMapIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
