using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ExpectedJobsIndexModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ExpectedJobsData Data { get; set; }
    }

    public class ExpectedJobsData
    {
        [JsonProperty("@odata.count")]
        public int count { get; set; }

        public List<ExpectedJobsModel> value { get; set; }
    }

    public class ExpectedJobsModel
    {
        public string Projno { get; set; }
        public string Name { get; set; }
        public bool? Active { get; set; }
        public string Bu { get; set; }
        public bool? Activefuture { get; set; }
        public string FinalProjno { get; set; }
        public string Newcostcode { get; set; }
        public string Tcmno { get; set; }
        public bool? Lck { get; set; }
        public string ProjType { get; set; }
    }

    public class ExpectedJobsViewModel
    {
        [Required]
        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "Project Name")]
        public string Name { get; set; }

        [Required]
        [Display(Name = "Is Active")]
        public decimal? Active { get; set; }

        [Display(Name = "Bu")]
        public string Bu { get; set; }

        [Required]
        [Display(Name = "Is Active for future")]
        public decimal? Activefuture { get; set; }

        [Display(Name = "Final project")]
        public string FinalProjno { get; set; }

        [Display(Name = "TMA Group")]
        public string Newcostcode { get; set; }

        [Display(Name = "Tcmno")]
        public string Tcmno { get; set; }

        [Display(Name = "Is locked")]
        public decimal? Lck { get; set; }

        [Display(Name = "Project type")]
        public string ProjType { get; set; }
    }

    public class ExpectedJobsSettingViewModel
    {
        public string ProjectNo { get; set; }

        [Display(Name = "Number of months")]
        public int? NoOfMonths { get; set; }

        [Display(Name = "Real project no")]
        public string RealProjectNo { get; set; }

        [Display(Name = "Expected project no")]
        public string ExpectedProjectNo { get; set; }

        [Display(Name = "New project no")]
        public string NewProjectNo { get; set; }

        [Display(Name = "Cost code")]
        public int? CostCode { get; set; }
    }

    public class ExptjobsPostPutModel
    {
        public string Projno { get; set; }
        public string Name { get; set; }
        public bool? Active { get; set; }
        public string Bu { get; set; }
        public bool? Activefuture { get; set; }
        public string FinalProjno { get; set; }
        public string Newcostcode { get; set; }
        public string Tcmno { get; set; }
        public bool? Lck { get; set; }
        public string ProjType { get; set; }
    }
}