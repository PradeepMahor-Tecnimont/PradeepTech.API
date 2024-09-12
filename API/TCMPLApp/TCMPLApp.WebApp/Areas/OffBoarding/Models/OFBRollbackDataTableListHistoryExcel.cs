using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OFBRollbackDataTableListHistoryExcel
    {
        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Requester remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Requested by")]
        public string RequestedBy { get; set; }

        [Display(Name = "Requested on")]
        public DateTime? RequestedOn { get; set; }

        [Display(Name = "Approved by")]
        public string ApprovedBy { get; set; }

        [Display(Name = "Approved on")]
        public DateTime? ApprovedOn { get; set; }
    }
}