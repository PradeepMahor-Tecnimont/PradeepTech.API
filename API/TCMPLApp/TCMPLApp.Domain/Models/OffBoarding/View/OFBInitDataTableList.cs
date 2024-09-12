using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBInitDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Name")]
        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Dept Name")]
        public string DeptName { get; set; }

        [Display(Name = "Dept Name")]
        public string ParentName { get; set; }
        
        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Relieving Date")]
        public DateTime RelievingDate { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Initiator Remarks")]
        public string InitiatorRemarks { get; set; }

        [Display(Name = "Approval Status")]
        public string ApprovalStatus { get; set; }

        [Display(Name = "Overall Approval Status")]
        public string OverallApprovalStatus { get; set; }
        public string IsRollbackInitiated { get; set; }

        public decimal? RollBackAllowed { get; set; }
        public string IsApproved { get; set; }
        public string ApprlActionId { get; set; }

        [Display(Name = "Approver Action")]
        public string ActionDesc { get; set; }

        [Display(Name = "MyApproval Action")]
        public string MyApprovalAction { get; set; }
        public string IsApprlDue { get; set; }
        public string ActionId { get; set; }
    }

    public class OFBInitXLDataTableList
    {
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Parent { get; set; }
        public string Dept { get; set; }
        public string Grade { get; set; }
        public string RelievingDate { get; set; }
        public string Remarks { get; set; }
        public string ApprovalStatus { get; set; }
    }
    
    public class OFBHistroyXLDataTableList
    {
        public string Empno { get; set; }
        public string EmployeeName { get; set; }
        public string Emptype { get; set; }
        public string PrimaryMobile { get; set; }
        public string AlternateMobile { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Parent { get; set; }
        public string DepartmentName { get; set; }
        public string Grade { get; set; }
        public DateTime? RelievingDate { get; set; }
        public string ApprovalStatus { get; set; }
        public string InitiatorRemarks { get; set; }
        public string EmpnoName { get; set; }
        public string DeptName { get; set; }
        public string ActionDesc { get; set; }
        public DateTime? ApprovalDate { get; set; }
        public string TmKeyId { get; set; }
        public string TemplateDesc { get; set; }
        public string TgKeyId { get; set; }
        public string RelievingDateString { get; set; }
        public string ApprovalDateString { get; set; }
    }

    public class OFBApprovalsXLDataTableList
    {
        public string Empno { get; set; }
        public string EmployeeName { get; set; }
        public string Parent { get; set; }
        public string DepartmentName { get; set; }
        public string Grade { get; set; }
        public DateTime? RelievingDate { get; set; }
        public string ActionDesc { get; set; }
        public string ApprovalStatus { get; set; }
        public string ExitApprovalRemarks { get; set; }

        public string InitiatorRemarks { get; set; }
        public string OverallApprovalStatus { get; set; }

    }

}