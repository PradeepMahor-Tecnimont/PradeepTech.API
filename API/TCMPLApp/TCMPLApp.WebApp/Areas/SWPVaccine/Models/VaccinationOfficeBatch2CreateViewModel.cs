using System;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class VaccinationOfficeBatch2CreateViewModel
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
        [Display(Name = "Pending Jab Number")]
        public string JabNumber { get; set; }


        [Required]
        [Display(Name = "Preferred Jab Date")]
        public DateTime PreferredJabDate { get; set; }

        [Required]
        [Display(Name = "Registration for")]
        public string RegistrationFor { get; set; }

        public List<Batch2FamilyCreateViewModel> FamilyMember { get; set; }
    }


    public class Batch2FamilyCreateViewModel
    {
        [Display(Name = "Member Name (As per Aadhaar Card)")]
        [Required]
        public string FamilyMemberName { get; set; }


        [Display(Name = "Relation")]
        [Required]
        public string Relation { get; set; }


        [Display(Name = "Year of Birth")]
        [Required]
        [Range(1900,2003)]
        public int YearOfBirth { get; set; }



    }
}
