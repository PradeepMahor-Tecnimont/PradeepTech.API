using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace TCMPLApp.WebApp.Models
{
    //public class EmployeeSecondaryDetailsEditViewModel
    public class EmployeeSecondaryDetailsViewModel

    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Blood Group")]
        public string BloodGroup { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Religion")]
        public string Religion { get; set; }

        [Required]
        [StringLength(15)]
        [Display(Name = "Marital Status")]
        public string MaritalStatus { get; set; }

        #region Residential Address (Current Mumbai Address)

        [Required]
        [StringLength(200)]
        [Display(Name = "Address")]
        public string RAdd1 { get; set; }

        [StringLength(50)]
        [Display(Name = "State")]
        public string RState { get; set; }

        [StringLength(100)]
        [Display(Name = "House No")]
        public string RHouseNo { get; set; }

        [StringLength(100)]
        [Display(Name = "City")]
        public string RCity { get; set; }

        [StringLength(100)]
        [Display(Name = "District")]
        public string RDistrict { get; set; }

        [StringLength(100)]
        [Display(Name = "Country")]
        public string RCountry { get; set; }

        [Required]
        [StringLength(6)]
        [Display(Name = "Pincode")]
        public string RPincode { get; set; }

        [StringLength(50)]
        [Display(Name = "Phone Res")]
        [DefaultValue("NA")]
        public string PhoneRes { get; set; }

        [StringLength(50)]
        [Display(Name = "Mobile Res")]
        [DefaultValue("NA")]
        public string MobileRes { get; set; }

        #endregion Residential Address (Current Mumbai Address)

        #region Name / Address of Relative / Friend (To be contacted in case of EMERGENCY)

        [StringLength(60)]
        [Display(Name = "Ref Person Name")]
        public string RefPersonName { get; set; }

        [StringLength(50)]
        [Display(Name = "Ref Person Phone")]
        public string RefPersonPhone { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Address")]
        public string FAdd1 { get; set; }

        [StringLength(100)]
        [Display(Name = "House No")]
        public string FHouseNo { get; set; }

        [StringLength(100)]
        [Display(Name = "City")]
        public string FCity { get; set; }

        [StringLength(100)]
        [Display(Name = "District")]
        public string FDistrict { get; set; }

        [StringLength(100)]
        [Display(Name = "Country")]
        public string FCountry { get; set; }

        [StringLength(50)]
        [Display(Name = "State")]
        public string FState { get; set; }

        [Required]
        [StringLength(6)]
        [Display(Name = "Pincode")]
        public string FPincode { get; set; }

        #endregion Name / Address of Relative / Friend (To be contacted in case of EMERGENCY)

        #region Additional Information

        [Required]
        [StringLength(5)]
        [Display(Name = "Company Bus")]
        public string CoBus { get; set; }

        [Display(Name = "Company Bus")]
        public string CoBusText { get; set; }

        [Required]
        [StringLength(60)]
        [Display(Name = "Pick Up Point")]
        public string PickUpPoint { get; set; }

        [StringLength(50)]
        [Display(Name = "Mobile Office")]
        [DefaultValue("NA")]
        public string MobileOff { get; set; }

        [StringLength(50)]
        [Display(Name = "Fax")]
        [DefaultValue("NA")]
        public string Fax { get; set; }

        [StringLength(50)]
        [Display(Name = "VOIP")]
        [DefaultValue("NA")]
        public string Voip { get; set; }

        #endregion Additional Information
    }
}