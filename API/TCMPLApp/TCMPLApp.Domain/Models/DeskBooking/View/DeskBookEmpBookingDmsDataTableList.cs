using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookEmpBookingDmsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Parent")]
        public string DeptCode { get; set; }

        [Display(Name = "Department")]
        public string DeptName { get; set; }

        [Display(Name = "Area")]
        public string AreaDesc { get; set; }

        [Display(Name = "Booking date")]
        public DateTime? BookingDate { get; set; }

        [Display(Name = "Booked desk")]
        public string BookedDesk { get; set; }

        [Display(Name = "Desk office")]
        public string DeskOffice { get; set; }

        [Display(Name = "Shift code")]
        public string Shiftcode { get; set; }

        [Display(Name = "Is Present")]
        public string IsPresent { get; set; }
    }
}