using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DmAreaTypeDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }


        [Display(Name = "Id")]
        public string KeyId { get; set; }

        [Display(Name = "Short description")]
        public string ShortDesc { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }

        [Display(Name = "Is active")]
        public decimal? IsActiveVal { get; set; }

        [Display(Name = "Is Active")]
        public string IsActiveText { get; set; }

        [Display(Name = "Area Type")]
        public decimal? AreaTypeVal { get; set; }

        [Display(Name = "Area Type")]
        public string AreaTypeText { get; set; }

        [Display(Name = "Modified on")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "modified by")]
        public string ModifiedBy { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}
