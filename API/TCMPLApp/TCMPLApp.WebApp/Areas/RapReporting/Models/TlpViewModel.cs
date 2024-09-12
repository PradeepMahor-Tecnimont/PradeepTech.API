using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.RapReporting
{
    public class TLPViewModel
    {
        [Key]
        [Required]
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Required]
        [Display(Name = "TLP code")]
        public string Tlpcode { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }
    }

    public class TLPViewModelValue
    {
        // [JsonProperty("@odata.etag")]
        public string Costcode { get; set; }

        public string Tlpcode { get; set; }
        public string Name { get; set; }
    }

    public class RootObjectTLP
    {
        [JsonProperty("@odata.context")]
        public string Context { get; set; }

        public List<TLPViewModelValue> Value { get; set; }
    }
}