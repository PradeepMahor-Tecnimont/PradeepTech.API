using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class VoluntaryParentPolicyDataTableList
    {
        [Display(Name = "Voluntary Parent Policy id")]
        public string ApplicationId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Date of birth")]
        public string Dob { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Display(Name = "Insured Sum ")]
        public string InsuredSumWords { get; set; }

        [Display(Name = "Voluntary Parent Policy Detail id")]
        public string KeyIdDetail { get; set; }

        public decimal? IsDeleteVal { get; set; }
        public string IsDeleteTxt { get; set; }
    }
}