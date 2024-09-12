using Microsoft.AspNetCore.Http;
using System;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.WebApp.Areas.ERS
{
    public class VacancyReferViewModel
    {        
        [MaxLength(8)]
        [Required]
        public string VacancyJobKeyId { get; set; }

        [Display(Name = "Candidate PAN")]
        [MaxLength(10)]
        [Required]
        public string Pan { get; set; }

        [Display(Name = "Candidate name")]
        [MaxLength(100)]
        [Required]
        public string CandidateName { get; set; }

        [Display(Name = "Candidate email")]        
        [MaxLength(100)]
        [RegularExpression("^[a-zA-Z0-9_\\.-]+@([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$", ErrorMessage = "Invalid E-mail id")]
        [Required]
        public string CandidateEmail { get; set; }

        [Display(Name = "Candidate mobile")]             
        [MaxLength(10)]        
        //[RegularExpression(@"^\d{1,3}?[-. ]?([0-9]{10})$", ErrorMessage = "Mobile number is not valid")]
        [RegularExpression(@"^([1-9][0-9]{9})$", ErrorMessage = "Invalid Mobile Number.")]
        public string CandidateMobile { get; set; }

        [Display(Name = "File name")]
        [MaxLength(100)]        
        public string CandidateCvDispName { get; set; }

        [Display(Name = "Server file name")]
        [MaxLength(60)]        
        public string CandidateCvOsName { get; set; }

        [Required]
        public IFormFile file { get; set; }
    }
}
