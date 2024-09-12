namespace TCMPLApp.WebApp.Models
{
    public class EmpRelativesAsColleaguesViewModel : Domain.Models.EmpGenInfo.EmpRelativesAsColleaguesDataTableList
    {
        public EmpRelativesAsColleaguesViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
