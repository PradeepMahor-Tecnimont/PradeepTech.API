using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class TagObjectMapCreateViewModel
    {
        [Required]
        [Display(Name = "Tag Id")]
        public string TagId { get; set; }

        [Required]
        [Display(Name = "Object Id")]
        public string ObjId { get; set; }

        [Required]
        [Display(Name = "Object Type")]
        public string ObjTypeId { get; set; }
    }
}