namespace TCMPLApp.WebApp.Models
{
    public class InvItemCategoryViewModel : Domain.Models.DMS.InvItemCategoryDataTableList
    {
        public InvItemCategoryViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}