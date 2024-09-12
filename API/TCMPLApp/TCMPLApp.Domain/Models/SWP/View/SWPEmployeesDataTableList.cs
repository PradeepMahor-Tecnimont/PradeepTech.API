
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SWPEmployeesDataTableList
    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }


        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }


        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }

        [Display(Name = "Assign costcode")]
        public string Assign { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }


        [Display(Name = "Grade")]
        public string Grade { get; set; }

    }
}