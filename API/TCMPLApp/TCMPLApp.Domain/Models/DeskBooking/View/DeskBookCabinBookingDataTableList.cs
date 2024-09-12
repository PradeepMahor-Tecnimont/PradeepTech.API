using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookCabinBookingDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Employee")]
        public string Empno { get; set; }

        [Display(Name = "Employee/Guest Name")]
        public string Name { get; set; }

        [Display(Name = "Booking date")]
        public DateTime? AttendanceDate { get; set; }

        [Display(Name = "Booked desk")]
        public string Deskid { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Employee Type")]
        public string Emptype { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }
    }
}
