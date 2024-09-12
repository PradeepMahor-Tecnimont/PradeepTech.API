using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGMasterAdd : DBProcMessageOutput
    {        
        [Display(Name = "BG no")]
        [MaxLength(25)]
        public string PBgnum { get; set; }

        [Display(Name = "BG Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PBgdate { get; set; }

        [Display(Name = "Compnay")]
        [MaxLength(4)]
        public string PCompid { get; set; }

        [Display(Name = "BG type")]
        [MaxLength(11)]
        public string PBgtype { get; set; }

        [Display(Name = "PO No")]
        [MaxLength(35)]
        public string PPonum { get; set; }

        [Display(Name = "Project")]
        [MaxLength(5)]
        public string PProjnum { get; set; }

        [Display(Name = "Issued by")]
        [MaxLength(6)]
        public string PIssuebyid { get; set; }

        [Display(Name = "Issued to")]
        [MaxLength(5)]
        public string PIssuetoid { get; set; }

        [Display(Name = "Validity date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PBgvaldt { get; set; }

        [Display(Name = "Claim date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PBgclmdt { get; set; }

        [Display(Name = "Issuer bank")]
        [MaxLength(8)]
        public string PBankid { get; set; }

        [Display(Name = "Remarks")]
        [MaxLength(250)]
        public string PRemarks { get; set; }

        [Display(Name = "Released")]
        public decimal? PReleased { get; set; }

        [Display(Name = "Release date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PReldt { get; set; }

        [Display(Name = "Remarks")]
        [MaxLength(250)]
        public string PReldetails { get; set; }

    }
}