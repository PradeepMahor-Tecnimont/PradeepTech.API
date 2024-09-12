using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Models
{
    public class ExtraHoursClaimApprovalViewModel : Domain.Models.Attendance.ExtraHoursClaimApprovalDataTableList
    {
        public ExtraHoursClaimApprovalViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }
    }

    public class ExtraHoursAdjustmentViewModel
    {
        [Display(Name = "Employee")]
        public string Employee { get; set; }

        public string ProfileType { get; set; } // Lead , Hod , Hr

        public string ApplicationId { get; set; }

        public string ClaimedOt { get; set; }

        public string ClaimedHhot { get; set; }

        public string ClaimedCo { get; set; }

        public string LeadApprovedOt { get; set; }

        public string LeadApprovedHhot { get; set; }

        public string LeadApprovedCo { get; set; }

        public string HodApprovedOt { get; set; }

        public string HodApprovedHhot { get; set; }

        public string HodApprovedCo { get; set; }

        public string HrApprovedOt { get; set; }

        public string HrApprovedHhot { get; set; }

        public string HrApprovedCo { get; set; }
    }
}