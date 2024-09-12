using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveOnDutyApprovalDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Application date")]
        public string ApplicationDate { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Application for date")]
        public string ApplicationForDate { get; set; }

        [Display(Name = "Start date")]
        public string StartDate { get; set; }

        [Display(Name = "End date")]
        public string EndDate { get; set; }

        [Display(Name = "OnDuty type")]
        public string OndutyType { get; set; }

        [Display(Name = "Emp office")]
        public string Office { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Lead Name")]
        public string LeadName { get; set; }

        [Display(Name = "Emp Name")]
        public string EmpName { get; set; }

        [Display(Name = "Emp no")]
        public string EmpNo { get; set; }

        [Display(Name = "Lead Remarks")]
        public string LeadRemarks { get; set; }

        [Display(Name = "HoD Remarks")]
        public string HodRemarks { get; set; }

        [Display(Name = "Hr Remarks")]
        public string HrRemarks { get; set; }

        [Display(Name = "Yes")]
        public string ApproveYes { get; set; }

        [Display(Name = "No")]
        public string ApproveNo { get; set; }

        [Display(Name = "Pending")]
        public string ApprovePending { get; set; }
    }
}