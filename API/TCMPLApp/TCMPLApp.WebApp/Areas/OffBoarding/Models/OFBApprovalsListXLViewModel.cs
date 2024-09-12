using System;
using System.Collections.Generic;

namespace TCMPLApp.WebApp.Models
{
    public class OFBApprovalsListXLViewModel
    {
        public List<OFBApprovalList> Data { get; set; }

        public OFBApprovalsListXLViewModel()
        {
            this.Data = new List<OFBApprovalList>();
        }

    }

    public class OFBApprovalList
    {
        public string Empno { get; set; }
        public string EmployeeName { get; set; }
        public string Emptype { get; set; }
        public string Parent { get; set; }
        public string DepartmentName { get; set; }
        public string Grade { get; set; }
        public DateTime? RelievingDate { get; set; }
        public string ActionDesc { get; set; }
        public DateTime? ApprovalDate { get; set; }
        public string ApprovalStatus { get; set; }
        public string InitiatorRemarks { get; set; }
        public string TemplateDesc { get; set; }
        public string EmpnoName { get; set; }
        public string DeptName { get; set; }
        public string TmKeyId { get; set; }        
        public string TgKeyId { get; set; }
    }
}