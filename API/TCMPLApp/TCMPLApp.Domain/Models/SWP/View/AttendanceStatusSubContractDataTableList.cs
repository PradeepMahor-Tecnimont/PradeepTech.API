using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class AttendanceStatusSubContractDataTableList
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }


        [Display(Name = "Office Location")]
        public string LocationDesc { get; set; }

        [Display(Name = "DeskId")]
        public string EmpDeskid { get; set; }

        [Display(Name = "D date")]
        public DateTime DDate { get; set; }


        public string PunchType { get; set; }

        public decimal PunchExists { get; set; }

    }

}