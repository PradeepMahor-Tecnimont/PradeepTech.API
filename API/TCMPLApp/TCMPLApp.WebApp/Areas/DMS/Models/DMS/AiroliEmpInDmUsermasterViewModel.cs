namespace TCMPLApp.WebApp.Models
{
    public class AiroliEmpInDmUsermasterViewModel : Domain.Models.DMS.AiroliEmpInDmMasterDataTableList
    {
        public AiroliEmpInDmUsermasterViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}