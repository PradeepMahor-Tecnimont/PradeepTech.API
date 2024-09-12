namespace TCMPLApp.WebApp.Models
{
    public class LaptopLotWiseViewModel : Domain.Models.DMS.LaptopLotWiseDataTableList
    {
        public LaptopLotWiseViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}