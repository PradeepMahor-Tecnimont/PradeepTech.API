
namespace TCMPLApp.WebApp.Models
{
    public class EmployeeDeleteIndexViewModel : TCMPLApp.Domain.Models.HRMasters.EmployeeDeleteDataTableList
    {
        public EmployeeDeleteIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
