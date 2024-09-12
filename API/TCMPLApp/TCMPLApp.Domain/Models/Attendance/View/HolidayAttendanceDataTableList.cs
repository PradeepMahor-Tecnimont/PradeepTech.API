using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class HolidayAttendanceDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Application number")]
        public string AppNo { get; set; }

        [Display(Name = "Application date")]
        public string AppliedOn { get; set; }

        [Display(Name = "Project")]
        public string Project { get; set; }

        [Display(Name = "Holiday attendance date")]
        public string HolidayAttendanceDate { get; set; }

        [Display(Name = "Time")]
        public string Time { get; set; }

        [Display(Name = "Location")]
        public string Office { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "Lead name")]
        public string LeadName { get; set; }

        [Display(Name = "Lead approval")]
        public string LeadApproval { get; set; }

        [Display(Name = "HoD approval")]
        public string HodApproval { get; set; }

        [Display(Name = "HR approval")]
        public string HrApproval { get; set; }

        [Display(Name = "Lead remarks")]
        public string LeadRemarks { get; set; }

        [Display(Name = "HoD remarks")]
        public string HoDRemarks { get; set; }

        [Display(Name = "Hr remarks")]
        public string HrRemarks { get; set; }

        public decimal DeleteAllowed { get; set; }
    }
}