using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeePrimaryDetailsEditViewModel
    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Do not include father's / husband's name in my full name.")]
        public string NameFilter { get; set; }

        [Required]
        [StringLength(60)]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [Required]
        [StringLength(60)]
        [Display(Name = "Surname")]
        public string Surname { get; set; }

        [Required]
        [StringLength(60)]
        [Display(Name = "Father's / Husband Name")]
        public string FatherName { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Address ")]
        public string PAdd1 { get; set; }

        [StringLength(100)]
        [Display(Name = "House No")]
        public string PHouseNo { get; set; }

        [StringLength(100)]
        [Display(Name = "City")]
        public string PCity { get; set; }

        [StringLength(100)]
        [Display(Name = "District")]
        public string PDistrict { get; set; }

        [Required]
        [StringLength(6)]
        [Display(Name = "Pincode")]
        public string PPincode { get; set; }

        [StringLength(100)]
        [Display(Name = "Country")]
        public string PCountry { get; set; }

        [StringLength(50)]
        [Display(Name = "State")]
        public string PState { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Place Of Birth (Preferably as per Passport)")]
        public string PlaceOfBirth { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Country Of Birth")]
        public string CountryOfBirth { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Nationality")]
        public string Nationality { get; set; }

        [StringLength(50)]
        [Display(Name = "Phone No")]
        public string PPhone { get; set; }

        [StringLength(2)]
        [Display(Name = "No Of Children")]
        public string NoOfChild { get; set; }

        [StringLength(150)]
        [Display(Name = "Personal Email")]
        public string PersonalEmail { get; set; }

        [StringLength(50)]
        [Display(Name = "Mobile No")]
        public string PMobile { get; set; }

        [Display(Name = "Do not include father's / husband's name in my full name.")]
        public bool NoDadHusbInName { get; set; }
    }
}