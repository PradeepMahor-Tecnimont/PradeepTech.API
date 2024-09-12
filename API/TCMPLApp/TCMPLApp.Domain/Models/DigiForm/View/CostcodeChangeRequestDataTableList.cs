using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class CostcodeChangeRequestDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Emp No")]
        public string EmpNo { get; set; }

        public string EmpName { get; set; }

        [Display(Name = "Transfer Type")]
        public decimal TransferTypeVal { get; set; }

        [Display(Name = "Transfer Type")]
        public string TransferTypeText { get; set; }

        [Display(Name = "Current Costcode")]
        public string CurrentCostcode { get; set; }

        [Display(Name = "Target Costcode")]
        public string TargetCostcode { get; set; }

        [Display(Name = "Transfer / Travel date")]
        public DateTime? TransferDate { get; set; }

        [Display(Name = "Transfer End Date")]
        public DateTime? TransferEndDate { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Status Value")]
        public decimal StatusVal { get; set; }

        [Display(Name = "Status")]
        public string StatusText { get; set; }

        [Display(Name = "Effective payroll transfer date")]
        public DateTime? EffectiveTransferDate { get; set; }

        [Display(Name = "DesgCode Value")]
        public string DesgcodeVal { get; set; }

        [Display(Name = "Designation Code")]
        public string DesgcodeText { get; set; }

        public DateTime? ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }

        [Display(Name = "Action")]
        public string Action { get; set; }

        public string ApprlActionId { get; set; }

        [Display(Name = "Approval Action")]
        public string ApprlActionDesc { get; set; }

        public string IsApprovalDue { get; set; }
        public decimal Flag { get; set; }
    }
}