using System.ComponentModel.DataAnnotations;
using System;

namespace TCMPLApp.WebApp.Models
{
    public class OFBInitDetailsViewModel
    {
        [Display(Name = "Emp No")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Person Id")]
        public string PersonId { get; set; }

        [Display(Name = "Employee Type")]
        public string EmpType { get; set; }

        [Display(Name = "Hod")]
        public string Hod { get; set; }

        [Display(Name = "Hod Name")]
        public string HodName { get; set; }

        [Display(Name = "Designation Code")]
        public string DesgCode { get; set; }

        [Display(Name = "Designation Name")]
        public string DesgName { get; set; }

        [Display(Name = "Dept Name")]
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

        [Display(Name = "End by date")]
        [Required]
        public DateTime EndByDate { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
        
        [Display(Name = "Hr note")]
        public string ActionId { get; set; }
        public string ApprlActionId { get; set; }
        public string ViewName { get; set; }
    }
}
