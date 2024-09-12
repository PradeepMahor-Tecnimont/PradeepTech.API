using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class RolesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Role Id")]
        public string RoleId { get; set; }

        [Display(Name = "Role Name")]
        public string RoleName { get; set; }

        [Display(Name = "Role Description")]
        public string RoleDesc { get; set; }

        [Display(Name = "Role IsActive")]
        public string RoleIsActive { get; set; }

        public string RoleFlag { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}