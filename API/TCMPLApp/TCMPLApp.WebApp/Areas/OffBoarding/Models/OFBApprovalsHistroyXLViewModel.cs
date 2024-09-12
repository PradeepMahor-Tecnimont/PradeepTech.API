using System;

namespace TCMPLApp.WebApp.Models
{
    public class OFBApprovalsHistroyXLViewModel
    {
        public string Empno { get; set; }
        public string EmployeeName { get; set; }
        public string Emptype { get; set; }
        public string Parent { get; set; }
        public string DepartmentName { get; set; }
        public string Grade { get; set; }
        public DateTime? RelievingDate { get; set; }
        public string ApprovalStatus { get; set; }
        public string InitiatorRemarks { get; set; }
        //public string IsApprovalComplete { get; set; }
    }
}