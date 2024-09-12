namespace TCMPLApp.WebApp.Models
{
    public class InvItemAsgmtTypesViewModel : Domain.Models.DMS.InvItemAsgmtTypesDataTableList
    {
        public InvItemAsgmtTypesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}