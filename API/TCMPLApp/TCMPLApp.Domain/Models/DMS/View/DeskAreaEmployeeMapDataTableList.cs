using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaEmployeeMapDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Desk Id")]
        public string DeskId { get; set; }

        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Category Desc")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Desc")]
        public string AreaDesc { get; set; }

        [Display(Name = "Employee No")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

         [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime ModifiedOn { get; set; }
    }
}
