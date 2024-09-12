using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpGTLINominationSubmitStatusViewModel : Domain.Models.EmpGenInfo.EmpGTLINominationSubmitStatusDataTableList
    {
        public EmpGTLINominationSubmitStatusViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

        [Display(Name = "Ex Employee")]
        public bool ExExployee { get; set; }
    }
}
