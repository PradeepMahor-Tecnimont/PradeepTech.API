using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGAmendmentDetail : DBProcMessageOutput
    {
        //[Display(Name = "Reference no")]
        //public string Refnum { get; set; }

        [Display(Name = "Amendment no")]
        public string PAmendmentnum { get; set; }

        public string PCurrid { get; set; }

        [Display(Name = "Currency")]
        public string PCurrdesc { get; set; }

        [Display(Name = "BG amount")]
        public string PBgamt { get; set; }

        [Display(Name = "BG received date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PBgrecdt { get; set; }

        [Display(Name = "BG accepted")]
        public string PBgaccept { get; set; }

        public string PBgacceptname { get; set; }

        [Display(Name = "BG accepted remarks")]
        public string PBgacceptrmk { get; set; }

        [Display(Name = "BG document")]
        public string PDocurl { get; set; }

        [Display(Name = "Conversion rate")]
        public string PConvrate { get; set; }
        
    }
}