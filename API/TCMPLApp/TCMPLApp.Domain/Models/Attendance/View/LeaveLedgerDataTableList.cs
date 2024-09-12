using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class LeaveLedgerDataTableList
    {

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Application number")]
        public string AppNo { get; set; }

        [Display(Name = "Entry date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime ApplicationDate { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }


        [Display(Name = "Leave begin date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime StartDate { get; set; }


        [Display(Name = "Leave end date")]
        [DisplayFormat(ApplyFormatInEditMode = false, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? EndDate { get; set; }

        [Display(Name = "Leave type")]
        public string LeaveType { get; set; }

        [Display(Name = "Number of Days(cr)")]
        public string NoOfDaysCr { get; set; }

        [Display(Name = "Number of Days(dr)")]
        public string NoOfDaysDb { get; set; }

    }
}
