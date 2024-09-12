namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaCategoriesViewModel : Domain.Models.DMS.DeskAreaCategoriesDataTableList
    {
        public DeskAreaCategoriesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}