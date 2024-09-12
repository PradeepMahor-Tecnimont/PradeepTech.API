using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.RapReporting
{
    public class ProjectActivityIndexModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ProjectActivityData Data { get; set; }
    }

    public class ProjectActivityData
    {
        [JsonProperty("@odata.count")]
        public int Count { get; set; }

        public List<ProjActivity> Value { get; set; }
    }

    //public class ManhoursProjectionsCurrentJobsData
    //{
    //    [JsonProperty("@odata.count")]
    //    public int count { get; set; }
    //    public List<ManhoursProjectionsCurrentJobs> value { get; set; }
    //}

    public class ProjectActivity
    {
        public string Projno { get; set; }
        public string Costcode { get; set; }
        public List<ProjActivity> AddProjact { get; set; }
        public List<ProjActivity> EditProjact { get; set; }
        public List<ProjActivity> DeleteProjact { get; set; }
    }

    public class ProjActivity
    {
        [Display(Name = "Projno")]
        public string Projno { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Activity code")]
        public string Activity { get; set; }

        //[Display(Name = "Activity name")]
        //public string ActName { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "Budget hours")]
        public long Budghrs { get; set; }

        [Range(0, int.MaxValue, ErrorMessage = "Only positive number allowed")]
        [Display(Name = "No of docs")]
        public int Noofdocs { get; set; }
    }
}