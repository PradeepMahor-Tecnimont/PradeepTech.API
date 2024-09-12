using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class HolidayAttendanceApprovalDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Application date")]
        public string ApplicationDate { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmpName { get; set; }

        [Display(Name = "Project")]
        public string Project { get; set; }

        [Display(Name = "Lead name")]
        public string LeadName { get; set; }

        [Display(Name = "Attendance date time")]
        public string AttendanceDate { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

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