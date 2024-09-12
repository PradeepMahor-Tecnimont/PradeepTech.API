using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class CostCenterCostControlCreateViewModel
    {        
        public string CostCodeId { get; set; }
        public string CostCode { get; set; }

        [Required]
        [Display(Name = "TM01 Group")]
        public string Tm01Id { get; set; }

        [Required]
        [Display(Name = "TMA Group")]
        public string TmaId { get; set; }

        [Required]
        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Required]
        [Display(Name = "Group chart")]
        public string GroupChart { get; set; }

        [StringLength(20)]
        [Display(Name = "Italian name")]
        public string ItalianName { get; set; }

        [Display(Name = "Company report")]
        public string CmId { get; set; }
                
        [Display(Name = "Phase")]
        public string Phase { get; set; }
    }
}
