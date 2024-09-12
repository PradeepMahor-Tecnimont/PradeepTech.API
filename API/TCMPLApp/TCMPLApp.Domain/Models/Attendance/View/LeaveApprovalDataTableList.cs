using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveApprovalDataTableList
    {
        [Display(Name = "Employe name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Application date")]
        public DateTime ApplicationDate { get; set; }

        [Display(Name = "Application number")]
        public string ApplicationId { get; set; }

        [Display(Name = "Start date")]
        public DateTime StartDate { get; set; }

        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Leave period")]
        public string LeavePeriod { get; set; }

        [Display(Name = "Leave balance")]
        public decimal LeaveBalance { get; set; }

        [Display(Name = "Leave availed")]
        public decimal LeaveAvailed{ get; set; }

        [Display(Name = "Leave type")]
        public string LeaveType { get; set; }

        [Display(Name = "Lead")]
        public string LeadName { get; set; }

        [Display(Name = "Medical certificate")]
        public string MedCertFileName { get; set; }


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


        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

    }

}
