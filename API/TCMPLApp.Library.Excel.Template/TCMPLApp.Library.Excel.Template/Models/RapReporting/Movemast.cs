using System;

namespace TCMPLApp.Library.Excel.Template.Models
{
    public class Movemast
    {        
        public string Costcode { get; set; }
        public string Yymm { get; set; }        
        public decimal Movetotcm { get; set; }
        public decimal Movetosite { get; set; }
        public decimal Movetoothers { get; set; }
        public decimal ExtSubcontract { get; set; }
        public decimal FutRecruit { get; set; }
        public decimal IntDept { get; set; }
        public decimal HrsSubcont { get; set; }
    }
}
