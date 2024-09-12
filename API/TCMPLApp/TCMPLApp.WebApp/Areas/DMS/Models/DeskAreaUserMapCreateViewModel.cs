using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaUserMapCreateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Office")]
        public string OfficeCode { get; set; }

        [Required]
        [Display(Name = "From date")]
        public DateTime? FromDate { get; set; } = DateTime.Now;

        [Display(Name = "Location (Office Location)")]
        public string BaseOffice { get; set; }
    }
}