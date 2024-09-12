using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGMasterDetail : DBProcMessageOutput
    {
        //[Display(Name = "Reference no")]
        //public string Refnum { get; set; }

        [Display(Name = "BG no")]
        public string PBgnum { get; set; }

        [Display(Name = "BG date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PBgdate { get; set; }
                
        public string PCompid { get; set; }

        [Display(Name = "Company")]
        public string PCompdesc { get; set; }

        [Display(Name = "BG type")]
        public string PBgtype { get; set; }

        [Display(Name = "PO No")]
        public string PPonum { get; set; }
                
        public string PProjnum { get; set; }

        [Display(Name = "Project")]
        public string PProjname { get; set; }

        public string PIssuebyid { get; set; }

        [Display(Name = "Issued by")]
        public string PIssuebyname { get; set; }

        public string PIssuetoid { get; set; }

        [Display(Name = "Issued to")]
        public string PIssuetoname { get; set; }

        [Display(Name = "BG validity date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PBgvaldt { get; set; }

        [Display(Name = "BG claim date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PBgclmdt { get; set; }

        public string PBankid { get; set; }

        [Display(Name = "Issuer bank")]
        public string PBankname { get; set; }

        [Display(Name = "Remarks")]
        public string PRemarks { get; set; }

        [Display(Name = "Released")]
        public decimal? PReleased { get; set; }

        [Display(Name = "Released")]
        public string PReleasedDesc { get; set; }


        [Display(Name = "Release date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PReldt { get; set; }

        [Display(Name = "Remarks")]        
        public string PReldetails { get; set; }
    }
}