using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class VaccinationOfficeRegistrations
    {

        [Display(Name = "EmpNo")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "DeptDesc")]
        public string DeptDesc { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "EmpType")]
        public string Emptype { get; set; }

        [Display(Name = "Cowin-App Registered")]
        public string IsCowinRegistred { get; set; }
        
        //public string CowinRegtrd { get; set; }

        [Display(Name = "Mobile")]
        public string MobileNumber { get; set; }

        [Display(Name = "Mode of Transport")]
        public string ModeOfTransport { get; set; }

        //public string OfficeBus { get; set; }

        [Display(Name = "BusRoute")]
        public string OfficeBusRoute { get; set; }

        [Display(Name = "Attending Vaccination")]
        public string IsAttendingVaccination { get; set; }
        
        //public string AttendingVaccination { get; set; }

        [Display(Name = "Not Attending Reason")]
        public string NotAttendingReason { get; set; }

        [Display(Name = "Jab Number")]
        public string JabNumber { get; set; }
    }
}
