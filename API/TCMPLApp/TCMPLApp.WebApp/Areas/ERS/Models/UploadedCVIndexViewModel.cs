using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.ERS.Models
{
    public class UploadedCVIndexViewModel : TCMPLApp.Domain.Models.ERS.UploadedCVDataTableList
    {
        public UploadedCVIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}