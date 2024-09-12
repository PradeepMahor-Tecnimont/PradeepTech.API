using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeeSecondaryDetailsViewModelToDelete
    {
        public PrimaryDetailViewModel PrimaryDetails { get; set; }

        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Blood Group")]
        public string BloodGroup { get; set; }

        [Display(Name = "Religion")]
        public string Religion { get; set; }

        [Display(Name = "Marital Status")]
        public string MaritalStatus { get; set; }

        [Display(Name = "Address")]
        public string Address { get; set; }

        [Display(Name = "State")]
        public string State { get; set; }

        [Display(Name = "House No")]
        public string HouseNo { get; set; }

        [Display(Name = "City")]
        public string City { get; set; }

        [Display(Name = "District")]
        public string District { get; set; }

        [Display(Name = "Country")]
        public string Country { get; set; }

        [Display(Name = "Pincode")]
        public string Pincode { get; set; }

        [Display(Name = "Phone Res")]
        public string ResPhone { get; set; }

        [Display(Name = "Mobile Res")]
        public string ResMobile { get; set; }

        [Display(Name = "Ref Person Name")]
        public string RefPersonName { get; set; }

        [Display(Name = "Ref Person Phone")]
        public string RefPersonPhone { get; set; }

        [Display(Name = "Address")]
        public string RefAddress { get; set; }

        [Display(Name = "State")]
        public string RefPersonState { get; set; }

        [Display(Name = "House No")]
        public string RefPersonHouseNo { get; set; }

        [Display(Name = "City")]
        public string RefPersonCity { get; set; }

        [Display(Name = "District")]
        public string RefPersonDistrict { get; set; }

        [Display(Name = "Country")]
        public string RefPersonCountry { get; set; }

        [Display(Name = "Pincode")]
        public string RefPersonPincode { get; set; }

        [Display(Name = "Company Bus")]
        public string CompanyBus { get; set; }

        [Display(Name = "Pick Up Point")]
        public string PickUpPoint { get; set; }

        [Display(Name = "Mobile Office")]
        public string OffMobile { get; set; }

        [Display(Name = "Fax")]
        public string Fax { get; set; }

        [Display(Name = "VOIP")]
        public string VOIP { get; set; }
    }
}