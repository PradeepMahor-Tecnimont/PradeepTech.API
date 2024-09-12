using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemAsgmtTypesDataTableExcel
    {
        [Display(Name = "Assignment type code")]
        public string AsgmtCode { get; set; }

        [Display(Name = "Assignment type description")]
        public string AsgmtDesc { get; set; }

        [Display(Name = "Is active")]
        public string IsActiveText { get; set; }

        [Display(Name = "Modified on")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}