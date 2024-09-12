using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DMSGuestMasterDetailsViewModel
    {
        [Display(Name = "Guest master id")]
        public string GuestMasterId { get; set; }

        [Display(Name = "Guest EmpNo")]
        public string GuestEmpNo { get; set; }

        [Display(Name = "Guest name")]
        public string GuestName { get; set; }

        [Display(Name = "Cost code")]
        public string CostCode { get; set; }

        [Display(Name = "Project no")]
        public string ProjNo5 { get; set; }

        [Display(Name = "Project name")]
        public string ProjName { get; set; }

        [Display(Name = "From date")]
        public DateTime? FromDate { get; set; }

        [Display(Name = "To date")]
        public DateTime? ToDate { get; set; }

        [Display(Name = "Target desk")]
        public string TargetDesk { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified date")]
        public DateTime? ModifiedDate { get; set; }
    }
}