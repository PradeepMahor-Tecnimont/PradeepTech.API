using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class CostCenterMainCreateViewModel
    {        
        public string CostCodeId { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Cost code")]
        public string CostCode { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Cost code name")]
        public string Name { get; set; }

        [Required]
        [StringLength(11)]
        [Display(Name = "Abbreviation")]
        public string Abbr { get; set; }

        [Required]
        [Display(Name = "HoD")]
        public string HoD { get; set; }

        [Required]
        [Display(Name = "Employees")]
        [Range(0, 99999)]
        public Int32 NoOfEmps { get; set; }

        [Required]
        [Display(Name = "Cost group")]
        public string CostGroupId { get; set; }

        [Required]
        [Display(Name = "Group cost code")]
        public string GroupId { get; set; }

        [Required]
        [Display(Name = "Cost type")]
        public string CostTypeId { get; set; }

        [Display(Name = "Secretary")]
        public string Secretary { get; set; }

        [Display(Name = "Start date")]
        public DateTime? SDate { get; set; }

        [Display(Name = "End date")]
        public DateTime? EDate { get; set; }

        [StringLength(6)]
        [Display(Name = "SAP cost code")]
        public string SAPCC { get; set; }

        [Display(Name = "Parent cost code")]
        public string ParentCostCodeId { get; set; }

        [Display(Name = "Engg / Non engg")]
        public string EnggNonengg { get; set; }
    }
}
