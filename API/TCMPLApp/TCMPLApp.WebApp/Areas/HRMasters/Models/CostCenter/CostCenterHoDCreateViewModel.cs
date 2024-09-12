using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class CostCenterHoDCreateViewModel
    {        
        public string CostCodeId { get; set; }
        public string CostCode { get; set; }

        [Display(Name = "Dy HoD")]
        public string DyHoD { get; set; }

        [Display(Name = "Changed no. of employess")]
        [Range(0, 999)]
        public Int32 ChangedNemps { get; set; }
    }
}
