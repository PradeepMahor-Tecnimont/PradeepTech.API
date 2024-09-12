using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class LogbookDataTableListExcel
    {
        public string ReworkNo { get; set; }
        public string Type { get; set; }
        public string DocCode { get; set; }
        public string DeptNo { get; set; }
        public string Area { get; set; }
        public string CorrMode { get; set; }
        public DateTime? RDate { get; set; }
        public string Reason { get; set; }
        public string CorrRefNo { get; set; }
        public DateTime? ApprovalDate { get; set; }
        public decimal A { get; set; }
        public decimal B { get; set; }
        public decimal C { get; set; }
        public decimal D { get; set; }
        public decimal Sal { get; set; }
        public string Remarks { get; set; }
    }
}
