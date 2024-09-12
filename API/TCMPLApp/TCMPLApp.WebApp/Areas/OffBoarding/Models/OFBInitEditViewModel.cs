using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OFBInitEditViewModel
    {
        [Display(Name = "EmpNo")]
        public string Empno { get; set; }


        [Display(Name = "Employee Name")]
        public string EmployeeName { get; set; }


        [Display(Name = "End by date")]
        [Required]
        public DateTime? EndByDate { get; set; }


        [Display(Name = "Relieving date")]
        [Required]
        public DateTime? RelievingDate { get; set; }

        [Display(Name = "Resignation date")]
        [Required]
        public DateTime? ResignationDate { get; set; }



        [Display(Name = "Remarks")]
        [Required]
        [MaxLength(200)]
        public string Remarks { get; set; }


        [Display(Name = "Address")]
        [MaxLength(200)]
        public string Address { get; set; }

        [Display(Name = "Primary mobile")]
        [RegularExpression(@"^([1-9][0-9]{9})$", ErrorMessage = "Invalid Mobile Number.")]
        public string MobilePrimary { get; set; }

        [Display(Name = "Alternate number")]
        [RegularExpression(@"^([0-9]{8,20})$", ErrorMessage = "Invalid Number.")]
        public string AlternateNumber { get; set; }
                
        [Required]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        [Display(Name = "Email Id")]
        public string EmailId { get; set; }

        [Display(Name = "Employee Type")]
        public string EmpType { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation Code")]
        public string DesgCode { get; set; }

        [Display(Name = "Designation Name")]
        public string DesgName { get; set; }

        [Display(Name = "Date of Joining")]
        public DateTime? Doj { get; set; }

        [Display(Name = "Dept Name")]
        public string CostName { get; set; }

        [Display(Name = "Hod")]
        public string Hod { get; set; }

        [Display(Name = "Hod Name")]
        public string HodName { get; set; }

        [Display(Name = "Person Id")]
        public string PersonId { get; set; }
    }
}
