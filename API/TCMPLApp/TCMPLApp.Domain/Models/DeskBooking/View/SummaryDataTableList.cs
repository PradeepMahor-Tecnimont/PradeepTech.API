using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class SummaryDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Office")]
        public string OfficeCode { get; set; }

        [Display(Name = "Base Location")]
        public string BaseOfficeLocation { get; set; }
        public string BaseOfficeLocationCode { get; set; }

        [Display(Name = "Department")]
        public string Costcode { get; set; }

        [Display(Name = "Department")]
        public string Department { get; set; }

        [Display(Name = "Count")]
        public decimal? EmpCount { get; set; }

    }
}
