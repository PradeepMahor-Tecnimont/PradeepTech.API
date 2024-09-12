using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters.View
{
    public class CostCenterMasterAFC
    {
        public string CostCodeId { get; set; }
        public string CostCode { get; set; }
        public string TcmCostCodeId { get; set; }

        [Display(Name = "TCM cost code")]
        public string TcmCostCode { get; set; }

        [Display(Name = "TCM cost code name")]
        public string TcmCostCodeName { get; set; }
        public string TcmActPhId { get; set; }

        [Display(Name = "TCM activity phase")]
        public string TcmActPh { get; set; }

        [Display(Name = "TCM activity phase name")]
        public string TcmActPhName { get; set; }
                
        public string TcmPasPhId { get; set; }

        [Display(Name = "TCM pas phase")]
        public string TcmPasPh { get; set; }

        [Display(Name = "TCM pas phase name")]
        public string TcmPasPhName { get; set; }

        [Display(Name = "Purchase order")]
        public string PO { get; set; }

        public string IsEditable { get; set; }

    }
}
