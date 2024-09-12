using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemGroupDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Id")]
        public string GroupKeyId { get; set; }

        [Display(Name = "Description")]
        public string GroupDesc { get; set; }

        [Display(Name = "Modified on")]
        public DateTime ModifiedOn { get; set; }


        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }


    }
}