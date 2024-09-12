using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvEmployeeDetails : DBProcMessageOutput
    {       
        public string PEmpName { get; set; }

        [Display(Name = "Parent")]
        public string PParent { get; set; }
        
        public string PParentName { get; set; }

        [Display(Name = "Assign")]
        public string PAssign { get; set; }
        
        public string PAssignName { get; set; }
        
        public string PActive { get; set; }
    }
}