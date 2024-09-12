using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Collections;

namespace TCMPLApp.Domain.Models.SWP
{
    public class EmployeeWorkSpaceDataTableList
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Employee work area")]
        public string EmployeeWorkArea { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [Display(Name = "Desk")]
        public string Desk { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        public string DDay { get; set; }
        public DateTime DDate { get; set; }

        public IList WeekDays { get; set; }

        public decimal? IsHoliday { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}