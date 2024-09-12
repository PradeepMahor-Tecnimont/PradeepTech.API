using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.JOB.View;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobmasterMainDetailOut : DBProcMessageOutput
    {
        public string PJobModeStatus { get; set; }

        [Display(Name = "Mode")]
        public string PFormMode { get; set; }
                
        [Display(Name = "Form date")]
        public string PFormDate { get; set; }

        [Display(Name = "Revision")]
        public string PRevision { get; set; }

        [Display(Name = "Plant + progreesive no")]
        public string PPlantProgressNo { get; set; }

        [Display(Name = "Short decripton")]
        public string PShortDesc { get; set; }

        [Display(Name = "Company")]
        public string PCompany { get; set; }
        public string PCompanyName { get; set; }

        public string PJobType { get; set; }

        [Display(Name = "Job type")]
        public string PJobTypeName { get; set; }

        [Display(Name = "Consortium to group")]
        public decimal? PIsconsortium { get; set; }

        [Display(Name = "TCM no")]
        public string PTcmno { get; set; }

        public string PPlace { get; set; }

        public string PCountry { get; set; }

        [Display(Name = "Country")]
        public string PCountryName { get; set; }

        public string PScopeOfWork { get; set; }

        [Display(Name = "Scope of work")]
        public string PScopeOfWorkName { get; set; }

        public string PLoc { get; set; }

        [Display(Name = "State")]
        public string PStateName { get; set; }

        public string PPlantType { get; set; }

        [Display(Name = "Plant type")]
        public string PPlantTypeName { get; set; }

        public string PBusinessLine { get; set; }

        [Display(Name = "Business line")]
        public string PBusinessLineName { get; set; }

        public string PSubBusinessLine { get; set; }

        [Display(Name = "Sub business line")]
        public string PSubBusinessLineName { get; set; }

        public string PProjtype { get; set; }

        [Display(Name = "Project type")]
        public string PProjectTypeName { get; set; }
        
        public string PInvoiceToGrp { get; set; }

        [Display(Name = "Invoice to grp company")]
        public string PInvoiceToGrpName { get; set; }

        [Display(Name = "Client")]
        public string PClient { get; set; }

        [Display(Name = "LOI contract number")]
        public string PContractNumber { get; set; }

        [Display(Name = "LOI contract date")]
        public string PContractDate { get; set; }

        [Display(Name = "Job opening date")]
        public string PStartDate { get; set; }

        [Display(Name = "Job revision date")]
        public string PRevCloseDate { get; set; }

        [Display(Name = "Expcted closing date")]
        public string PExpCloseDate { get; set; }

        [Display(Name = "Actual closing date")]
        public string PActualCloseDate { get; set; }

        [Display(Name = "Project manager name")]
        public string PPmName { get; set; }

        [Display(Name = "Operator name")]
        public string PInchargeName { get; set; }

        [Display(Name = "Budget attached")]
        public decimal PBudgetAttached { get; set; }

        [Display(Name = "Opening month")]
        public string POpeningMonth { get; set; }

        [Display(Name = "Job ststus")]
        public decimal PJobstatus { get; set; }

        public decimal PIsLegacy { get; set; }

        public string PClientCode { get; set; }

        [Display(Name = "Client")]
        public string PClientCodeName { get; set; }
    }
}
