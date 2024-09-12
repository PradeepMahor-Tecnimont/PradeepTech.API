using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaOfficeMapDataTableExcel
    {
        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area Info")]
        public string AreaInfo { get; set; }

        [Display(Name = "Area Category")]
        public string AreaCatgCode { get; set; }
    }
}