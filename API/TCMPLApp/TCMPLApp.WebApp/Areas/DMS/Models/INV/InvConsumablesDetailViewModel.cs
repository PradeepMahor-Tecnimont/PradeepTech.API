using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class InvConsumablesDetailViewModel : Domain.Models.DMS.InvConsumablesDetailDataTableList
    {
        public InvConsumablesDetailViewModel()
        {
            FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        //public string ConsumableId { get; set; }

        public InvConsumablesDetails InvConsumablesDetails { get; set; }
    }
}