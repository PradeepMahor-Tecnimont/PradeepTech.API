using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class TagObjectMapDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Tag Id")]
        public decimal TagId { get; set; }

        [Display(Name = "Tag Name")]
        public string TagName { get; set; }

        [Display(Name = "Object Id")]
        public string ObjId { get; set; }

        [Display(Name = "Object Description")]
        public string ObjDesc { get; set; }

        [Display(Name = "Object Type")]
        public decimal ObjTypeId { get; set; }

        [Display(Name = "Object Type")]
        public string ObjTypeName { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}
