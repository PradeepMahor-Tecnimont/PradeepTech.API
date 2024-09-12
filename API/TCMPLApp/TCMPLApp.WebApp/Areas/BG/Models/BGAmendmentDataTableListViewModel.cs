namespace TCMPLApp.WebApp.Models
{
    public class BGAmendmentDataTableListViewModel : Domain.Models.BG.BGAmendmentDataTableList
    {
        public BGAmendmentDataTableListViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}