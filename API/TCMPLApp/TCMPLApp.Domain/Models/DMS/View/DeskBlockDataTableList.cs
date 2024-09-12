using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskBlockDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Desk Id")]
        public string Deskid { get; set; }

        [Display(Name = "Particular")]
        public string Remarks { get; set; }

        [Display(Name = "Block Reason")]
        public string Description { get; set; }
    }
}