using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters.View
{
    public class CostCenterMasterMainDataTableList
    {
        public string Costcodeid { get; set; }

        [Display(Name = "Cost code")]        
        public string Costcode { get; set; }

        [Display(Name = "Cost code name")]
        public string Name { get; set; }

        [Display(Name = "Abbreviation")]
        public string Abbr { get; set; }

        [Display(Name = "HoD")]
        public string Hodname { get; set; }

        public string IsEditable { get; set; }
    }
}
