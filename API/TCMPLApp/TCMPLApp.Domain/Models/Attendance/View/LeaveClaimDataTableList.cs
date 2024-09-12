using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{

    [Serializable]
    public class LeaveClaimsDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Employe name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Application number")]
        public string ApplicationId { get; set; }

        [Display(Name = "Application date")]
        public DateTime ApplicationDate { get; set; }

        [Display(Name = "Start date")]
        public DateTime StartDate { get; set; }

        [Display(Name = "End date")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "DbCr")]
        public string DbCr { get; set; }

        [Display(Name = "Leave type")]
        public string LeaveType { get; set; }

        [Display(Name = "Leave period")]
        public decimal LeavePeriod { get; set; }

        [Display(Name = "Medical certificate file name")]
        public string MedCertFileName { get; set; }


    }

}
