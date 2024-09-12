namespace TCMPLApp.WebApp.Models
{
    public class SegmentsViewModel : Domain.Models.JOB.SegmentsDataTableList
    {
        public SegmentsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
