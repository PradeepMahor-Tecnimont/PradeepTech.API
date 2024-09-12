using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class BookingSummaryDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }
        
        [Display(Name = "Work Area")]
        public string WorkArea { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Desk Count")]
        public decimal DeskCount { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Department Empno Count")]
        public decimal DeptEmpCount { get; set; }

        [Display(Name = "Booked Desks")]
        public decimal BookedDesks { get; set; }
    }
}
