using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookingAttendanceStatusDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Area")]
        public string AreaDesc { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string DeptCode { get; set; }

        [Display(Name = "Department")]
        public string DeptName { get; set; }

        [Display(Name = "Booking date")]
        public DateTime? BookingDate { get; set; }

        [Display(Name = "Booked desk")]
        public string BookedDesk { get; set; }

        [Display(Name = "Desk office")]
        public string DeskOffice { get; set; }

        [Display(Name = "Shift code")]
        public string Shiftcode { get; set; }

        [Display(Name = "Is Present")]
        public decimal IsPresentVal { get; set; }

        [Display(Name = "Is Present")]
        public string IsPresent { get; set; }

        [Display(Name = "Desk booked")]
        public string IsDeskBook { get; set; }

        public decimal IsDeskBookVal { get; set; }

        [Display(Name = "Punch In Office")]
        public string PunchInOffice { get; set; }

        [Display(Name = "Cross Attendance")]
        public string IsCrossAttend { get; set; }

        public string EmpOfficeLocation { get; set; }

        public decimal IsCrossAttendVal { get; set; }
    }
}