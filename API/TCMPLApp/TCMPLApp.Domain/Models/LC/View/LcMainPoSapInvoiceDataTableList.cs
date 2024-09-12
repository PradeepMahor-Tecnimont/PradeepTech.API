using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcMainPoSapInvoiceDataTableList
    {
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Lc key id")]
        public string LcKeyId { get; set; }

        [Display(Name = "Purchase order")]
        public string Po { get; set; }

        [Display(Name = "Sap doc no")]
        public string Sap { get; set; }

        [Display(Name = "Invoice no")]
        public string Invoice { get; set; }

        [Display(Name = "Modified on date")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Modified by ")]
        public string ModifiedBy { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}