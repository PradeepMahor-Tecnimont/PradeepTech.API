using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmployeeRelativesDataTableListExcel
    {
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmpName { get; set; }

        [Display(Name = "Relative Name")]
        public string ColleagueName { get; set; }

        [Display(Name = "Department")]
        public string ColleagueDept { get; set; }
        public string ColleagueRelationVal { get; set; }

        [Display(Name = "Relation")]
        public string ColleagueRelationText { get; set; }

        [Display(Name = "Office Location")]
        public string ColleagueLocation { get; set; }
        public string ColleagueEmpno { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
    }
}
