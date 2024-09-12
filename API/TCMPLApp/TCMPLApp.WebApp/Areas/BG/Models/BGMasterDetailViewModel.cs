using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGMasterDetailViewModel
    {
        [Display(Name = "Reference no")]
        public string Refnum { get; set; }

        [Display(Name = "BG no")]
        public string Bgnum { get; set; }

        [Display(Name = "BG date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgdate { get; set; }
                
        public string Compid { get; set; }

        [Display(Name = "Company")]
        public string Compdesc { get; set; }

        [Display(Name = "BG type")]
        public string Bgtype { get; set; }

        [Display(Name = "PO No")]
        public string Ponum { get; set; }
                
        public string Projnum { get; set; }

        [Display(Name = "Project")]
        public string Projname { get; set; }

        public string Issuebyid { get; set; }

        [Display(Name = "Issued by")]
        public string Issuebyname { get; set; }

        public string Issuetoid { get; set; }

        [Display(Name = "Issued to")]
        public string Issuetoname { get; set; }

        [Display(Name = "BG validity date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgvaldt { get; set; }

        [Display(Name = "BG claim date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgclmdt { get; set; }

        public string Bankid { get; set; }

        [Display(Name = "Issuer bank")]
        public string Bankname { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Released")]
        public decimal? Released { get; set; }

        [Display(Name = "Release date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Reldt { get; set; }

        [Display(Name = "Remarks")]        
        public string Reldetails { get; set; }
    }
}