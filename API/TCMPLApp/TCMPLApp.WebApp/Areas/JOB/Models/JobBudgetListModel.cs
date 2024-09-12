using Newtonsoft.Json;
using System.Collections.Generic;
using TCMPLApp.Domain.Models.JOB;


namespace TCMPLApp.WebApp.Models
{
    public class JobBudgetListModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public JobBudgetListModelData Data { get; set; }
    }

    public class JobBudgetListModelData
    {
        [JsonProperty("@odata.count")]
        public int count { get; set; }
        public List<JobmasterBudgetApi> value { get; set; }
    }

    //public class ManhoursProjectionsCurrentJobsDetail
    //{
    //    [Required]
    //    [Display(Name = "Cost code")]
    //    public string Costcode { get; set; }

    //    [Required]
    //    [Display(Name = "Project no")]
    //    public string Projno { get; set; }
    //    public string Yymm { get; set; }
    //    public decimal Hours { get; set; }
    //}
}