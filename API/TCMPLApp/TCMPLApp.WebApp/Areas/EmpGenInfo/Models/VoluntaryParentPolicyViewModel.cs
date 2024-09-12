using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.WebApp.Models
{
    public class VoluntaryParentPolicyViewModel : Domain.Models.EmpGenInfo.VoluntaryParentPolicyDataTableList
    {
        public VoluntaryParentPolicyViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public VoluntaryParentPolicyDetail VoluntaryParentPolicyDetail { get; set; }

        public string ConfigId { get; set; }

        public decimal? IsEnableMod { get; set; }

        public decimal? IsDisplayPremium { get; set; }
    }
}