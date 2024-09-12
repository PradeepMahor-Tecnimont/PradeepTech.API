using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.Logbook
{
    public class LogbookDataTableList
    {
        [Display(Name = "Rework No")]
        public string ReworkNo { get; set; }

        [Display(Name = "Type")]
        public string Type { get; set; }

        [Display(Name = "Doc Code")]
        public string DocCode { get; set; }

        [Display(Name = "Costcode")]
        public string DeptNo { get; set; }

        [Display(Name = "Area")]
        public string Area { get; set; }
        
        [Display(Name = "Corr Mode")]
        public string CorrMode { get; set; }

        [Display(Name = "R Date")]
        public DateTime? RDate { get; set; }
        
        [Display(Name = "Reason")]
        public string Reason { get; set; }
        
        [Display(Name = "Corr Ref. No")]
        public string CorrRefNo { get; set; }

        [Display(Name = "Approval Date")]
        public DateTime? ApprovalDate { get; set; }

        [Display(Name = "A")]
        public decimal A { get; set; }
        
        [Display(Name = "B")]
        public decimal B { get; set; }
        
        [Display(Name = "C")]
        public decimal C { get; set; }
        
        [Display(Name = "D")]
        public decimal D { get; set; }
        
        [Display(Name = "Sal")]
        public decimal Sal { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

       
    }
}
