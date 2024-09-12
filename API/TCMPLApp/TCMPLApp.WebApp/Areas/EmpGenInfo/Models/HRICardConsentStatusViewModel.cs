namespace TCMPLApp.WebApp.Models
{
    public class HRICardConsentStatusViewModel : Domain.Models.EmpGenInfo.ICardConsentStatusDataTableList
    {
        public HRICardConsentStatusViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
