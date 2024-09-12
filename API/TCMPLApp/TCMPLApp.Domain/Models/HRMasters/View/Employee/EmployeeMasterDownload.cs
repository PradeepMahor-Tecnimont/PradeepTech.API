using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterDownload
    {
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Group person id")]
        public string Personid { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        [Display(Name = "Status")]
        public string Status { get; set; }

        [Display(Name = "Payroll")]
        public string Payroll { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }

        [Display(Name = "Assign costcode")]
        public string Assign { get; set; }

        [Display(Name = "Desig Code")]
        public string Desgcode { get; set; }

        [Display(Name = "Designation")]
        public string Desg { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }

        [Display(Name = "Category")]
        public string category { get; set; }

        [Display(Name = "Married")]
        public string Married { get; set; }

        [Display(Name = "Date of brith")]
        public string DOB { get; set; }

        [Display(Name = "Date of joining")]
        public string DOJ { get; set; }

        [Display(Name = "Date of confirm")]
        public string DOC { get; set; }

        [Display(Name = "Date of leaving")]
        public string DOL { get; set; }

        [Display(Name = "Date of return")]
        public string DOR { get; set; }

        [Display(Name = "Qualification")]
        public string Qualificationdesc { get; set; }

        [Display(Name = "Graduation")]
        public string Graduationdesc { get; set; }

        [Display(Name = "Year of Graduation")]
        public string Gradyear { get; set; }

        [Display(Name = "Experience before")]
        public Decimal? Expbefore { get; set; }

        [Display(Name = "Location")]
        public string location { get; set; }

        [Display(Name = "Subcontract")]
        public string Subcontractname { get; set; }

        [Display(Name = "Office Location")]
        public string Officelocation { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Meta id")]
        public string Metaid { get; set; }               

        [Display(Name = "Company")]
        public string Company { get; set; }

        [Display(Name = "Manager Id")]
        public string Mngr { get; set; }

        [Display(Name = "Manager name")]
        public string Mngr_name { get; set; }

        [Display(Name = "HoD Id")]
        public string Emp_hod { get; set; }

        [Display(Name = "HoD name")]
        public string Emp_hod_name { get; set; }

        [Display(Name = "Address 1")]
        public string Add1 { get; set; }

        [Display(Name = "Address 2")]
        public string Add2 { get; set; }

        [Display(Name = "Address 3")]
        public string Add3 { get; set; }

        [Display(Name = "Address 4")]
        public string Add4 { get; set; }

        [Display(Name = "Pincode")]
        public string Pincode { get; set; }

        [Display(Name = "PAN no.")]
        public string ITNO { get; set; }

        [Display(Name = "PF no.")]
        public string PFSLNO { get; set; }

        [Display(Name = "PF No")]
        public string Pfno { get; set; }

        [Display(Name = "Gratutity No")]
        public string Gratutityno { get; set; }
        
        [Display(Name = "Aadhar No")]
        public string Aadharno { get; set; } 
       
        [Display(Name = "Superannuation No")]
        public string Superannuationno { get; set; }
        
        [Display(Name = "UAN No")]
        public string Uanno { get; set; }
       
        [Display(Name = "Pension No")]
        public string Pensionno { get; set; }
    }
}
