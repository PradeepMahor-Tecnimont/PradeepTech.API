using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobformListReportExcel
    {
        [Display(Name = "Projno")]
        public string Projno { get; set; }

        [Display(Name = "TCM job No")]
        public string Tcmno { get; set; }

        [Display(Name = "Short Desc")]
        public string ShortDesc { get; set; }

        [Display(Name = "Project Manager")]
        public string PmName { get; set; }

        [Display(Name = "Job Sponsorer")]
        public string JsName { get; set; }

        [Display(Name = "Job Open Date")]
        public string FormDate { get; set; }

        [Display(Name = "Job open date")]
        public string JobOpenDate { get; set; }

        [Display(Name = "Revised Closing Date")]
        public string ClosingDateRev { get; set; }

        [Display(Name = "Actual Closing Date")]
        public string ActualClosingDate { get; set; }

        [Display(Name = "Job Type")]
        public string TypeOfJob { get; set; }

        [Display(Name = "Mode")]
        public string JobModeStatus { get; set; }

        [Display(Name = "Plant Type")]
        public string PlantType { get; set; }

        [Display(Name = "Bussiness Line")]
        public string BusinessLine { get; set; }

        [Display(Name = "Sub business line")]
        public string SubBusinessLine { get; set; }

        [Display(Name = "Scope of work")]
        public string ScopeOfWork { get; set; }

        [Display(Name = "Project type")]
        public string ContractType { get; set; }

        [Display(Name = "Country")]
        public string Country { get; set; }

        [Display(Name = "Client")]
        public string ClientName { get; set; }

        [Display(Name = "Invoice to grp company")]
        public string InvoicingGrpCompany { get; set; }

        [Display(Name = "Job Sponsor")]
        public decimal? JobSponsor { get; set; }

        [Display(Name = "CMD/MD")]
        public decimal? Cmd { get; set; }

        [Display(Name = "AFC")]
        public decimal? Afc { get; set; }

        
    }
}
