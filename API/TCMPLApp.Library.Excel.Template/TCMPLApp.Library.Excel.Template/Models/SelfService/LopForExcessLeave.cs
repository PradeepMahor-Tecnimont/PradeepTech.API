using System;

namespace TCMPLApp.Library.Excel.Template.Models
{
    public class LopForExcessLeave
    {
        public string Empno { get; set; } 
        public DateTime? LopYYYYMM { get; set; }
        public decimal PL { get; set; }
        public decimal CL { get; set; }
        public decimal CO { get; set; }    
    }
}
