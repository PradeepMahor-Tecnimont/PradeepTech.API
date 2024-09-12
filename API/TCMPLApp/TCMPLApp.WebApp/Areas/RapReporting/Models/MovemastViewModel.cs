using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.RapReporting
{
    public class MovemastViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Required]
        [StringLength(6)]
        [Display(Name = "YYYYMM")]
        public string Yymm { get; set; }

        [Display(Name = "Movement")]
        public int? Movement { get; set; }

        [Display(Name = "Move to home office")]
        public int? Movetotcm { get; set; }

        [Display(Name = "Move to TCMPL")]
        public int? Movetosite { get; set; }

        [Display(Name = "Move to MET sites")]
        public int? Movetoothers { get; set; }

        [Display(Name = "External sub-contract")]
        public int? ExtSubcontract { get; set; }

        [Display(Name = "Future recruitment")]
        public int? FutRecruit { get; set; }

        [Display(Name = "Inter department")]
        public int? IntDept { get; set; }

        [Display(Name = "Hours sub-contract")]
        public int? HrsSubcont { get; set; }
        
    }

    public class WFMovement
    {       
        public string Costcode { get; set; }       
        public string Yymm { get; set; }
        public List<MovemastModel> addMovemast { get; set; }
        public List<MovemastModel> editMovemast { get; set; }
        public List<MovemastModel> deleteMovemast { get; set; }
    }

    public class MovemastModel
    {       
        public string Costcode { get; set; }
        public string Yymm { get; set; }
        public int? Movement { get; set; }
        public int? Movetotcm { get; set; }
        public int? Movetosite { get; set; }
        public int? Movetoothers { get; set; }
        public int? ExtSubcontract { get; set; }
        public int? FutRecruit { get; set; }
        public int? IntDept { get; set; }
        public int? HrsSubcont { get; set; }

    }

    //public class OData<T>
    //{
    //    [JsonProperty("odata.context")]
    //    public string Metadata { get; set; }
    //    public T value { get; set; }
    //}

    //internal class ODataResponse<T>
    //{
    //    public T[] Value { get; set; }
    //}

    public class MovemastViewModelValue
    {
        [JsonProperty("@odata.etag")]
        public string costcode { get; set; }
        public string yymm { get; set; }        
        public int? movement { get; set; }        
        public int? movetotcm { get; set; }       
        public int? movetosite { get; set; }
        public int? movetoothers { get; set; }
        public int? extsubcontract { get; set; }
        public int? futrecruit { get; set; }
        public int? intdept { get; set; }
        public int? hrssubcont { get; set; }
    }

    public class RootObject
    {
        [JsonProperty("@odata.context")]
        public string context { get; set; }
        public List<MovemastViewModelValue> value { get; set; }
    }
}
