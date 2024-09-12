using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class TMAGroupsUpdateViewModel
    {
        [Required]
        [StringLength(10)]
        [Display(Name = "TMA Group")]
        public string TmaGroup { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Sub Group")]
        public string SubGroup { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "TMA Group description")]
        public string TmaGroupDesc { get; set; }
    }
}
