using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class BookedDeskDataTableList
    {
        
        [Display(Name = "Desk Id")]
        public string Deskid { get; set; }

        [Display(Name = "Area Catg Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Desk Area Type")]
        public string DeskAreaType { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "IsBooked")]
        public string IsBooked { get; set; }
    }
}
