using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaCreateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Required]
        [StringLength(60)]
        [Display(Name = "Area description")]
        public string AreaDesc { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Area categories")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Tag")]
        public string TagId { get; set; }

        [Required]
        [StringLength(4)]
        [Display(Name = "Area type")]
        public string AreaType { get; set; }

        [StringLength(20)]
        [Display(Name = "Area information")]
        public string AreaInfo { get; set; }

        [Required]
        [Display(Name = "Is Restricted")]
        public decimal? IsRestricted { get; set; }

        [Required]
        [Display(Name = "Is Active")]
        public decimal? IsActive { get; set; }
    }
}