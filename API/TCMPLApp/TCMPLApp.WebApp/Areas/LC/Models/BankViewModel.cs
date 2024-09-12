namespace TCMPLApp.WebApp.Models
{
    public class BankViewModel : Domain.Models.LC.BankDataTableList
    {
        public BankViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}