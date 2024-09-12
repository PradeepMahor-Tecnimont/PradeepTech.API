using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.Domain.Models.JOB.View;

namespace TCMPLApp.WebApp.Models
{
    public class JobmasterMainDetailViewModel
    {
        [Display(Name = "Job no")]
        public string Projno { get; set; }

        public string JobModeStatus { get; set; }

        [Display(Name = "Mode")]
        public string FormMode { get; set; }

        [Display(Name = "Revision")]
        public string Revision { get; set; }

        [Display(Name = "Plant + progreesive no")]
        public string PlantProgressNo { get; set; }

        [Display(Name = "Short decripton")]
        public string ShortDesc { get; set; }                

        [Display(Name = "Company")]
        public string CompanyName { get; set; }

        [Display(Name = "Job type")]
        public string JobTypeName { get; set; }

        [Display(Name = "Consortium to group")]
        public decimal? IsConsortium { get; set; }

        [Display(Name = "TCM no")]
        public string Tcmno { get; set; }        
        
        public string Place { get; set; }
        
        public string Country { get; set; }

        [Display(Name = "Country")]
        public string CountryName { get; set; }
        
        public string ScopeOfWork { get; set; }

        [Display(Name = "Scope of work")]
        public string ScopeOfWorkName { get; set; }
       
        public string Loc { get; set; }

        [Display(Name = "State")]
        public string StateName { get; set; }
        
        public string PlantType { get; set; }

        [Display(Name = "Plant type")]
        public string PlantTypeName { get; set; }
        
        public string BusinessLine { get; set; }

        [Display(Name = "Business line")]
        public string BusinessLineName { get; set; }

        [Display(Name = "Sub business line")]
        public string SubBusinessLineName { get; set; }
        
        public string Projtype { get; set; }

        [Display(Name = "Project type")]
        public string ProjectTypeName { get; set; }

        public string InvoiceToGrp { get; set; }

        [Display(Name = "Invoice to grp company")]
        public string InvoiceToGrpName { get; set; }

        [Display(Name = "Client")]
        public string Client { get; set; }

        [Display(Name = "LOI contract number")]
        public string ContractNumber { get; set; }

        [Display(Name = "LOI contract date")]
        public string ContractDate { get; set; }

        [Display(Name = "Job opening date")]
        public string StartDate { get; set; }

        [Display(Name = "Revised closing date")]
        public string RevCloseDate { get; set; }

        [Display(Name = "Expected closing date")]
        public string ExpCloseDate { get; set; }

        [Display(Name = "Actual closing date")]
        public string ActualCloseDate { get; set; }               

        [Display(Name = "Project manager name")]
        public string PmName { get; set; }

        [Display(Name = "Operator name")]
        public string InchargeName { get; set; }

        [Display(Name = "Budget attached")]
        public decimal BudgetAttached { get; set; }

        [Display(Name = "Opening month")]
        public string OpeningMonth { get; set; }

        [Display(Name = "Job ststus")]
        public decimal JobStatus { get; set; }

        public decimal IsLegacy { get; set; }

        public JobApproverStatus ApprovalStatus { get; set; }

        public IEnumerable<ProfileAction> ProjectActions { get; set; }

        public string ClientCode { get; set; }

        [Display(Name = "Client")]
        public string ClientCodeName { get; set; }

    }
}
