namespace TCMPLApp.WebApp.Models
{
    public class PlantTypesViewModel : Domain.Models.JOB.PlantTypesDataTableList
    {
        public PlantTypesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
