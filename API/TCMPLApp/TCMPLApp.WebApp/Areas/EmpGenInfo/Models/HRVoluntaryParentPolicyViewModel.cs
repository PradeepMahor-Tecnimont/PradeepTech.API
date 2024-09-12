namespace TCMPLApp.WebApp.Models
{
    public class HRVoluntaryParentPolicyViewModel : Domain.Models.EmpGenInfo.HRVoluntaryParentPolicyDataTableList
    {
        public HRVoluntaryParentPolicyViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}