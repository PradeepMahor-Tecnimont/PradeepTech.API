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
    public class HRVoluntaryParentPolicyDataTableList
    {
        [Display(Name = "Voluntary Parent Policy id")]
        public string ApplicationId { get; set; }

        public string KeyIdDetail { get; set; }

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

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Relation")]
        public string Relation { get; set; }

        [Display(Name = "Date of birth")]
        public string Dob { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Display(Name = "Insured sum (Family floater)")]
        public string InsuredSumWords { get; set; }

        [Display(Name = "Modified date")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Parents count")]
        public decimal? ParentsCount { get; set; }

        [Display(Name = "Premium amount")]
        public decimal? PremiumAmt { get; set; }

        [Display(Name = "GST amount")]
        public decimal? GstAmt { get; set; }

        [Display(Name = "Total premium amount")]
        public decimal? TotalPremium { get; set; }

        public decimal? TotalRow { get; set; }

        public decimal? RowNumber { get; set; }

        [Display(Name = "My Parents count")]
        public decimal? MyParentsCount { get; set; }

        [Display(Name = "My Parents Premium amount")]
        public decimal? MyParentsPremiumAmt { get; set; }

        [Display(Name = "My Parents GST amount")]
        public decimal? MyParentsGstAmt { get; set; }

        [Display(Name = "My Parents Total premium amount")]
        public decimal? MyParentsTotalPremium { get; set; }

        [Display(Name = "Inlaws count")]
        public decimal? InlawsCount { get; set; }

        [Display(Name = "Inlaws Premium amount")]
        public decimal? InlawsPremiumAmt { get; set; }

        [Display(Name = "Inlaws GST amount")]
        public decimal? InlawsGstAmt { get; set; }

        [Display(Name = "Inlaws Total premium amount")]
        public decimal? InlawsTotalPremium { get; set; }
    }
}