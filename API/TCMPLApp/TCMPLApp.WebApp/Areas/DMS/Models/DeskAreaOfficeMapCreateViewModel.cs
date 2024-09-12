using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaOfficeMapCreateViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Office Code")]
        public string OfficeCode { get; set; }
    }
}