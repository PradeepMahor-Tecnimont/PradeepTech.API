using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters.View
{
    public class CostCenterMasterHoD
    {
        public string CostCodeId { get; set; }

        public string CostCode { get; set; }

        [Display(Name = "Dy HoD")]
        public string DyHoD { get; set; }

        public string DyHoDPersonId { get; set; }

        [Display(Name = "Dy HoD")]
        public string DyHoDName { get; set; }

        [Display(Name = "Changed no. of employess")]
        public Int32 ChangedNemps { get; set; }

        public string IsEditable { get; set; }
    }
}
