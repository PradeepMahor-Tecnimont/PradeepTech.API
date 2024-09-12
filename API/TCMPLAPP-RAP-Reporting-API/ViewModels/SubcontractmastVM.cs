using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.RAPEntityModels
{
    public partial class SubcontractmastVM
    {
        [Key]
        public string Subcontract { get; set; }

        public string Description { get; set; }
    }
}