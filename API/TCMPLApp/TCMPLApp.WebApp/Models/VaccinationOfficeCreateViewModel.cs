using System;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class VaccinationOfficeCreateViewModel1
    {


        [Display (Name ="Vaccine Type")]
        public string SelfVaccineType { get; set; }


        [Display (Name ="First Jab Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? SelfJab1Date { get; set; }
        
        [Display (Name ="Second Jab Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? SelfJab2Date { get; set; }

        [Required]
        [Display(Name ="Pending Jab Number")]
        public string JabNumber { get; set; }


        [Required]
        [Display (Name ="Registered on COWIN app")]
        public bool? CowinRegistered { get; set; }

        [Required]
        [Display(Name ="Mobile")]
        [RegularExpression(@"^[1-9]([0-9]{9})$", ErrorMessage = "Invalid Mobile Number (eg. 9988776655)")]
        public string CowinRegisteredMobile { get; set; }


        [Required]
        [Display(Name = "Mode of Transport")]
        public bool? CompanyBus { get; set; }


        [Display(Name = "Company Bus Route")]
        [RequiredIf("CompanyBus", true,"Company Bus Route is required.")]
        public string CompanyBusRoute { get; set; }


        [Required]
        [Display(Name = "I am available for Vaccination")]
        public bool? IsAttendingForJab { get; set; }


        [RequiredIf("IsAttendingForJab", false,"Reason for not attending vaccination is required")]
        [Display(Name ="Reason for not attending vaccination")]
        public string ReasonForNotAttendingJab { get; set; }
    }
}
