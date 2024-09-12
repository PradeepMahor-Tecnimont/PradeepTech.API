using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.RapReporting
{
    public class RapViewModel
    {
        public RapViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }
    }
}
