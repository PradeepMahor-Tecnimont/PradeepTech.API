using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBResetApprovalsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string EmpName { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Dept Name")]
        public string ParentName { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }
        public string ActionId { get; set; }

        [Display(Name = "Relieving Date")]
        public DateTime RelievingDate { get; set; }
        public string RelievingDateString { get; set; }

        [Display(Name = "Initiator Remarks")]
        public string InitiatorRemarks { get; set; }

        [Display(Name = "Approval Status")]
        public string ApprovalStatus { get; set; }
        public string IsApproved { get; set; }
        public string IsRollbackInitiated { get; set; }
    }
}
