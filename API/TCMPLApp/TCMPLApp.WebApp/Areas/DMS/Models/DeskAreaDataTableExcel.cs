using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaDataTableExcel
    {
        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area categories code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area categories description")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "Area info")]
        public string AreaInfo { get; set; }
    }
}