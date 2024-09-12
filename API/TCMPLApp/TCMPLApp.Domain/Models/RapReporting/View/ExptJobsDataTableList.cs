using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ExptJobsDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string Name { get; set; }

        [Display(Name = "Active")]
        public decimal Active { get; set; }

        [Display(Name = "Active")]
        public string ActiveDesc { get; set; }

        [Display(Name = "Active in future")]
        public decimal Activefuture { get; set; }

        [Display(Name = "Active in future")]
        public string ActivefutureDesc { get; set; } 

        [Display(Name = "Project type")]
        public string ProjType { get; set; }

        [Display(Name = "Hours")]
        public decimal Hours { get; set; }

    }
}
