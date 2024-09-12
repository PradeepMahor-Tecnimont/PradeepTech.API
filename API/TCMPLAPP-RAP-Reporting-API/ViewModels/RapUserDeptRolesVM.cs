using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.RAPEntityModels
{
    public partial class RapUserDeptRolesVM
    {
        [Key]
        public string Keyid { get; set; }

        public string Empno { get; set; }
        public string EmpName { get; set; }
        public string CostCode { get; set; }
        public string CostCodeName { get; set; }
        public string Roleid { get; set; }
        public string Roles { get; set; }
        public string Roledesc { get; set; }
    }
}