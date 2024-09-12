using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class OSCMhrsDetailsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }
        public string OscmId { get; set; }
        public string OscdId { get; set; }

        [Display(Name = "OSC No")]
        public string Empno { get; set; }

        [Display(Name = "OSC Name")]
        public string EmpName { get; set; }

        [Display(Name = "Project No")]
        public string Projno { get; set; }
        
        [Display(Name = "Project Name")]
        public string ProjnoName { get; set; }
        
        [Display(Name = "Wp Code")]
        public string Wpcode { get; set; }
        
        [Display(Name = "Wp Name")]
        public string WpcodeName { get; set; }
        
        [Display(Name = "Activity")]
        public string Activity { get; set; }
        
        [Display(Name = "Activity Name")]
        public string ActivityName { get; set; }
        
        [Display(Name = "Hours")]
        public decimal Hours { get; set; }
        
        public string CanEditDelete { get; set; }

        public string IsEditable { get; set; }
    }
}
