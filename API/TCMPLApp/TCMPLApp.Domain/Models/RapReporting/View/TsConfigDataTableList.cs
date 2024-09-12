using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class TsConfigDataTableList
    {
        [Display(Name = "Schema Name")]
        public string Schemaname { get; set; }
        
        [Display(Name = "Username")]
        public string Username { get; set; }
        
        [Display(Name = "Password")]
        public string Password { get; set; }
        
        [Display(Name = "Process Month")]
        public string ProsMonth { get; set; }
        
        [Display(Name = "Year Start1")]
        public string Yearstart01 { get; set; }
        
        [Display(Name = "Year Start4")]
        public string Yearstart04 { get; set; }
        
        [Display(Name = "Locked Month")]
        public string Lockedmnth { get; set; }
        
        [Display(Name = "yeasterday Date1")]
        public DateTime? Yrstdate01 { get; set; }
        
        [Display(Name = "yeasterday Date4")]
        public DateTime? Yrstdate04 { get; set; }
        
        [Display(Name = "Invoice Month")]
        public string Invoicemonth { get; set; }
        
        [Display(Name = "Year End1")]
        public string Yearend01 { get; set; }
        
        [Display(Name = "Year end4")]
        public string Yearend04 { get; set; }
        
        public decimal? TotalRow { get; set; }
        public decimal RowNumber { get; set; }
    }
}
