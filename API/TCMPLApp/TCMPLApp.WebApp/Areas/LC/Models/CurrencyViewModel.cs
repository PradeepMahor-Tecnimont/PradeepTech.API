namespace TCMPLApp.WebApp.Models
{
    public class CurrencyViewModel : Domain.Models.LC.CurrencyDataTableList
    {
        public CurrencyViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}