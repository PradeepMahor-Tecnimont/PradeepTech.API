namespace TCMPLApp.WebApp.Models
{
    public class InvEmployeeTransactionViewModel : Domain.Models.DMS.InvEmployeeTransactionDataTableList
    {
        public InvEmployeeTransactionViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}