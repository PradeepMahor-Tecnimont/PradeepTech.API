namespace TCMPLApp.WebApp.Models
{
    public class InvTransactionViewModel : Domain.Models.DMS.InvTransactionDataTableList
    {
        public InvTransactionViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}