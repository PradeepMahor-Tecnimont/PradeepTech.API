using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpGenInfoPrimaryDetailsViewModel
    {
        public PrimaryDetailViewModel PrimaryDetails { get; set; }

        //public EmployeePrimaryDetailsViewModel EmployeePrimaryDetailsViewModel { get; set; }
        //public EmployeePrimaryDetailsEditViewModel EmployeePrimaryDetailsEditViewModel { get; set; }
        public GetLockStatusDetailViewModel LockStatusDetailViewModel { get; set; }

        public GetDescripancyDetailViewModel DescripancyDetailViewModel { get; set; }

        //public string IsOk = "OK";

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [StringLength(20)]
        [Display(Name = "First Name")]
        public string EmpName { get; set; }

        [StringLength(15)]
        [Display(Name = "Surname")]
        public string Surname { get; set; }

        [StringLength(20)]
        [Display(Name = "Father's / Husband Name")]
        public string EmpFatherrHusbandName { get; set; }

        [StringLength(300)]
        [Display(Name = "Address ")]
        public string Address { get; set; }

        [StringLength(6)]
        [Display(Name = "Pincode")]
        public string Pincode { get; set; }

    }
}