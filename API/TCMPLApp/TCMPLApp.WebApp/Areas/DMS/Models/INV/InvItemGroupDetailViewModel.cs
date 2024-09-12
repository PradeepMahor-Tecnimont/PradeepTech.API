using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemGroupDetailViewModel : Domain.Models.DMS.InvItemGroupDetailDataTableList
    {
        public InvItemGroupDetailViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        //public string ConsumableId { get; set; }

        public InvItemGroupDetail InvItemGroupDetail { get; set; }
    }
}