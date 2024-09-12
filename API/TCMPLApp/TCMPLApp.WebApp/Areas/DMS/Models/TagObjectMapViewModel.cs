namespace TCMPLApp.WebApp.Models
{
    public class TagObjectMapViewModel : Domain.Models.DMS.TagObjectMapDataTableList
    {
        public TagObjectMapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}