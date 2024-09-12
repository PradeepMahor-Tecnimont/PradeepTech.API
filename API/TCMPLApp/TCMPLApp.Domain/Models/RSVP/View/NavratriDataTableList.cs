using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class NavratriDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }        

        [Display(Name = "Attend")]
        public decimal? Attend { get; set; }

        [Display(Name = "Bus")]
        public decimal? Bus { get; set; }

        [Display(Name = "Dinner")]
        public decimal? Dinner { get; set; }

    }
}