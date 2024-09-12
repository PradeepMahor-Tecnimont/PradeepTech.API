using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class SegmentsUpdateViewModel
    {
        [Required]
        [StringLength(10)]
        [Display(Name = "Segment code")]
        public string Code { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Segment description")]
        public string Description { get; set; }
    }
}
