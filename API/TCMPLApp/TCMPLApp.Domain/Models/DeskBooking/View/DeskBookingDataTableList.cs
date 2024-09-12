using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskBookingDataTableList
    {
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Date")]
        public DateTime AttendanceDate { get; set; }
        //public string DayOfWeek { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }
        public string ActionType { get; set; }

    }
}
