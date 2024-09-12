using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaCategoriesDataTableExcel
    {
        [Display(Name = "Area categories code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area description")]
        public string AreaDescription { get; set; }
    }
}