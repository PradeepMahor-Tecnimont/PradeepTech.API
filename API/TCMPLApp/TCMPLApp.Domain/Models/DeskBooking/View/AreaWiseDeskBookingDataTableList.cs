using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class AreaWiseDeskBookingDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }
        
        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Id")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [Display(Name = "Desk Id")]
        public string DeskId { get; set; }

        [Display(Name = "Employee")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee Name")]
        public string EmpName { get; set; }

        [Display(Name = "Attendance Date")]
        public DateTime? AttendanceDate { get; set; }

        [Display(Name = "Status")]
        public string IsBooked { get; set; }

    }
}
