using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OFBApprovalDetailsViewModel : Domain.Models.OffBoarding.OFBApprovalDetailsDataTableList
    {
        public OFBApprovalDetailsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

        public string ViewName { get; set; }


    }
}
