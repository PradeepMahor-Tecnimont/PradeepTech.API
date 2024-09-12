using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OFBRollbackRequestViewModel
    {
        [Display(Name = "Employee")]
        [Required]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string EmployeeName { get; set; }

        [Display(Name = "Person Id")]
        public string PersonId { get; set; }

        [Display(Name = "Email Id")]
        public string EmailId { get; set; }

        [Display(Name = "Employee Type")]
        public string EmpType { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string DesgCode { get; set; }

        [Display(Name = "Designation")]
        public string DesgName { get; set; }

        [Display(Name = "Department")]
        public string CostCode { get; set; }

        [Display(Name = "Department")]
        public string CostName { get; set; }

        [Display(Name = "HOD")]
        public string Hod { get; set; }

        [Display(Name = "HOD")]
        public string HodName { get; set; }

        [Display(Name = "End by date")]
        public DateTime? EndByDate { get; set; }

        [Display(Name = "Relieving date")]
        public DateTime? RelievingDate { get; set; }

        [Display(Name = "Resignation date")]
        public DateTime? ResignationDate { get; set; }

        [Display(Name = "Date of Joining")]
        public DateTime? Doj { get; set; }


        [Display(Name = "Address")]
        public string Address { get; set; }

        [Display(Name = "Primary mobile")]
        public string PrimaryMobile { get; set; }

        [Display(Name = "Alternate number")]
        public string AlternateMobile { get; set; }

        [Display(Name = "Rollback remarks")]
        [Required]
        [MaxLength(200)]
        public string RollbackRemarks { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }
    }
}