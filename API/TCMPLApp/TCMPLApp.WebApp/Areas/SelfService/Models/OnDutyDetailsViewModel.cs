using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OnDutyDetailsViewModel
    {
        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Employee name")]
        public string EmpName { get; set; }

        [Display(Name = "Employee no")]
        public string EmpNo { get; set; }

        [Display(Name = "Application type")]
        public string OnDutyType { get; set; }

        [Display(Name = "OnDuty start date")]
        public string StartDate { get; set; }

        [Display(Name = "OnDuty end date")]
        public string EndDate { get; set; }

        [Display(Name = "Reason/Description of leave")]
        public string Reason { get; set; }

        [Display(Name = "Lead Name")]
        public string LeadName { get; set; }

        [Display(Name = "Lead approval")]
        public string LeadApproval { get; set; }

        [Display(Name = "HoD approval")]
        public string HodApproval { get; set; }

        [Display(Name = "HR approval")]
        public string HRApproval { get; set; }

        [Display(Name = "On duty sub-type")]
        public string OnDutySubType { get; set; }

        [Display(Name = "Start time")]
        public string StartTime { get; set; }

        [Display(Name = "End time")]
        public string EndTime { get; set; }
    }
}