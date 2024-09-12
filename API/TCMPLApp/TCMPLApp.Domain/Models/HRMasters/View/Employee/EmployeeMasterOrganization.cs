using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterOrganization
    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        public string Name { get; set; }

        [Display(Name = "Date of leaving")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Dol { get; set; }

        [Display(Name = "Date of return")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? Dor { get; set; }

        [Display(Name = "Secretary")]
        public string Secretary { get; set; }
        
        public string SecretaryName { get; set; }

        [Display(Name = "Manager")]
        public string Mngr { get; set; }
        
        public string Mngr_name { get; set; }

        [Display(Name = "Emlpoyee HoD")]
        public string EmpHod { get; set; }
        
        public string Emp_hod_name { get; set; }

        [Display(Name = "Location")]
        public string Location { get; set; }
        
        public string Locationdesc { get; set; }

        [Display(Name = "Employee id (SAP)")]
        public string Sapemp { get; set; }

        [Display(Name = "PAN")]
        public string Itno { get; set; }

        [Display(Name = "Contract end date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? ContractEndDate { get; set; }

        [Display(Name = "Subcontract agency")]
        public string Subcontract { get; set; }
        
        public string Description { get; set; }

        [Display(Name = "Contract id (GHR)")]
        public string Cid { get; set; }

        [Display(Name = "Bank code")]
        public string Bankcode { get; set; }

        public string Bankcodedesc { get; set; }

        [Display(Name = "Bank a/c no")]
        public string Acctno { get; set; }

        [Display(Name = "IFSC")]
        public string Ifscno { get; set; }

        [Display(Name = "Leaving Reason")]
        public string ReasonId { get; set; }
        
        public string ReasonDesc { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        public Int32? Status { get; set; }
        public string IsEditable { get; set; }

        [Display(Name = "Graduation")]
        public string Graduation { get; set; }

        [Display(Name = "Place")]
        public string Place { get; set; }

        [Display(Name = "Graduation")]
        public string GraduationDesc { get; set; }

        [Display(Name = "Place")]
        public string PlaceDesc { get; set; }

        [Display(Name = "Qualification")]
        public string QualificationDesc { get; set; }

        [Display(Name = "Job title")]
        public string JobTitle { get; set; }

        [Display(Name = "Job title")]
        public string TitCd { get; set; }

        [Display(Name = "Job title")]
        public string JobTitleDetailed { get; set; }

        [Display(Name = "Experience before")]
        public Decimal? Expbefore { get; set; }

        [Display(Name = "Year of Graduation")]
        public string Gradyear { get; set; }
                
        [Display(Name = "Qual Group")]
        public int? QualGroup { get; set; }
                
        [Display(Name = "Gratutity No")]
        public string Gratutityno { get; set; }
                
        [Display(Name = "Aadhar No")]
        public string Aadharno { get; set; }
                
        [Display(Name = "PF No")]
        public string Pfno { get; set; }
                
        [Display(Name = "Superannuation No")]
        public string Superannuationno { get; set; }
                
        [Display(Name = "UAN No")]
        public string Uanno { get; set; }
               
        [Display(Name = "Pension No")]
        public string Pensionno { get; set; }

        [Display(Name = "Year of Diploma")]
        public string DiplomaYear { get; set; }

        [Display(Name = "Year of Postgraduation")]
        public string PostgraduationYear { get; set; }
    }
}
