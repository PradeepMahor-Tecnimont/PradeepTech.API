using System.Collections.Generic;

namespace TCMPLApp.WebApp.Models
{
    public class ActionMapDataViewModel
    {
        public ActionMapDataViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
