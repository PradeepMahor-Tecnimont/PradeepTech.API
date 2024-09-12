using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleUserRoleCostCodeDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee No")]
        public string EmpNo { get; set; }
        
        [Display(Name = "Employee")]
        public string Employee { get; set; }
        public string ModuleVal { get; set; }

        [Display(Name = "Module")]
        public string ModuleText { get; set; }
        public string RoleVal { get; set; }
        
        [Display(Name = "Role")]
        public string RoleText { get; set; }
        public string ParentVal { get; set; }
        
        [Display(Name = "Parent")]
        public string ParentText { get; set; }
        public decimal? DeleteAllowed { get; set; }
    }
}
