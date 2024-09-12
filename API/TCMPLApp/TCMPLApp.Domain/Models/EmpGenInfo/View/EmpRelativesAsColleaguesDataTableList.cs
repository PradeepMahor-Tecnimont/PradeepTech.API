using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpRelativesAsColleaguesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee Type")]
        public string Emptype { get; set; }

        [Display(Name = "Declaration status")]
        public string DeclStatusText { get; set; }

        [Display(Name = "Declaration Date")]
        public DateTime? DeclDate { get; set; }

        [Display(Name = "Relatives As Colleagues")]
        public decimal CountRelativesAsColleagues { get; set; }
    }
}
