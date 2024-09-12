using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class CostcodeChangeRequestDetailsViewModel
    {
        public string KeyId { get; set; }

        public string ActionId { get; set; }

        [Display(Name = "Transfer Type")]
        public string TransferType { get; set; }

        public decimal TransferVal { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        public string Empno { get; set; }

        [Display(Name = "Current Costcode")]
        public string CurrentCostCode { get; set; }

        public string CurrentCostCodeVal { get; set; }

        [Required(ErrorMessage = "Target Costcode is required")]
        [Display(Name = "Target Costcode")]
        public string TargetCostCode { get; set; }

        [Display(Name = "Target Costcode")]
        public string TargetCostCodeVal { get; set; }

        [Required]
        [Display(Name = "Transfer date")]
        public DateTime? TransferDate { get; set; }

        [Display(Name = "Transfer end date")]
        public DateTime? TransferEndDate { get; set; }

        [Required]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [StringLength(100)]
        [Display(Name = "Remarks")]
        public string ApprovalRemarks { get; set; }

        [Display(Name = "Effective payroll transfer date")]
        public DateTime? EffectiveTransferDate { get; set; }

        [Display(Name = "Designation Code")]
        public string DesgCode { get; set; }

        public string BtnName { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Site")]
        public string SiteCode { get; set; }

        public decimal StatusVal { get; set; }

        [Display(Name = "Current designation")]
        public string CurrentDesignation { get; set; }

        [Display(Name = "Current job title")]
        public string CurrentJobTitle { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Job group code")]
        public string JobGroupCode { get; set; }

        [Display(Name = "Job group")]
        public string JobGroup { get; set; }

        [Display(Name = "Job discipline code")]
        public string JobdisciplineCode { get; set; }

        [Display(Name = "Job discipline")]
        public string Jobdiscipline { get; set; }

        [Display(Name = "Job title code")]
        public string JobtitleCode { get; set; }

        [Display(Name = "Job title")]
        public string Jobtitle { get; set; }

        [Display(Name = "Approver - HoD remarks")]
        public string TargetHodRemarks { get; set; }

        [Display(Name = "HR remarks")]
        public string HrRemarks { get; set; }

        [Display(Name = "HR HoD remarks")]
        public string HrHoDRemarks { get; set; }

        public List<ExtensionDetails> ExtensionDetailsList { get; set; }

        public CostcodeChangeRequestDetailsViewModel()
        {
            this.ExtensionDetailsList = new List<ExtensionDetails>();
        }
                
        public string DesgcodeNew { get; set; }

        public string JobGroupCodeNew { get; set; }

        public string JobdisciplineCodeNew { get; set; }

        public string JobtitleCodeNew { get; set; }

        [Display(Name = "New Designation")]
        public string DesgNew { get; set; }

        [Display(Name = "New job group")]
        public string JobGroupNew { get; set; }

        [Display(Name = "New job discipline")]
        public string JobdisciplineNew { get; set; }

        [Display(Name = "New job title")]
        public string JobtitleNew { get; set; }

        [Display(Name = "Site")]
        public string SiteName { get; set; }

        public string SiteLocation { get; set; }
    }

    public class ExtensionDetails
    {
        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedByName { get; set; }

        [Display(Name = "Transfer end date")]
        public DateTime? TransferEndDate { get; set; }

        public string Remarks { get; set; }
    }
}