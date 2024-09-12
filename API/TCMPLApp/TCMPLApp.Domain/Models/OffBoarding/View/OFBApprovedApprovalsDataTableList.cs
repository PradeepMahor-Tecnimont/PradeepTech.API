using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBApprovedApprovalsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Dept Name")]
        public string ParentName { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Relieving Date")]
        public DateTime RelievingDate { get; set; }

        [Display(Name = "Initiator Remarks")]
        public string InitiatorRemarks { get; set; }

        [Display(Name = "My Approval Status")]
        public string ApprovalStatus { get; set; }

        [Display(Name = "My Approval Action")]
        public string ActionDesc { get; set; }

        [Display(Name = "Overall Approval Status")]
        public string OverallApprovalStatus { get; set; }

        public string IsRollbackInitiated { get; set; }
        public string ApprlActionId { get; set; }
    }

    //public class OFBApprovedApprovalsXLDataTableList
    //{
    //    public string Empno { get; set; }
    //    public string EmployeeName { get; set; }
    //    public string Parent { get; set; }
    //    public string DepartmentName { get; set; }
    //    public string Grade { get; set; }
    //    public DateTime? RelievingDate { get; set; }
    //    public string ApprovalStatus { get; set; }
    //    public string InitiatorRemarks { get; set; }
    //    public string ActionDesc { get; set; }
    //    public string OverallApprovalStatus { get; set; }
    //    public string ExitApprovalRemarks { get; set; }
    //}
}