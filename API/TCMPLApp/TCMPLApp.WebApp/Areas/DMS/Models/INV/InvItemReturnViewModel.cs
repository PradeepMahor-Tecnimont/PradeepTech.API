using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class InvItemReturnViewModel
    {
        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Required]
        [Display(Name = "Transaction date ")]
        public DateTime? TransactionDate { get; set; }

        [Required]
        [Display(Name = "Transaction remarks")]
        public string TransactionRemarks { get; set; }

        [Required]
        public string JSonObject { get; set; }

        public IEnumerable<InvEmployeeTransactionDetailDataTableList> ItemList { get; set; }
    }

    public class ReturnJson
    {
        public string Empno { get; set; }
        public DateTime? TransDate { get; set; }
        public string TransRemark { get; set; }
        public List<ReturnItems> ReturnItemList { get; set; }
    }

    public class ReturnItems
    {
        public string ItemId { get; set; }
        public string IsUsable { get; set; }
    }
}