using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class EmpPensionFundDetailsDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal? RowNumber { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Employee Id")]
        public string Empno { get; set; }

        [Display(Name = "Nominee Name")]
        public string NomName { get; set; }

        [Display(Name = "Nominee Address")]
        public string NomAdd1 { get; set; }

        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Nominee Birth Date")]
        public string NomDob { get; set; }

        [Display(Name = "Modified On")]
        public string ModifiedOn { get; set; }
    }
}
