using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class EmpBookedDeskListDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Name { get; set; }

        [Display(Name = "Desk Id")]
        public string Deskid { get; set; }
        
        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Start Time")]
        public decimal StartTime { get; set; }

        [Display(Name = "End Time")]
        public decimal EndTime { get; set; }
    }
}
