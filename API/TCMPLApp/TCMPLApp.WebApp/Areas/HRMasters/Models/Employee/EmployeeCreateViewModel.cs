using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeCreateViewMainModel
    {
        [Required]
        [StringLength(5)]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        //[Required]
        //[StringLength(35)]
        //[Display(Name = "Employee name")]
        //public string Name { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Abbrivation")]
        public string Abbr { get; set; }

        [Required]
        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [EmailAddress]
        [StringLength(100)]
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Required]
        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }

        [Required]
        [Display(Name = "Designation")]
        public string Desgcode { get; set; }

        [Required]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of brith")]
        public DateTime? DoB { get; set; }

        [Required]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of joining")]
        public DateTime? DoJ { get; set; }

        [Required]
        [Display(Name = "Office")]
        public string Office { get; set; }

        [Required]
        [Display(Name = "Gender")]
        public string Sex { get; set; }

        [Required]
        [Display(Name = "Category")]
        public string Category { get; set; }

        [Required]
        [Display(Name = "Marital status")]
        public string Married { get; set; }

        [Required]
        [StringLength(20)]
        [RegularExpression("^[A-Z0-9]*$", ErrorMessage = "Only Capital Alphabets and Numbers allowed.")]
        [Display(Name = "Meta id")]
        public string Metaid { get; set; }

        [Required]
        [StringLength(8)]
        [Display(Name = "Group person id")]
        public string Personid { get; set; }

        [Required]
        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string Company { get; set; }
                
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of confirmation")]
        public DateTime? DoC { get; set; }

        [Required]
        [Display(Name = "First name")]
        public string Firstname { get; set; }

        
        [Display(Name = "Middle name")]
        public string Middlename { get; set; }

        [Required]
        [Display(Name = "Last name")]
        public string Lastname { get; set; }
    }
}
