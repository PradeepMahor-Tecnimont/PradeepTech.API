using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class ManhoursProjectionsExpectedJobsDetailModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public ManhoursProjectionsExpectedJobsDetailData Data { get; set; }
    }

    public class ManhoursProjectionsExpectedJobsDetailData
    {
        [JsonProperty("@odata.count")]
        public int count { get; set; }
        public List<ManhoursProjectionsExpectedJobsDetail> value { get; set; }
    }

    public class ManhoursProjectionsExpectedJobsDetail
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