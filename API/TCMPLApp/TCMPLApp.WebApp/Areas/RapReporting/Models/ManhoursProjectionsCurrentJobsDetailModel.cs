using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class ManhoursProjectionsCurrentJobsDetailModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ManhoursProjectionsCurrentJobsDetailData Data { get; set; }
    }

    public class ManhoursProjectionsCurrentJobsDetailData
    {
        [JsonProperty("@odata.count")]
        public int count { get; set; }
        public List<ManhoursProjectionsCurrentJobsDetail> value { get; set; }
    }

    public class ManhoursProjectionsCurrentJobsDetail
    {
        [Required]
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "Project no")]
        public string Projno { get; set; }
        public string Yymm { get; set; }
        public decimal Hours { get; set; }
    }
}