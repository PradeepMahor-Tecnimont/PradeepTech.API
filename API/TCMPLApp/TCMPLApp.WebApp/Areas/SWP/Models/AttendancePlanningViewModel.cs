﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class AttendancePlanningViewModel : Domain.Models.SWP.AttendancePlanningDataTableList
    {
        public AttendancePlanningViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }
}