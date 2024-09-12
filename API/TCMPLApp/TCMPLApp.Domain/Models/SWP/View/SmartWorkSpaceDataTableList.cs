using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Collections;

namespace TCMPLApp.Domain.Models.SWP
{
    public class SmartWorkSpaceDataTableList
    {
        [Display(Name = "Id")]
        public string keyid { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Work area")]
        public string WorkArea { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Attendance date")]
        public string AttendanceDate { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }


        [Display(Name = "Floor")]
        public string Floor { get; set; }


        [Display(Name = "Wing")]
        public string Wing { get; set; }


        [Display(Name = "Bay")]
        public string Bay { get; set; }
        
        
        [Display(Name = "Assign workspace id")]
        public string WsKeyId { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Monday")]
        public decimal Mon { get; set; }

        [Display(Name = "Tuesday")]
        public decimal Tue { get; set; }

        [Display(Name = "Wednesday")]
        public decimal Wed { get; set; }

        [Display(Name = "Thursday")]
        public decimal Thu { get; set; }

        [Display(Name = "Friday")]
        public decimal Fri { get; set; }

        public string ParentDesc { get; set; }
        public string AssignDesc { get; set; }

        public string DDay { get; set; }
        public DateTime DDate { get; set; }

        public IList WeekDays { get; set; }

        public string PlanningExists { get; set; }
        public decimal EditAllowed { get; set; }
        public decimal? Planned { get; set; }
        public bool IsPlanned { 
            get { return Convert.ToBoolean(Planned.GetValueOrDefault()); }
            set { Planned = Convert.ToDecimal(value); }
        }
        public decimal? IsHoliday { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}