using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Models
{

    public class ManhoursProjectionsExpectedJobsIndexModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ManhoursProjectionsExpectedJobsData Data { get; set; }
    }

    public class ManhoursProjectionsExpectedJobsData
    {
        [JsonProperty("@odata.count")]
        public int count { get; set; }
        public List<ManhoursProjectionsExpectedJobs> value { get; set; }
    }

    public class ManhoursProjectionsExpectedJobs
    {       
        [Display(Name = "Project no")]
        public string Projno { get; set; }

        [Display(Name = "Project name")]
        public string Name { get; set; }

        public short? Active { get; set; }

        [Display(Name = "Active future")]
        public short? Activefuture { get; set; }

        [Display(Name = "Project type")]
        public string Projtype { get; set; }

        [Display(Name = "Hours")]
        public decimal? Hrs { get; set; }
    }
}
