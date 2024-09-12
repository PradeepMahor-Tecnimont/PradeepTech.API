using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemTypesUpdateViewModel
    {
        [Required]
        [Display(Name = "Item type id")]
        public string ItemTypeKeyId { get; set; }

        [Required]
        [Display(Name = "Item type  code")]
        public string ItemTypeCode { get; set; }

        [Required]
        [Display(Name = "Category Code")]
        public string CategoryCode { get; set; }

        [Required]
        [Display(Name = "Item assignment type")]
        public string ItemAssignmentType { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Item type description")]
        public string ItemTypeDescription { get; set; }

        [Required]
        [Display(Name = "Print Order")]
        public decimal? PrintOrder { get; set; }

        [Required]
        [Display(Name = "Action For")]
        public string ActionId { get; set; }
    }
}