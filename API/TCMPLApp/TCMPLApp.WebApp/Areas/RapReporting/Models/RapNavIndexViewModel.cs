using System.Collections.Generic;

namespace TCMPLApp.WebApp.Models
{
    public class RapNavIndexViewModel
    {
        public RapNavIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }

}
