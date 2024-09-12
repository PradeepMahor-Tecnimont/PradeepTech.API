using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.ViewModels
{
    public partial class ProjactMastVM
    {
        [Key]
        public string Projno { get; set; }

        [Key]
        public string Costcode { get; set; }

        public string Activity { get; set; }
        public string ActName { get; set; }
        public long? Budghrs { get; set; }
        public int? Noofdocs { get; set; }
    }
}