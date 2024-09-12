using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models.Mast
{
    public partial class UpdateCostMast
    {
        [Key]
        public string Costcode { get; set; }

        public int? Activity { get; set; }
        public int? GroupChart { get; set; }
        public string Phase { get; set; }
        public string Tm01Grp { get; set; }
        public string TmaGrp { get; set; }
        public string Po { get; set; }
    }
}