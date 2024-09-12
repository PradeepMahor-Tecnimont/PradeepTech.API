using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Collections;

namespace TCMPLApp.Domain.Models.SWP
{
    public class OfficeAtndDataTableList
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

        [Display(Name = "Area Category")]
        public string AreaCategory { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Attendance date")]
        public string AtndDate { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Assign workspace id")]
        public string FkSwpAssignworkspace { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        public string ParentDesc { get; set; }
        public string AssignDesc { get; set; }

        public string DDay { get; set; }

        public IList WeekDays { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Total count")]
        public decimal TotalCount { get; set; }

        [Display(Name = "Available count")]
        public decimal AvailableCount { get; set; }

        [Display(Name = "Occupied count")]
        public decimal OccupiedCount { get; set; }

        #region WorkAreaDesks

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Display(Name = "Seat no")]
        public string SeatNo { get; set; }

        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [Display(Name = "Asset code")]
        public string AssetCode { get; set; }

        [Display(Name = "Bay")]
        public string Bay { get; set; }

        public string PlanningExists { get; set; }

        #endregion WorkAreaDesks

        public decimal EditAllowed { get; set; }
        public decimal? Planned { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}