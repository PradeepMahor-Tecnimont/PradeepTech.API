using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpNominationSubmitStatusViewModel : Domain.Models.EmpGenInfo.EmpNominationSubmitStatusDataTableList
    {
        public EmpNominationSubmitStatusViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

        [Display(Name = "Ex Employee")]
        public bool ExExployee { get; set; }
    }
}
