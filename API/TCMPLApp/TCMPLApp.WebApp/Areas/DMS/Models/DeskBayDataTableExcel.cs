using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBayDataTableExcel
    {
        [Display(Name = "Bay Id")]
        public string BayId { get; set; }

        [Display(Name = "Bay description")]
        public string BayDesc { get; set; }
    }
}