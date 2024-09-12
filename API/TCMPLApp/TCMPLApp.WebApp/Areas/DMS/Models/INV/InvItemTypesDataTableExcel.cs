using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemTypesDataTableExcel
    {
        [Display(Name = "Item type keyId")]
        public string ItemTypeKeyId { get; set; }

        [Display(Name = "Item type code")]
        public string ItemTypeCode { get; set; }

        [Display(Name = "Category code")]
        public string CategoryCode { get; set; }

        [Display(Name = "Category description")]
        public string CategoryDesc { get; set; }

        [Display(Name = "Item assignment type")]
        public string ItemAssignmentType { get; set; }

        [Display(Name = "Item assignment description")]
        public string ItemAssignmentDesc { get; set; }

        [Display(Name = "Item type description")]
        public string ItemTypeDesc { get; set; }

        [Display(Name = "Is active")]
        public string IsActiveText { get; set; }

        [Display(Name = "Modified on")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}