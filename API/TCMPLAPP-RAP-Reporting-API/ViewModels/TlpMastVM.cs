using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.RAPEntityModels
{
    public partial class TlpMastVM
    {
        //public TlpMast()
        //{
        //    ActMast = new HashSet<ActMast>();
        //}
        [Key]
        public string Costcode { get; set; }

        public string CostcodeName { get; set; } // CostMast

        [Key]
        public string Tlpcode { get; set; }

        public string Name { get; set; }

        //public virtual ICollection<ActMast> ActMast { get; set; }
    }
}