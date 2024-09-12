using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemNotInServiceDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Action Transaction Id")]
        public string ActionTransId { get; set; }

        [Display(Name = "Asset Id")]
        public string AssetId { get; set; }

        [Display(Name = "Action Type")]
        public decimal ActionType { get; set; }

        [Display(Name = "Action Type Text")]
        public string ActionTypeText { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Action Date")]
        public DateTime? ActionDate { get; set; }

        [Display(Name = "Action By")]
        public string ActionBy { get; set; }

        [Display(Name = "Source Emp")]
        public string SourceEmp { get; set; }

        [Display(Name = "Assert Id Old")]
        public string AssetidOld { get; set; }

        [Display(Name = "Item Type")]
        public string ItemTpye { get; set; }
    }
}
