using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BGAmendmentCreateViewModel
    {
        [Display(Name = "Reference no")]
        public string Refnum { get; set; }

        [Display(Name = "Amendment no")]
        public string Amendmentnum { get; set; }

        [Display(Name = "Currency")]
        public string Currid { get; set; }        

        [Display(Name = "BG amount")]
        [RegularExpression(@"^\d+(\.\d+)*$")]
        public string Bgamt { get; set; }

        [Display(Name = "BG received date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Bgrecdt { get; set; }

        [Display(Name = "BG accepted")]
        public string Bgaccept { get; set; }

        public string Bgacceptname { get; set; }

        [Display(Name = "BG accepted remarks")]
        public string Bgacceptrmk { get; set; }

        [Display(Name = "BG document name")]
        public string Docurl { get; set; }

        [Display(Name = "Conversion rate")]
        public string Convrate { get; set; }

    }
}