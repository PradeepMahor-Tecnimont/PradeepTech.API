using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LeaveDetailsViewModel
    {

        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Application Date")]
        public string ApplicationDate { get; set; }


        [Display(Name = "Employee name")]
        public string EmpName { get; set; }


        [Display(Name = "Application type")]
        public string LeaveType { get; set; }

        [Display(Name = "Leave start date")]
        public string StartDate { get; set; }

        [Display(Name = "Leave end date")]
        public string EndDate { get; set; }

        [Display(Name = "Leave period")]
        public string LeavePeriod { get; set; }

        [Display(Name = "Last date of reporting duty")]
        public string LastReporting { get; set; }

        [Display(Name = "Resuming duty on")]
        public string ResumingDuty { get; set; }

        [Display(Name = "Working on")]
        public string Project { get; set; }

        [Display(Name = "Work caretaker in your absence")]
        public string CareTaker { get; set; }

        [Display(Name = "Reason/Description of leave")]
        public string Reason { get; set; }


        [Display(Name = "Medical certificate available")]
        public string MedicalCertificate { get; set; }

        [Display(Name = "Phone number")]
        public string PhoneNumber { get; set; }

        [Display(Name = "Std. number")]
        public string StdNumber { get; set; }


        [Display(Name = "Address")]
        [MaxLength(60)]
        public string Address { get; set; }
        [Display(Name = "Office location")]
        public string POffice { get; set; }

        [Display(Name = "Lead Name")]
        public string LeadName { get; set; }

        [Display(Name = "Applicaiton Discrepancies")]
        public string Discrepancies { get; set; }

        [Display(Name = "Medical certificate file")]
        public string MedCertFileNm { get; set; }

        [Display(Name = "Lead approval")]
        public string LeadApproval { get; set; }

        [Display(Name = "HoD approval")]
        public string HodApproval { get; set; }

        [Display(Name = "HR approval")]
        public string HRApproval { get; set; }

        [Display(Name = "Lead remarks")]
        public string LeadReason { get; set; }

        [Display(Name = "HoD remarks")]
        public string HodReason { get; set; }

        [Display(Name = "HR remarks")]
        public string HRReason { get; set; }
        public string FlagIsAdj { get; set; }
        public string FlagCanDel { get; set; }

    }

    public class SLLeaveDetailsViewModel : LeaveDetailsViewModel
    {
        public decimal? SLAvailed { get; set; }
        public decimal? SLApplied { get; set; }
        public string Remarks { get; set; }
        public string FlagCanApprove { get; set; }
    }
}
