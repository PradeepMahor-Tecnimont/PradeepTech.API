using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class ExpectedJobsDataTableList
    {
        [Display(Name = "Project no")]
        public string ProjectNo { get; set; }

        [Display(Name = "Project name")]
        public string ProjectName { get; set; }

        [Display(Name = "Is active")]
        public decimal IsActive { get; set; }

        [Display(Name = "Bu")]
        public string Bu { get; set; }

        [Display(Name = "Is active future")]
        public decimal IsActiveFuture { get; set; }

        [Display(Name = "Final project no")]
        public string FinalProjectNo { get; set; }

        [Display(Name = "New CostCode")]
        public string NewCostcode { get; set; }

        [Display(Name = "Tcmno")]
        public string Tcmno { get; set; }

        [Display(Name = "Is locked")]
        public decimal IsLocked { get; set; }

        [Display(Name = "Project type")]
        public string ProjectType { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}