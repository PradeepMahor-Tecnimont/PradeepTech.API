using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DMSGuestMasterUpdateViewModel
    {
        [Display(Name = "Guest master id")]
        public string GuestMasterId { get; set; }

        [Required]
        [Display(Name = "Gust EmpNo")]
        public string GuestEmpNo { get; set; }

        [Required]
        [Display(Name = "Guest name")]
        public string GuestName { get; set; }

        [Required]
        [Display(Name = "Cost code")]
        public string CostCode { get; set; }

        [Required]
        [Display(Name = "Project ")]
        public string ProjNo7 { get; set; }

        [Display(Name = "Project name")]
        public string ProjName { get; set; }

        [Display(Name = "From date")]
        public DateTime? FromDate { get; set; }

        [Required]
        [Display(Name = "To date")]
        public DateTime? ToDate { get; set; }

        [Display(Name = "Target desk")]
        public string TargetDesk { get; set; }

        [Display(Name = "Target desk")]
        public string NewTargetDesk { get; set; }

        [Display(Name = "CreatedBy")]
        public string CreatedBy { get; set; }

        [Display(Name = "CreationDate")]
        public DateTime? CreationDate { get; set; }

        [Display(Name = "ModifiedBy")]
        public string ModifiedBy { get; set; }

        [Display(Name = "ModifiedDate")]
        public DateTime? ModifiedDate { get; set; }
    }
}