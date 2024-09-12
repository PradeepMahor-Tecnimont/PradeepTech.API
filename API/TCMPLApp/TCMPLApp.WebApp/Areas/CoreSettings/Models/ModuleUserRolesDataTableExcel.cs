using System;

namespace TCMPLApp.WebApp.Models
{
    public class ModuleUserRolesDataTableExcel
    {
        public string Module { get; set; }
        public string ModuleId { get; set; }
        public string Role { get; set; }
        public string RoleId { get; set; }
        public string Employee { get; set; }
        public string Empno { get; set; }
        public string PersonId { get; set; }
        public string ModuleRoleKeyId { get; set; }
        public string Status { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime? ModifiedOn { get; set; }
    }
}
