namespace TCMPLApp.WebApp.Models
{
    public class MovementsIndexViewModel : Domain.Models.DMS.MovementsDataTableList
    {
        public MovementsIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}