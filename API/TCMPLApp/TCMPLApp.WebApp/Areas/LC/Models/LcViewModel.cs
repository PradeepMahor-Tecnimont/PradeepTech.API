namespace TCMPLApp.WebApp.Models
{
    public class LcViewModel : Domain.Models.LC.AfcLcMainDataTableList
    {
        public LcViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}