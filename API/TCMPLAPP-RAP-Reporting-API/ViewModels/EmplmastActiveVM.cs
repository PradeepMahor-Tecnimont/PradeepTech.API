using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.RAPEntityModels
{
    public partial class EmplmastActiveVM
    {
        [Key]
        public string Empno { get; set; }

        public string Name { get; set; }
    }
}