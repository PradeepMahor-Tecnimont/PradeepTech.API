using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using System.Diagnostics;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class HRVoluntaryParentPolicyDetailDataTableList
    {
        [Display(Name = "Voluntary Parent Policy detail id")]
        public string KeyId { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Date of birth")]
        public string Dob { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal? RowNumber { get; set; }
    }
}