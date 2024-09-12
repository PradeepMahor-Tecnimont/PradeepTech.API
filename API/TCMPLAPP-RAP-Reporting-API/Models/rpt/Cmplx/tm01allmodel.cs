using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models.rpt.Cmplx
{
    public partial class tm01allmodel
    {
        [Key]
        public string Projno { get; set; }

        public string Tcmno { get; set; }
        public string Name { get; set; }
        public string Sdate { get; set; }
        public string Edate { get; set; }
        public double? Mnths { get; set; }
        public List<CostDetails> Details { get; set; }
    }

    public partial class CostDetails
    {
        [Key]
        public string Costcode { get; set; }

        public string Name { get; set; }
        public double? Revised { get; set; }
        public double? Curryear { get; set; }
        public double? Opening { get; set; }
        public double? A { get; set; }
        public double? B { get; set; }
        public double? C { get; set; }
        public double? D { get; set; }
        public double? E { get; set; }
        public double? F { get; set; }
        public double? G { get; set; }
        public double? H { get; set; }
        public double? I { get; set; }
        public double? J { get; set; }
        public double? K { get; set; }
        public double? L { get; set; }
        public double? M { get; set; }
        public double? N { get; set; }
        public double? O { get; set; }
        public double? P { get; set; }
        public double? Q { get; set; }
        public double? R { get; set; }
        public double? S { get; set; }
        public double? T { get; set; }
        public double? U { get; set; }
        public double? V { get; set; }
        public double? W { get; set; }
        public double? X { get; set; }
        public double? Y { get; set; }
        public double? Z { get; set; }
        public double? AA { get; set; }
        public double? AB { get; set; }
        public double? AC { get; set; }
        public double? AD { get; set; }
        public double? AE { get; set; }
        public double? AF { get; set; }
        public double? AG { get; set; }
        public double? AH { get; set; }
        public double? AI { get; set; }
        public double? AJ { get; set; }
        public double? AK { get; set; }
        public double? AL { get; set; }
        public double? AM { get; set; }
        public double? AN { get; set; }
        public double? AO { get; set; }
        public double? AP { get; set; }
        public double? AQ { get; set; }
        public double? AR { get; set; }
        public double? AS { get; set; }
        public double? AT { get; set; }
        public double? AU { get; set; }
        public double? AV { get; set; }
    }
}