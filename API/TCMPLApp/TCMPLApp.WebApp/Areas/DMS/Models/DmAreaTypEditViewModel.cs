using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DmAreaTypEditViewModel
    {
        [Required]
        [StringLength(4)]
        [Display(Name = "Id")]
        public string KeyId { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Short description")]
        public string ShortDesc { get; set; }

        [Required]
        [StringLength(150)]
        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "Is active")]
        public decimal? IsActive { get; set; }
    }
}