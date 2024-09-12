using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using System.Numerics;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGMasterDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal? RowNumber { get; set; }

        [Display(Name = "Reference no")]
        public string Refnum { get; set; }

        [Display(Name = "BG no")]
        public string Bgnum { get; set; }

        [Display(Name = "BG date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgdate { get; set; }
                
        public string Compid { get; set; }

        [Display(Name = "Company")]
        public string Companyname { get; set; }

        [Display(Name = "BG type")]
        public string Bgtype { get; set; }

        [Display(Name = "PO No")]
        public string Ponum { get; set; }

        [Display(Name = "Project no")]
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
        public short? Released { get; set; }

        [Display(Name = "Release date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Reldt { get; set; }

        [Display(Name = "Remarks")]        
        public string Reldetails { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }


    }
}