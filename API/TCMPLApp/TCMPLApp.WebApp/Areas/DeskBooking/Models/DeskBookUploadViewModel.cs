using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookUploadViewModel
    {
        [Required]
        [Display(Name = "Desk Bookings")]
        public string DeskId { get; set; }
    }
    public class ReturnDeskJson
    {
        public List<ReturnDesk> ReturnDeskList { get; set; }
    }

    public class ReturnDesk
    {
        public string Deskid { get; set; }
        public string Empno { get; set; }
        public string Shift { get; set; }
    }
}
