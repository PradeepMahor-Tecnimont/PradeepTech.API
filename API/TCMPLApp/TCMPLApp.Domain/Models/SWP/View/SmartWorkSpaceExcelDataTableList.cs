using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SmartWorkSpaceExcelDataTableList
    {
        

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Planned")]
        public decimal Planned { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        //public string ParentDesc { get; set; }


        [Display(Name = "Assign")]
        public string Assign { get; set; }
        //public string AssignDesc { get; set; }

        [Display(Name = "Assign Dept Group")]
        public string AssignDeptGroup { get; set; }

        [Display(Name = "Work area")]
        public string WorkArea { get; set; }

        [Display(Name = "Office location")]
        public string OfficeLocationDesc { get; set; }


        [Display(Name = "Monday")]
        public string Mon { get; set; }

        [Display(Name = "Tuesday")]
        public string Tue { get; set; }

        [Display(Name = "Wednesday")]
        public string Wed { get; set; }

        [Display(Name = "Thursday")]
        public string Thu { get; set; }

        [Display(Name = "Friday")]
        public string Fri { get; set; }

    }
}
