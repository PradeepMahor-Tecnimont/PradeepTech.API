using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskManagementWorkloadDataTableList
    {
        public decimal RowNumber { get; set; }

        public decimal? TotalRow { get; set; }

        [Display(Name = "Particulars")] 
        public string Particulars { get; set; }

        [Display(Name = "Count")] 
        public decimal? Cnt { get; set; }

    }
}