using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemAsgmtTypesUpdateViewModel
    {
        [Required]
        [StringLength(2)]
        [Display(Name = "Item assignment type Code")]
        public string ItemAssignmentTypeCode { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Item assignment type description")]
        public string ItemAssignmentTypeDescription { get; set; }
    }
}