

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class NonSWSEmpAtHomeViewModel : Domain.Models.SWP.NonSWSEmpAtHomeDataTableList
    {
        public NonSWSEmpAtHomeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }

}