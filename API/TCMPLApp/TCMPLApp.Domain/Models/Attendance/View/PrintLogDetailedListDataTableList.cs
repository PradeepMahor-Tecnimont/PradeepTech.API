using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class PrintLogDetailedListDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Print date")]
        public string PrintDate { get; set; }

        [Display(Name = "Print time")]
        public string PrintTime { get; set; }

        [Display(Name = "Que name")]
        public string QueName { get; set; }

        [Display(Name = "File name")]
        public string FileName { get; set; }

        [Display(Name = "Color")]
        public string Color { get; set; }

        [Display(Name = "Page count")]
        public decimal PageCount { get; set; }
    }
}