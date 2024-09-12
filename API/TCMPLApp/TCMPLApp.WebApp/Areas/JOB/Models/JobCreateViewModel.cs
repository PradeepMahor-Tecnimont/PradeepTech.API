using DocumentFormat.OpenXml.Vml;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobCreateViewModel
    {
        // Job attributes

        [Display(Name = "ERP Project manager")]
        public string PMEmpno { get; set; }

        [Display(Name = "Project no.")]
        public string Projno { get; set; }

        [Display(Name = "Revision")]
        public decimal? Revision { get; set; }

        [Display(Name = "Form date")]
        public DateTime? FormDate { get; set; }

        [Display(Name = "Company")]
        public string Company { get; set; }

        [Display(Name = "Job type (TMA)")]
        public string JobType { get; set; }

        [Display(Name = "Consortium with group")]
        public decimal? IsConsortium { get; set; }

        [Display(Name = "Maire Group/ TCM Job Number")]
        public string Tcmno { get; set; }



        [Display(Name = "Plant + Progressive Number")]
        public string PlantProgressNo { get; set; }

        [Display(Name = "Place")]
        public string Place { get; set; }

        [Display(Name = "Country")]
        public string Country { get; set; }

        [Display(Name = "State")]
        public string State { get; set; }

        [Display(Name = "Scope of work")]
        public string ScopeOfWork { get; set; }

        [Display(Name = "Plant type")]
        public string PlantType { get; set; }

        [Display(Name = "Business line")]
        public string BusinessLine { get; set; }

        [Display(Name = "Sub business line")]
        public string SubBusinessLine { get; set; }

        [Display(Name = "Project type")]
        public string ProjectType { get; set; }

        [Display(Name = "Invoicing to group company")]
        public string InvoiceToGrpCompany { get; set; }

        [Display(Name = "Client name")]
        [MaxLength(35)]
        public string ClientName { get; set; }

        [Display(Name = "LOI / contract number")]
        [MaxLength(15)]
        public string ContractNumber { get; set; }

        [Display(Name = "LOI / contract date")]
        public DateTime? ContractDate { get; set; }

        [Display(Name = "Project start date")]
        public DateTime? StartDate { get; set; }

        [Display(Name = "Revised closing date")]
        public DateTime? RevCloseDate { get; set; }

        [Display(Name = "Expected closing date")]
        public DateTime? ExpCloseDate { get; set; }

        [Display(Name = "Actual closing date")]
        public DateTime? ActualCloseDate { get; set; }
        
        public decimal? InitiateApproval { get; set; }

        public decimal? IsLegacy { get; set; }        
        public bool? IsOnBehalf { get; set; }

        public string ClientCode { get; set; }

        [Display(Name = "Client")]
        public string ClientCodeName { get; set; }
    }
}
