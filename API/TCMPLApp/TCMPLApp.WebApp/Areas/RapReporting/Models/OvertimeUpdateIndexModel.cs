using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Models
{

    public class OvertimeUpdateIndexModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }               
        public OvertimeUpdateData Data { get; set; }
    }

    public class OvertimeUpdateData
    {
        [JsonProperty("@odata.count")]
        public int count { get; set; }
        public List<OvertimeUpdate> value { get; set; }
    }

    public class OvertimeUpdate
    {
        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Yymm")]
        public string Yymm { get; set; }

        [Display(Name = "OT perc")]
        public byte? OT { get; set; }

    }
}
