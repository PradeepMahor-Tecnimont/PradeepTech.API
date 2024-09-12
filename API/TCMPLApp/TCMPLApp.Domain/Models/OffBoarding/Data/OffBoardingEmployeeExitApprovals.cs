using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingEmployeeExitApprovals
    {
        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string ActionId { get; set; }
        public string ActionDesc { get; set; }
        public string RoleId { get; set; }
        public string Remarks { get; set; }
        public string IsApproved { get; set; }

        [Display(Name = "Approval Status")]
        public string IsApprovedDesc { get; set; }
        public DateTime? ApprovalDate { get; set; }
        public string ApprovedBy { get; set; }
        public string ApproverName { get; set; }
        public string GroupName { get; set; }
        public string PrevGroupName { get; set; }
    }
}
