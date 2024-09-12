using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class CostCenterAFCCreateViewModel
    {        
        public string CostCodeId { get; set; }
        public string CostCode { get; set; }
                
        [Display(Name = "TCM cost code")]
        public string TcmCostCodeId { get; set; }
                
        [Display(Name = "TCM activity phase")]
        public string TcmActPhId { get; set; }

        [Display(Name = "TCM pas phase")]
        public string TcmPasPhId { get; set; }

        [StringLength(10)]
        [Display(Name = "Purchase order")]
        public string PO { get; set; }
    }
}
