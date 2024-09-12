using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGProjectDriMasterDataTableList
    {
        [Display(Name = "Project Control id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Company")]
        public string CompDesc { get; set; }

        [Display(Name = "IsVisible")]
        public decimal IsVisible { get; set; }

        [Display(Name = "IsDeleted")]
        public decimal IsDeleted { get; set; }

        [Display(Name = "Modified date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}