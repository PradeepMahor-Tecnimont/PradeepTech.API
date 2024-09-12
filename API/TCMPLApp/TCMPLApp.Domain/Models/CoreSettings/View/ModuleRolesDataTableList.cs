using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;


namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleRolesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Module Id")]
        public string ModuleId { get; set; }

        [Display(Name = "Module Name")]
        public string ModuleName { get; set; }

        [Display(Name = "Module Long Description")]
        public string ModuleLongDesc { get; set; }

        [Display(Name = "Role Id")]
        public string RoleId { get; set; }

        [Display(Name = "Role Name")]
        public string RoleName { get; set; }

        [Display(Name = "Role Description")]
        public string RoleDesc { get; set; }
        
        [Display(Name = "Module Role Key Id")]
        public string ModuleRoleKeyId { get; set; }
        public decimal? DeleteAllowed { get; set; }


    }
}
