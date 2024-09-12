using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HrTransferCostcodeDataTableListExcel
    {
        public string EmpNo { get; set; }

        public string EmpName { get; set; }

        [Display(Name = "Transfer Type")]
        public string TransferTypeText { get; set; }

        public string CurrentCostcode { get; set; }

        public string TargetCostcode { get; set; }

        public DateTime? TransferDate { get; set; }

        public DateTime? TransferEndDate { get; set; }

        public string Remarks { get; set; }

        public string StatusText { get; set; }

        public DateTime? EffectiveTransferDate { get; set; }

        [Display(Name = "Designation Code")]
        public string DesgcodeText { get; set; }

        public DateTime? ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }

        public string Action { get; set; }

        [Display(Name = "Approval Action")]
        public string ApprlActionDesc { get; set; }
    }
}