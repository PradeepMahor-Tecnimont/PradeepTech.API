using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class ModuleUserRoleActionsDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Module")]
        public string Module { get; set; }

        [Display(Name = "Role")]
        public string Role { get; set; }

        [Display(Name = "Action")]
        public string Action { get; set; }
        public decimal? DeleteAllowed { get; set; }
    }
}
