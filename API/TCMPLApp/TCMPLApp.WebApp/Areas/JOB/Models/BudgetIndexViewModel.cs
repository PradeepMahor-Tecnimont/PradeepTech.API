using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class BudgetIndexViewModel : TCMPLApp.Domain.Models.JOB.BudgetDataTableList
    {
        public BudgetIndexViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }


        public IEnumerable<ProfileAction> ProjectActions { get; set; }

        public FilterDataModel FilterDataModel { get; set; }
    }
}
