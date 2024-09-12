using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.ERS.Models
{
    public class HRUploadedCVIndexViewModel : TCMPLApp.Domain.Models.ERS.HRUploadedCVDataTableList
    {
        public HRUploadedCVIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}