using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.WebApp.Models
{
    public class ExcludeEmployeeViewModel : Domain.Models.SWP.ExcludeEmployeeDataTableList
    {
        public ExcludeEmployeeViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}