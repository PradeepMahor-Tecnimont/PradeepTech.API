using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class TagObjectMapDataTableExcel
    {
        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Tag Id")]
        public string TagId { get; set; }

        [Display(Name = "Tag Name")]
        public string TagName { get; set; }

        [Display(Name = "Object Id")]
        public string ObjId { get; set; }

        [Display(Name = "Object Description")]
        public string ObjDesc { get; set; }

        [Display(Name = "Object Type")]
        public string ObjTypeId { get; set; }

        [Display(Name = "Object Type")]
        public string ObjTypeName { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}