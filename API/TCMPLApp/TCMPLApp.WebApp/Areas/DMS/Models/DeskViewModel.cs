
namespace TCMPLApp.WebApp.Models
{
    public class DeskViewModel : Domain.Models.DMS.SetZoneDeskDataTableList
    {
        public DeskViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
