using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGMasterUpdateViewModel
    {
        [Required]
        [Display(Name = "Ref no")]
        public string Refnum { get; set; }

        [Required]
        [Display(Name = "BG no")]        
        public string Bgnum { get; set; }

        [Required]
        [Display(Name = "BG date")]        
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgdate { get; set; }

        [Required]
        [Display(Name = "Company")]
        public string Compid { get; set; }

        [Required]
        [Display(Name = "BG type")]
        public string Bgtype { get; set; }

        [Required]
        [Display(Name = "PO No")]
        public string Ponum { get; set; }

        [Required]
        [Display(Name = "Project")]
        public string Projnum { get; set; }

        [Required]
        [Display(Name = "Issued by")]
        public string Issuebyid { get; set; }

        [Required]
        [Display(Name = "Issued to")]
        public string Issuetoid { get; set; }

        [Required]
        [Display(Name = "BG validity date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgvaldt { get; set; }

        [Display(Name = "BG claim date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgclmdt { get; set; }

        [Required]
        [Display(Name = "Issuer bank")]
        public string Bankid { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Released")]
        public decimal? Released { get; set; }

        [Display(Name = "Release date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Reldt { get; set; }

        [Display(Name = "Release remarks")]        
        public string Reldetails { get; set; }

    }
}