using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class OSCMhrsDetailsXLDataTableList
    {
        public string Empno { get; set; }                
        public string EmpName { get; set; }        
        public string Assign { get; set; }
        public string AssignName { get; set; }        
        public string Projno { get; set; }
        public string ProjnoName { get; set; }        
        public string Wpcode { get; set; }
        public string WpcodeName { get; set; }        
        public string Activity { get; set; }
        public string ActivityName { get; set; }        
        public decimal Hours { get; set; }

        public string EmpnoWithName { get; set; }
        public string AssignWithName { get; set; }
        public string ProjnoWithName { get; set; }
        public string WpcodeWithName { get; set; }
        public string ActivityWithName { get; set; }
    }
}
