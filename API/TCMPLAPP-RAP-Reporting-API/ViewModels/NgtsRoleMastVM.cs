using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.RAPEntityModels
{
    public partial class NgtsRoleMastVM
    {
        [Key]
        public string Roleid { get; set; }

        public string Roles { get; set; }
        public string Roledesc { get; set; }
        public bool ElevRoles { get; set; }
        public bool DeptRoles { get; set; }
        public bool ProjRoles { get; set; }
    }
}