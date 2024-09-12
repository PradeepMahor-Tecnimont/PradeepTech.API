using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.CoreSettings
{
    public class DelegateDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Key id")]
        public string KeyId { get; set; }

        [Display(Name = "Log status")]
        public string LogStatus { get; set; }

        [Display(Name = "Module")]
        public string Module { get; set; }

        [Display(Name = "Principal employee")]
        public string PrincipalEmp { get; set; }

        [Display(Name = "OnBehalf employee")]
        public string OnBehalfEmp { get; set; }

        public string PrincipalEmpno { get; set; }
        public string OnBehalfEmpno { get; set; }
        public string ModuleId { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified on")]
        public DateTime? ModifiedOn { get; set; }

        public decimal? DeleteAllowed { get; set; }
    }
}