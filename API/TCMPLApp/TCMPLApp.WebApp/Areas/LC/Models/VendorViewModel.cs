namespace TCMPLApp.WebApp.Models
{
    public class VendorViewModel : Domain.Models.LC.VendorDataTableList
    {
        public VendorViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}