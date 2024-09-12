
namespace TCMPLApp.WebApp.Models
{
    public class InternalTransferViewModel : Domain.Models.HRMasters.InternalTransferDataTableList
    {
        public InternalTransferViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
