using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.WebApp.Models
{
    public class BGDetailViewModel
    {
        [Display(Name = "Reference no")]
        public string Refnum { get; set; }
        public BGMasterDetail BGMaster { get; set; }
        public BGAmendmentDetail BGAmendment { get; set; }
    }
}