using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmployeeRelativesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

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
