using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OFBApprovalUpdateViewModel
    {
        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Person Id")]
        public string PersonId { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Initiator Remarks")]
        public string InitiatorRemarks { get; set; }

        [Display(Name = "Primary Mobile")]
        public string MobilePrimary { get; set; }

        [Display(Name = "Alternate Number")]
        public string AlternateNumber { get; set; }

        [Display(Name = "Address")]
        public string Address { get; set; }

        [Display(Name = "Email Id")]
        public string EmailId { get; set; }

        [Display(Name = "Relieving Date")]
        public DateTime RelievingDate { get; set; }

        [Display(Name = "Retirement  / Resignation date")]
        public DateTime ResignationDate { get; set; }

        [Display(Name = "Date of joining")]
        public DateTime Doj { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
        public string ApprovalActionId { get; set; }
        public string IsDueForApproval { get; set; }
        public string IsApproved { get; set; }
        public string ViewName { get; set; }
        public string ApprovalType { get; set; }
        public string IsApprovalDue { get; set; }
        public string ActionDesc { get; set; }
    }

}
