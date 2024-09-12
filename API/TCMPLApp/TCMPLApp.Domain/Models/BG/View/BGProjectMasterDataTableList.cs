using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGProjectMasterDataTableList
    {
        [Display(Name = "Project no")]
        public string Projnum { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Manager name")]
        public string Mngrname { get; set; }

        [Display(Name = "Manager email")]
        public string Mngremail { get; set; }

        [Display(Name = "Closed")]
        public decimal Isclosed { get; set; }

        [Display(Name = "Modified date")]
        public DateTime? Modifiedon { get; set; }

        [Display(Name = "Modified by")]
        public string Modifiedby { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}