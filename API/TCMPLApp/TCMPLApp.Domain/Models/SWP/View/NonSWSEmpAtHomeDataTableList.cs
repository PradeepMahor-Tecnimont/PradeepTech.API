using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class NonSWSEmpAtHomeDataTableList
    {
        [Display(Name ="Empno")]
        public string Empno { get; set; }

        [Display(Name ="Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }


        [Display(Name ="Emptype")]
        public string Emptype { get; set; }

        [Display(Name = "IsSWPEligible")]
        public string IsSwpEligible { get; set; }

        [Display(Name = "IsSWPEligible")]
        public string SWPEligible { get { return IsSwpEligible == "OK" ? "Yes" : "No"; } }


        [Display(Name = "IsLaptopUser")]
        public decimal IsLaptopUser { get; set; }

        [Display(Name = "IsLaptopUser")]
        public string LaptopUser { get { return IsLaptopUser == 1 ? "Yes" : "No"; } }

        [Display(Name = "PrimaryWorkspace")]
        public string PrimaryWorkspace { get; set; }

        [Display(Name = "PresentCount")]
        public decimal PresentCount { get; set; }

        [Display(Name = "Employee Email")]
        public string EmpEmail { get; set; }

        [Display(Name = "Desk")]
        public string Deskid{ get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}
