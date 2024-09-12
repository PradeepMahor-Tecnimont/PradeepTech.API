using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class BulkHoDMngrChangeViewModel
    {   
        [Required]
        [Display(Name = "Existing HoD / Manager")]
        public string HodMngrOld { get; set; }

        [Required]
        [Display(Name = "New HoD / Manager")]
        public string HodMngrNew { get; set; }

        [Required]
        [Display(Name = "Change type")]
        public string Changetype { get; set; }
    }

}