using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaCategoriesDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Area categories code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area description")]
        public string AreaDescription { get; set; }

        public decimal? AreaCatgCodeCount { get; set; }
    }
}