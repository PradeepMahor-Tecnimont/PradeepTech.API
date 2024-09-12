
namespace TCMPLApp.Domain.Models.JOB
{
    public class JobmasterBudgetApi
    {
        public string Projno { get; set; }
        public string Phase { get; set; }
        public string Yymm { get; set; }
        public string Costcode { get; set; }
        public string Costcodename { get; set; } 
        public decimal? InitialBudget { get; set; }
        public decimal? NewBudget { get; set; }
    }
}