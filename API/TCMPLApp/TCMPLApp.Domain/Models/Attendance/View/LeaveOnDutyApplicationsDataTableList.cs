using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    public class LeaveOnDutyApplicationsDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        public string ApplicationDate { get; set; }
        public string Empno { get; set; }

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Application for date")]
        public string ApplicationForDate { get; set; }

        [Display(Name = "Start date")]
        public DateTime StartDate { get; set; }

        [Display(Name = "Reason/Description of leave")]
        public string Description { get; set; }

        [Display(Name = "Application type")]
        public string OndutyType { get; set; }

        [Display(Name = "Lead Name")]
        public string LeadName { get; set; }

        [Display(Name = "Lead approval")]
        public string LeadApproval { get; set; }

        [Display(Name = "HoD approval")]
        public string HodApproval { get; set; }

        [Display(Name = "HR approval")]
        public string HrApproval { get; set; }
        public decimal CanDeleteApp { get; set; }
    }
}