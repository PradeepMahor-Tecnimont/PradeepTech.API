using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemCategoryDataTableExcel
    {
        [Display(Name = "Category code")]
        public string CategoryCode { get; set; }

        [Display(Name = "Category description")]
        public string CategoryDesc { get; set; }

        [Display(Name = "Is active")]
        public string IsActiveText { get; set; }

        [Display(Name = "Modified on")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}