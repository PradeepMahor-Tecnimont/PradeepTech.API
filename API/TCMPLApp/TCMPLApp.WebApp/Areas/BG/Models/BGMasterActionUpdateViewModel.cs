using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.WebApp.Models
{
    public class BGMasterActionUpdateViewModel
    {
        [Required]
        [Display(Name = "Reference no")]
        public string Refnum { get; set; }

        [Display(Name = "Amendment no")]
        public string Amendmentnum { get; set; }

        [Display(Name = "Status")]
        public string StatusTypeId { get; set; }

        [Display(Name = "Status")]
        public string StatusTypeDesc { get; set; }

        public BGMasterDetail bgMasterDetail { get; set; }

        public BGAmendmentDetail bgAmendmentDetail { get; set; }

    }
}