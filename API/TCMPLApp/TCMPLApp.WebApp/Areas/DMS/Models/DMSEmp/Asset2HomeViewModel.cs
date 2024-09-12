using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class Asset2HomeViewModel
    {
        [Display(Name = "Take Home")]
        public bool? isTaking2Home { get; set; }
    }
}