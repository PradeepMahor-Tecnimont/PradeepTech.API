using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{

    [Serializable]
    public class LeaveApplicationsDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "HoD approval reason")]
        public string HodReason { get; set; }


        [Display(Name = "HR approval reason")]
        public string HrdReason { get; set; }

        public string FromTab { get; set; }

        [Display(Name = "Is previlege leave")]
        public decimal IsPl { get; set; }

        [Display(Name = "Previlege leave total")]
        public decimal PlTotal { get; set; }


        [Display(Name = "Edit previlege leave")]
        public string EditPlApp { get; set; }


        [Display(Name = "Medical certificate file name")]
        public string MedCertFileName { get; set; }

        public DateTime AppDate4Sort { get; set; }

        [Display(Name = "Lead")]
        public string Lead { get; set; }


        [Display(Name = "Application number")]
        public string AppNo { get; set; }


        [Display(Name = "Application date")]
        public string ApplicationDate { get; set; }

        [Display(Name = "Start date")]
        public DateTime StartDate { get; set; }

        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "DbCr")]
        public string DbCr { get; set; }

        [Display(Name = "Leave type")]
        public string LeaveType { get; set; }

        [Display(Name = "Leave period")]
        public string LeavePeriod { get; set; }

        [Display(Name = "Lead approval")]
        public string LeadApprovalDesc { get; set; }

        [Display(Name = "HoD approval")]
        public string HodApprovalDesc { get; set; }

        [Display(Name = "HR approval")]
        public string HrdApprovalDesc { get; set; }

        [Display(Name = "Leave approval reason")]
        public string LeadReason { get; set; }

        public decimal CanDeleteApp { get; set; }

        public decimal CanEditPlApp { get; set; }
    }

}
