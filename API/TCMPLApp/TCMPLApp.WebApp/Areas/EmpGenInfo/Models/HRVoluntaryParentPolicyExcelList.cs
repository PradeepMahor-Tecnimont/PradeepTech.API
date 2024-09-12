using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using System.Diagnostics;
using DocumentFormat.OpenXml.VariantTypes;

namespace TCMPLApp.WebApp.Models
{
    public class HRVoluntaryParentPolicyExcelList
    {
        //private VoluntaryParentsPolicy VoluntaryParentsPolicy;
    }

    public class VoluntaryParentsPolicy
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Employee Dob")]
        public string EmpDob { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Mobileno")]
        public string Mobileno { get; set; }

        [Display(Name = "Added on")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Date of birth")]
        public string Dob { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }

        public List<PremiumDetails> PremiumDetail { get; set; }

        public VoluntaryParentsPolicy()
        {
            this.PremiumDetail = new List<PremiumDetails>();
        }
    }

    public class PremiumDetails
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee")]
        public string Employee { get; set; }

        [Display(Name = "Employee Dob")]
        public string EmpDob { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Added on")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Insured sum")]
        public string InsuredSumWords { get; set; }

        [Display(Name = "My Parents count")]
        public decimal? ParentsCount { get; set; }

        [Display(Name = "My Parents Premium amount")]
        public decimal? ParentsPremiumAmt { get; set; }

        [Display(Name = "My Parents GST amount")]
        public decimal? ParentsGstAmt { get; set; }

        [Display(Name = "My Parents total premium amount")]
        public decimal? ParentsPremium { get; set; }

        [Display(Name = "Inlaws count")]
        public decimal? InlawsCount { get; set; }

        [Display(Name = "Inlaws Premium amount")]
        public decimal? InlawsPremiumAmt { get; set; }

        [Display(Name = "Inlaws GST amount")]
        public decimal? InlawsGstAmt { get; set; }

        [Display(Name = "Inlaws total premium amount")]
        public decimal? InlawsPremium { get; set; }

        [Display(Name = "Total Parents count")]
        public decimal? TotalCount { get; set; }

        [Display(Name = "Total Parents Premium amount")]
        public decimal? TotalPremiumAmt { get; set; }

        [Display(Name = "Total Parents GST amount")]
        public decimal? TotalGstAmt { get; set; }

        [Display(Name = "Total Parents premium amount")]
        public decimal? TotalPremium { get; set; }
    }
}