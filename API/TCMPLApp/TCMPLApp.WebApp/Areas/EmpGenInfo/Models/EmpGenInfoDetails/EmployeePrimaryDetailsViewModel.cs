using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeePrimaryDetailsViewModelToDelete
    {
        //public PrimaryDetailViewModel PrimaryDetails { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Do not include father's / husband's name in my full name.")]
        public string NameFilter { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "First Name")]
        public string EmpName { get; set; }

        [Required]
        [StringLength(15)]
        [Display(Name = "Surname")]
        public string Surname { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Father's / Husband Name")]
        public string EmpFatherrHusbandName { get; set; }

        [Required]
        [StringLength(300)]
        [Display(Name = "Address ")]
        public string Address { get; set; }

        [Required]
        [StringLength(6)]
        [Display(Name = "Pincode")]
        public string Pincode { get; set; }

        [StringLength(10)]
        [Display(Name = "State")]
        public string State { get; set; }

        [StringLength(4)]
        [Display(Name = "House No")]
        public string HouseNo { get; set; }

        [StringLength(10)]
        [Display(Name = "City")]
        public string City { get; set; }

        [StringLength(10)]
        [Display(Name = "District")]
        public string District { get; set; }

        [StringLength(10)]
        [Display(Name = "Country")]
        public string Country { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Place Of Birth (Preferably as per Passport)")]
        public string BirthPlace { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Nationality")]
        public string Nationality { get; set; }

        [StringLength(11)]
        [Display(Name = "Phone No")]
        public string Phone { get; set; }

        [StringLength(11)]
        [Display(Name = "Mobile No")]
        public string Mobile { get; set; }

        [StringLength(20)]
        [Display(Name = "Personal Email")]
        public string EmailId { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Country Of Birth")]
        public string BirthCountry { get; set; }

        [StringLength(2)]
        [Display(Name = "No Of Children")]
        public string NoOfChildren { get; set; }
    }
}