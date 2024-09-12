using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class GTLIDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal? RowNumber { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Employee No")]
        public string Empno { get; set; }

        [Display(Name = "Nominee Name")]
        public string NomName { get; set; }

        [Display(Name = "Nominee Address")]
        public string NomAdd1 { get; set; }

        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Nominee Date Of Birth")]
        public string NomDob { get; set; }

        [Display(Name = "Share Percentage")]
        public string SharePcnt { get; set; }

        [Display(Name = "Minor details")]
        public string MinorDetails { get; set; }

        [Display(Name = "Is Editable")]
        public string IsEditable { get; set; }
    }
}
