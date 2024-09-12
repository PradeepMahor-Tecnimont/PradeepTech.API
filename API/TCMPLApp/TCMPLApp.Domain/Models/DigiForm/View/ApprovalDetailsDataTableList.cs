using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class ApprovalDetailsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }
        [Display(Name = "Employee")]
        public string Empno { get; set; }
        [Display(Name = "Transfer Type")]
        public string TransferType { get; set; }

        [Display(Name = "Current Costcode")]
        public string CurrentCostCode { get; set; }
        [Display(Name = "Target Costcode")]
        public string TargetCostCode { get; set; }

        [Display(Name = "Status")]
        public string ApprovalStatus { get; set; }
        
        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }
        public string ModifiedByName { get; set; }
        
        [Display(Name = "Approved By")]
        public string ApprovalBy { get; set; }

        [Display(Name = "Transfer end date")]
        public DateTime? TransferEndDate { get; set; }

        public string Remarks { get; set; }
    }
}
