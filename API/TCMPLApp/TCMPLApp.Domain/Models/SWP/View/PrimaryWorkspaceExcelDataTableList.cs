using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class PrimaryWorkspaceExcelDataTableList
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Work area")]
        public string WorkArea { get; set; }

        [Display(Name = "Office location")]
        public string OfficeLocationDesc { get; set; }


        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Assign Dept Group")]
        public string AssignDeptGroup { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Laptop user")]
        public string IsLaptopUserText { get; set; }

        [Display(Name = "DualMonitory user")]
        public string IsDualMonitorUserText { get; set; }

        [Display(Name = "Eligible for SWP")]
        public string IsSwpEligibleDesc { get; set; }

        [Display(Name = "Primary workspace")]
        public string PrimaryWorkspaceText { get; set; }
    }
}