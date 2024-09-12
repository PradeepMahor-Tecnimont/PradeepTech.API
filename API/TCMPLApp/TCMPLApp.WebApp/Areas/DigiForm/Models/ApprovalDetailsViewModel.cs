using System;
using System.ComponentModel.DataAnnotations;
using static TCMPLApp.WebApp.Classes.StorageHelper;

namespace TCMPLApp.WebApp.Models
{
    public class ApprovalDetailsViewModel : Domain.Models.DigiForm.ApprovalDetailsDataTableList
    {
        public ApprovalDetailsViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        [Display(Name = "Current designation")]
        public string CurrentDesignation { get; set; }

        [Display(Name = "Current job title")]
        public string CurrentJobTitle { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Transfer / Travel date")]
        public DateTime? TransferDate { get; set; }

        [Display(Name = "Effective payroll transfer date")]
        public DateTime? EffectiveTransferDate { get; set; }
    }
}