using System;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscDetailDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "OSCM id")]
        public string OscmId { get; set; }

        [Display(Name = "OSCD id")]
        public string OscdId { get; set; }

        [Display(Name = "Cost Code")]
        public string Costcode { get; set; }

        [Display(Name = "Name")]
        public string CostcodeDesc { get; set; }

        [Display(Name = "Original est hours")]
        public decimal? OrigEstHoursTotal { get; set; }

        [Display(Name = "Current est hours")]
        public decimal? CurEstHoursTotal { get; set; }

        [Display(Name = "Is deletable")]
        public decimal? IsDeletable { get; set; }

    }
}