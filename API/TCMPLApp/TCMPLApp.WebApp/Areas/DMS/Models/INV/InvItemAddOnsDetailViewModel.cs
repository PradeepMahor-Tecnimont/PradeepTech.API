using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemAddOnDetailViewModel : Domain.Models.DMS.InvItemAddOnDetailDataTableList
    {
        public InvItemAddOnDetailViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public string TransId { get; set; }

        public InvItemAddOnDetails InvItemAddOnDetails { get; set; }
    }
}