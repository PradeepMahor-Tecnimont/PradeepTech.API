using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class CostcodeListViewModel : TCMPLApp.Domain.Models.Utilities.CostcodeListDataTableList
    {
        public CostcodeListViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
