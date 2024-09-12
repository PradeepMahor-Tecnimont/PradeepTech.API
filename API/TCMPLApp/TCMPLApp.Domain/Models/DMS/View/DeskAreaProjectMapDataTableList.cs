using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaProjectMapDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Category Desc")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area Info")]
        public string AreaInfo { get; set; }

        [Display(Name = "Desk Area Type")]
        public string DeskAreaTypeVal { get; set; }

        [Display(Name = "Desk Area Type")]
        public string DeskAreaTypeText { get; set; }

        [Display(Name = "Is Restricted")]
        public string IsRestrictedText { get; set; }

        public string IsRestricted { get; set; }
        public string ProjectNo { get; set; }
        public string ProjectName { get; set; }
        public decimal IsRestrictedVal { get; set; }

        [Display(Name = "Area Count")]
        public decimal ProjCount { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime ModifiedOn { get; set; }
    }
}