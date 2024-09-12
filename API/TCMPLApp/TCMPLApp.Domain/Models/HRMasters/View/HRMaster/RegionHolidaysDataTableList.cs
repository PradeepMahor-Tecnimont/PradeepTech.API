using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{ 
    public class RegionHolidaysDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Holidays")]
        public DateTime? Holiday { get; set; }

        [Display(Name = "Region Code")]
        public decimal RegionCode { get; set; }

        [Display(Name = "Region Name")]
        public string RegionName { get; set; }

        [Display(Name = "YearMonth")]
        public string Yyyymm { get; set; }

        [Display(Name = "WeekDay")]
        public string Weekday { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }
    }
}
