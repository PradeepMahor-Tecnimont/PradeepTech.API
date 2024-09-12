using DocumentFormat.OpenXml.Wordprocessing;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{    
    public class OscActualHoursBookedDataTableExcel
    {        
        public string Yymm { get; set; }
        public string Costcode { get; set; }        
        public decimal Hours { get; set; }

        [Display(Name = "OT hours")]
        public decimal Othours { get; set; }

        [Display(Name = "Total hours")]
        public decimal TotalHours { get; set; }
    }
    
}