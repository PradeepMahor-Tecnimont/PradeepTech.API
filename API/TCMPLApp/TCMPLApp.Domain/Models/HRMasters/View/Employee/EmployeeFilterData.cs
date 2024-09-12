using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeFilterData
    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }


        [Display(Name = "Employee name")]
        public string Name { get; set; }


        [Display(Name = "Abbrivation")]
        public string Abbr { get; set; }


        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        public string EmptypeDesc { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }


        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }

        public string ParentAbbr { get; set; }

        [Display(Name = "Assign costcode")]
        public string Assign { get; set; }

        public string AssignAbbr { get; set; }


        [Display(Name = "Designation")]
        public string Desgcode { get; set; }
        public string Desg { get; set; }
    }
}
