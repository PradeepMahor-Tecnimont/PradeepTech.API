using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaEmpAreaTypeMapUpdateViewModel
    {
        [Required]
        public string KeyId { get; set; }

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
        [Display(Name = "Desk area type")]
        public string DeskAreaType { get; set; }
    }
}