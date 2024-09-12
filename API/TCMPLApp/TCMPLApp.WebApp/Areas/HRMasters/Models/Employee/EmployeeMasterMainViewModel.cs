using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeMasterMainViewModel : TCMPLApp.Domain.Models.HRMasters.EmployeeMasterMain
    {
        public EmployeeMasterMainViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
