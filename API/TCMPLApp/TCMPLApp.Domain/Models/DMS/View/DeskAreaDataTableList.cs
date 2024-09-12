using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Area Id")]
        public string AreaId { get; set; }

        [Display(Name = "Area description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area categories code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area categories description")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "Area info")]
        public string AreaInfo { get; set; }

        [Display(Name = "Desk area type")]
        public string DeskAreaTypeVal { get; set; }

        [Display(Name = "Desk area type")]
        public string DeskAreaTypeText { get; set; }

        [Display(Name = "Tag")]
        public decimal TagId { get; set; }

        public string TagName { get; set; }
        public decimal? AreaIdCount { get; set; }
        public decimal? IsRestrictedVal { get; set; }
        public string IsRestrictedText { get; set; }

        public decimal? IsActiveVal { get; set; }
        public string IsActiveText { get; set; }
    }
}