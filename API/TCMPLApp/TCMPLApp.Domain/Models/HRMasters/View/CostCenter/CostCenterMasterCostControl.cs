using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters.View
{
    public class CostCenterMasterCostControl
    {
        public string CostCodeId { get; set; }
        public string CostCode { get; set; }
        public string Tm01Id { get; set; }

        [Display(Name = "TM01 group")]
        public string Tm01Grp { get; set; }

        [Display(Name = "TM01 group name")]
        public string Tm01GrpName { get; set; }

        public string TmaId { get; set; }

        [Display(Name = "TMA")]
        public string TmaGrp { get; set; }

        [Display(Name = "TMA group name")]
        public string TmaGrpName { get; set; }

        public string Activity { get; set; }

        [Display(Name = "Group chart")]
        public string GroupChart { get; set; }

        [Display(Name = "Italian name")]
        public string ItalianName { get; set; }

        public string CmId { get; set; }

        [Display(Name = "Company report")]
        public string CompReport { get; set; }

        [Display(Name = "Company report name")]
        public string CompReportName { get; set; }

        [Display(Name = "Phase")]
        public string Phase { get; set; }        
        public string PhaseName { get; set; }

        public string IsEditable { get; set; }

    }
}
