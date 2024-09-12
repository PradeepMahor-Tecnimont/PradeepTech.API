using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaProjectMapCreateViewModel
    {
        [Required]
        [StringLength(3)]
        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Category Description")]
        public string AreaCatgDesc { get; set; }

        [Required]
        [StringLength(5)]
        [Display(Name = "Project")]
        public string ProjectNo { get; set; }
    }
}