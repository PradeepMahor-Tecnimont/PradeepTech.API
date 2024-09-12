using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ManhoursProjectionsCurrentJobsDataTableList
    {
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string Name { get; set; }
        public string Revcdate { get; set; }

        [Display(Name = "Original budget")]
        public decimal? OriginalBudg { get; set; }

        [Display(Name = "Revised budget")]
        public decimal? RevisedBudg { get; set; }

        [Display(Name = "Actual hours")]
        public decimal? Cummhours { get; set; }

        [Display(Name = "Forecast hours")]
        public decimal? Projections { get; set; }

        [Display(Name = "Current estimate")]
        public decimal? CurrHours { get; set; }
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
