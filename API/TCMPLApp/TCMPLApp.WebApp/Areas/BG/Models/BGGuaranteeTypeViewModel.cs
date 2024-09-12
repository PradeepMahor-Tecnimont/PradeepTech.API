namespace TCMPLApp.WebApp.Models
{
    public class BGGuaranteeTypeViewModel : Domain.Models.BG.BGGuaranteeTypeMasterDataTableList
    {
        public BGGuaranteeTypeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}