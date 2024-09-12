using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.RapReporting
{
    public class ActivityViewModel
    {
        [Required]
        public string Costcode { get; set; }
                
        [Display(Name = "Costcode")]
        public string CostcodeName { get; set; }

        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "TLP code")]
        public string Tlpcode { get; set; }
               
        public string TlpcodeName { get; set; }

        [Display(Name = "Activity type")]
        public string ActivityType { get; set; }

        [Display(Name = "Active")]
        public bool? Active { get; set; }           

    }

    public class ActivityModel
    {
        public string Costcode { get; set; }

        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Display(Name = "Activity name")]
        public string Name { get; set; }

        [Display(Name = "TLP code")]
        public string Tlpcode { get; set; }

        [Display(Name = "Activity type")]
        public string ActivityType { get; set; }

        [Display(Name = "Active")]
        public bool? Active { get; set; }
    }


    public class ActivityModelValue
    {
        // [JsonProperty("@odata.etag")]
        public string costcode { get; set; }
        public string activity { get; set; }
        public string name { get; set; }
        public string tlpcode { get; set; }
        public string activitytype { get; set; }
        public bool? active { get; set; }
    }

    public class RootObjectActivity
    {
        [JsonProperty("@odata.context")]
        public string context { get; set; }
        public List<ActivityModelValue> value { get; set; }
    }

}
