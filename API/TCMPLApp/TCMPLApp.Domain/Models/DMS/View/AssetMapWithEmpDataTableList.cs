using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class AssetMapWithEmpDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Group Type")]
        public string GroupType { get; set; }

        [Display(Name = "Item Id")]
        public string ItemId { get; set; }

        [Display(Name = "Item Description")]
        public string TypeDesc { get; set; }

        [Display(Name = "Asset Type")]
        public string AssetType { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }
        
        //[Display(Name = "Issued To")]
        //public string IssuedTo { get; set; }

        //[Display(Name = "Issued Date")]
        //public DateTime? IssuedDate { get; set; }
    }
}
