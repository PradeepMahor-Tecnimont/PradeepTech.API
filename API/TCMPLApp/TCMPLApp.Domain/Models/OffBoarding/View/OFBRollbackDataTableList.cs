using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBRollbackDataTableList
    {
        public decimal? RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Dept Name")]
        public string DeptName { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Relieving Date")]
        public DateTime? RelievingDate { get; set; }

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

        public decimal? DeleteAllowed { get; set; }
        public decimal? ApprovAllowed { get; set; }
    }
}