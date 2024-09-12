using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaOfficeMapDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Office Name")]
        public string OfficeDesc { get; set; }

        [Display(Name = "Area Id")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area Info")]
        public string AreaInfo { get; set; }

        [Display(Name = "Area Category")]
        public string AreaCatgCode { get; set; }
    }
}
