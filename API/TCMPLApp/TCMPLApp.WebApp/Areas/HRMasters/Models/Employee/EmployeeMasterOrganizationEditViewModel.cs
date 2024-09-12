using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeMasterOrganizationEditViewModel
    {
        [StringLength(5)]
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Date of leaving")]
        public DateTime? Dol { get; set; }

        [Display(Name = "Date of return")]
        public DateTime? Dor { get; set; }

        [StringLength(5)]
        [Display(Name = "Secretary")]
        public string Secretary { get; set; }
                
        [StringLength(5)]
        [Display(Name = "Manager")]
        public string Mngr { get; set; }
                
        [StringLength(5)]
        [Display(Name = "Emlpoyee HoD")]
        public string EmpHod { get; set; }

        [StringLength(1)]
        [Display(Name = "Location")]
        public string Location { get; set; }

        [StringLength(8)]
        [Display(Name = "Employee id (SAP)")]
        public string Sapemp { get; set; }

        [StringLength(10)]
        [Display(Name = "PAN")]
        public string Itno { get; set; }

        [Display(Name = "Contract end date")]
        public DateTime? ContractEndDate { get; set; }

        [Display(Name = "Subcontract agency")]
        public string Subcontract { get; set; }

        [StringLength(8)]
        [Display(Name = "Contract id (GHR)")]
        public string Cid { get; set; }

        [StringLength(3)]
        [Display(Name = "Bank code")]
        public string Bankcode { get; set; }

        [StringLength(15)]
        [Display(Name = "Bank a/c no")]
        public string Acctno { get; set; }

        [StringLength(14)]
        [Display(Name = "IFSC")]
        public string Ifscno { get; set; }

        [StringLength(100)]
        [Display(Name = "Leaving Reason")]
        public string ReasonDesc { get; set; }

        [StringLength(200)]
        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Graduation")]
        public string Graduation { get; set; }

        [Display(Name = "Place")]
        public string Place { get; set; }

        [Display(Name = "Qualification")]
        public string[] Qualification { get; set; }

        [Display(Name = "Job title")]
        public string TitCd { get; set; }

        [Display(Name = "Job title")]
        public string JobTitle { get; set; }

        [Display(Name = "Experience before")]
        public Decimal? Expbefore { get; set; }

        [StringLength(4)]
        [Display(Name = "Year of Graduation")]
        public string Gradyear { get; set; }
                
        [Display(Name = "Qual Group")]
        public int? QualGroup { get; set; }

        [StringLength(18)]
        [Display(Name = "Gratutity No")]
        public string Gratutityno { get; set; }

        [StringLength(12)]
        [Display(Name = "Aadhar No")]
        public string Aadharno { get; set; }

        [StringLength(22)]
        [Display(Name = "PF No")]
        public string Pfno { get; set; }

        [StringLength(15)]
        [Display(Name = "Superannuation No")]        
        public string Superannuationno { get; set; }

        [StringLength(12)]
        [Display(Name = "UAN No")]
        public string Uanno { get; set; }

        [StringLength(20)]
        [Display(Name = "Pension No")]
        public string Pensionno { get; set; }

        [StringLength(4)]
        [Display(Name = "Year of Diploma")]
        public string DiplomaYear { get; set; }

        [StringLength(4)]
        [Display(Name = "Year of Postgraduation")]
        public string PostgraduationYear { get; set; }

    }
}
