using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.RAPEntityModels
{
    public partial class RapUserProjectRolesVM
    {
        [Key]
        public string Keyid { get; set; }

        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string Project { get; set; }
        public string ProjectName { get; set; }
        public string Roleid { get; set; }
        public string Roles { get; set; }
        public string Roledesc { get; set; }
    }
}