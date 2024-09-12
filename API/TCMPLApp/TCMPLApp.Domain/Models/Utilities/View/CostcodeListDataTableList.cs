using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Utilities
{
    public class CostcodeListDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal? RowNumber { get; set; }        

        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Abbreviation")]
        public string Abbr { get; set; }

        [Display(Name = "SAP cost code")]
        public string Sapcc { get; set; }

        [Display(Name = "HoD Name")]
        public string Hod { get; set; }        

             
    }
}
