using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class JobmasterViewModel : TCMPLApp.Domain.Models.JOB.JobmasterDataTableList
    {
        public JobmasterViewModel()
        {

            this.FilterDataModel = new FilterDataModel();

        }

        public FilterDataModel FilterDataModel { get; set; }

    }
}
