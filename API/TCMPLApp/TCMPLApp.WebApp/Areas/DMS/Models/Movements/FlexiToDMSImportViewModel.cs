using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class FlexiToDMSImportViewModel
    {
        [Required]
        [Display(Name = "Deskid")]
        public string Deskid { get; set; }
    }

    public class ReturnJsonsFlexiToDMS
    {
        public List<ReturnDeskid> ReturnDeskList { get; set; }
    }

    public class ReturnDeskid
    {
        public string Deskid { get; set; }
    }
}