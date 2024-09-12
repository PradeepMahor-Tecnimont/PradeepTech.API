using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleUserRolesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Module")]
        public string Module { get; set; }

        public string ModuleId { get; set; }

        [Display(Name = "Role")]
        public string Role { get; set; }

        public string RoleId { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        public string Empno { get; set; }

        [Display(Name = "Person Id")]
        public string PersonId { get; set; }

        [Display(Name = "Module Role Key Id")]
        public string ModuleRoleKeyId { get; set; }

        [Display(Name = "Transaction Type")]
        public string Status { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on")]
        public DateTime? ModifiedOn { get; set; }
    }
}