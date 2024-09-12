using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Models
{

    public class ManhoursProjectionsCurrentJobsIndexModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ManhoursProjectionsCurrentJobsData Data { get; set; }
    }

    public class ManhoursProjectionsCurrentJobsData
    {
        [JsonProperty("@odata.count")]
        public int count { get; set; }
        public List<ManhoursProjectionsCurrentJobs> value { get; set; }
    }

    public class ManhoursProjectionsCurrentJobs
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

    }
}
