using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.LC
{
    public class LcChargesDataTableList
    {
        [Display(Name = "Application id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Lc key id")]
        public string LcKeyId { get; set; }

        [Display(Name = "Lc charges status")]
        public string LcChargesStatusVal { get; set; }

        [Display(Name = "Lc charges status")]
        public string LcChargesStatusText { get; set; }

        [Display(Name = "Basic charges")]
        public decimal BasicCharges { get; set; }

        [Display(Name = "Other charges")]
        public decimal OtherCharges { get; set; }

        [Display(Name = "Days")]
        public decimal Days { get; set; }

        [Display(Name = "CommissionRate")]
        public decimal CommissionRate { get; set; }

        [Display(Name = "Tax")]
        public decimal Tax { get; set; }

        [Display(Name = "Clint File name")]
        public string ClintFileName { get; set; }

        [Display(Name = "Server file name")]
        public string ServerFileName { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }
    }
}