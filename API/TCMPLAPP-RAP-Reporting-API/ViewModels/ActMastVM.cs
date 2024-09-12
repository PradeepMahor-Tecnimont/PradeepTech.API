using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.ViewModels
{
    public partial class ActMastVM
    {
        [Key]
        public string Costcode { get; set; }        //ActMast

        //[NonFilterable]
        public string CostcodeName { get; set; }    //CostMast

        [Key]
        public string Activity { get; set; }        //ActMast

        //[NonFilterable]
        public string Name { get; set; }            //ActMast

        public string Tlpcode { get; set; }         //ActMast

        //[NonFilterable]
        public string TlpcodeName { get; set; }     //TlpMast

        //[NonFilterable]
        public string ActivityType { get; set; }    //ActMast

        //[NonFilterable]
        public bool? Active { get; set; }           //ActMast

        //public virtual Costmast CostcodeNavigation { get; set; }
        //public virtual TlpMast TlpMast { get; set; }
    }
}