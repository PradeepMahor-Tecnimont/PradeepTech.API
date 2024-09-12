using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class HolidayAttendanceDetailsViewModel
    {
        [Display(Name = "Application Id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Project")]
        public string Project { get; set; }

        [Display(Name = "Lead name")]
        public string LeadName { get; set; }

        [Display(Name = "Attendance date")]
        public string AttendanceDate { get; set; }

        [Display(Name = "Punch in time")]
        public string PunchInTime { get; set; }

        [Display(Name = "Punch out time")]
        public string PunchOutTime { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Lead approval")]
        public string LeadApprl { get; set; }

        [Display(Name = "Lead approval date")]
        public string LeadApprlDate { get; set; }

        [Display(Name = "Lead empno")]
        public string LeadApprlEmpno { get; set; }

        [Display(Name = "HoD approval")]
        public string HodApprl { get; set; }

        [Display(Name = "HoD approval date")]
        public string HodApprlDate { get; set; }

        [Display(Name = "HR approval")]
        public string HrApprl { get; set; }

        [Display(Name = "HR approval date")]
        public string HrApprlDate { get; set; }

        public string Description { get; set; }

        [Display(Name = "Application date")]
        public string ApplicationDate { get; set; }

        [Display(Name = "HoD remarks")]
        public string HodRemarks { get; set; }

        [Display(Name = "HR remarks")]
        public string HrRemarks { get; set; }

        [Display(Name = "Lead remarks")]
        public string LeadRemarks { get; set; }
    }
}