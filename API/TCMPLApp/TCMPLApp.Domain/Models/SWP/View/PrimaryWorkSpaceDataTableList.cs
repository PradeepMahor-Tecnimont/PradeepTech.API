using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class PrimaryWorkSpaceDataTableList
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Work area")]
        public string WorkArea{ get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Employee type")]
        public string Deskid { get; set; }


        [Display(Name = "Laptop user")]
        public decimal IsLaptopUser { get; set; }

        [Display(Name = "Laptop user")]
        public string IsLaptopUserText { get; set; }

        [Display(Name = "DualMonitor user")]
        public decimal IsDualMonitorUser { get; set; }

        [Display(Name = "DualMonitor user")]
        public string IsDualMonitorUserText
        {
            get { return IsDualMonitorUser == 1 ? "Yes" : "No"; }
        }

        [Display(Name = "Office location")]
        public string OfficeLocationCode { get; set; }


        [Display(Name = "Office location")]
        public string OfficeLocationDesc { get; set; }


        [Display(Name = "Office location date")]
        public DateTime? OfficeLocStartDate { get; set; }

        [Display(Name = "SWS Allowed")]
        public string IsSwsAllowed{ get; set; }


        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Assign Dept Group")]
        public string AssignDeptGroup { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Smart workspace")]
        public string SmartWorkspace { get; set; }

        [Display(Name = "OnDeputation")]
        public string NotInMumbaiOffice { get; set; }

        [Display(Name = "Workspace")]
        public decimal PrimaryWorkspace { get; set; }

        [Display(Name = "Workspace")]
        public string PrimaryWorkspaceText { get; set; }

        [Display(Name = "Pending")]
        public string Pending { get; set; }

        [Display(Name = "Eligible for SWP")]
        public string IsSwpEligible { get; set; }

        [Display(Name = "Eligible for SWP")]
        public string IsSwpEligibleDesc { get; set; }
        public string PlanningExists { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}