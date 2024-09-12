using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.JOB
{
    public class BudgetDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Job No")]
        public string Projno { get; set; }

        [Display(Name = "Phase")]
        public string Phase { get; set; }

        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Display(Name = "CostCode")]
        public string Costcode { get; set; }

        [Display(Name = "Initial budget")]
        public long InitialBudget { get; set; }

        [Display(Name = "New budget")]
        public long NewBudget { get; set; }
    }
}