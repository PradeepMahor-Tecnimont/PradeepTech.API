using DocumentFormat.OpenXml.Office2010.ExcelAc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.ReportSiteMap;
using TCMPLApp.Domain.Models.Timesheet;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeeTimesheetDetail
    {
        [Display(Name = "EmpNo")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Name { get; set; }

        [Display(Name = "Designation")]
        public string DesgCode { get; set; }

        [Display(Name = "Designation Name")]
        public string DesgName { get; set; }

        [Display(Name = "Parent cost code")]
        public string Parent { get; set; }

        [Display(Name = "Dept Name")]
        public string CostName { get; set; }

        [Display(Name = "Assign Code")]
        public string Assign { get; set; }

        [Display(Name = "Assign Name")]
        public string AssignName { get; set; }

        [Display(Name = "Timesheet status")]
        public string TimesheetStatus { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Assigned cost code")]
        public string AssignCostcode { get; set; }
        public FilterDataModel FilterDataModel { get; set; }

    }
   
}
