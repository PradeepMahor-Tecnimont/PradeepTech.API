using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBApprovalDetailsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string Parent { get; set; }
        public string ParentName { get; set; }
        public string Grade { get; set; }
        public string ActionId { get; set; }
        public string ActionName { get; set; }

        [Display(Name = "Action")]
        public string ActionDesc { get; set; }

        [Display(Name = "Relieving Date")]
        public DateTime? RelievingDate { get; set; }

        [Display(Name = "Initiator Remarks")]
        public string InitiatorRemarks { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
        public string IsApproved { get; set; }

        [Display(Name = "Approval Status")]
        public string ApprovalStatus { get; set; }

        [Display(Name = "Approval Date")]
        public DateTime? ApprovalDate { get; set; }

        [Display(Name = "Approver")]
        public string ApproverName { get; set; }
        public string ApprlActionId { get; set; }
    }
}
