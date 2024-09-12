using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OscSesUpdateViewModel
    {
        [Required]
        [Display(Name = "Oscs id")]
        public string OscsId { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "OSCM")]
        public string OscmId { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "SES no")]
        public string SesNo { get; set; }

        [Required]
        [Display(Name = "SES date")]
        public DateTime? SesDate { get; set; }

        [Required]
        [Display(Name = "SES amount")]
        public decimal? SesAmount { get; set; }
    }
}