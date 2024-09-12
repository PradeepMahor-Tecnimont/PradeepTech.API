using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWP
{
    public class DMSOrphanAssetDataTableList
    {
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }

        [Display(Name = "Unqid")]
        public string Unqid { get; set; }

        [Display(Name = "Desk")]
        public string Deskid { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }        
    }
}