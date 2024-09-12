using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class InvTransactionDetailViewModel : Domain.Models.DMS.InvTransactionDetailDataTableList
    {
        public InvTransactionDetailViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string TransId { get; set; }

        public InvTransactionDetails InvTransactionDetails { get; set; }
    }
}