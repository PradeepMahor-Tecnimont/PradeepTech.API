using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmpGenInfoGratuityViewModel
    {
        public GetLockStatusDetailViewModel LockStatusDetailViewModel { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [StringLength(20)]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [StringLength(15)]
        [Display(Name = "Surname")]
        public string Surname { get; set; }

        [StringLength(20)]
        [Display(Name = "Father's / Husband Name")]
        public string FatherName { get; set; }

        [StringLength(300)]
        [Display(Name = "Address ")]
        public string Address { get; set; }

        [StringLength(6)]
        [Display(Name = "Pincode")]
        public string Pincode { get; set; }

        [Display(Name = "Do not include father's / husband's name in my full name.")]
        public bool NoDadHusbInName { get; set; }
    }
}