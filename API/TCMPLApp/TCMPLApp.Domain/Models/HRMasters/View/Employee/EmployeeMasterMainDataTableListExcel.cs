using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class EmployeeMasterMainDataTableListExcel
    {      
        [Display(Name = "Employee no")]
        public string Empno { get; set; }

        [Display(Name = "Group person id")]
        public string Personid { get; set; }

        [Display(Name = "Employee name")]
        public string Name { get; set; }

        public string Status { get; set; }

        public string Payroll { get; set; }
                
        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Parent costcode")]
        public string Parent { get; set; }

        [Display(Name = "Parent costcode abbr")]
        public string ParentName { get; set; }

        [Display(Name = "Parent SAP code")]
        public string SapParent { get; set; }

        [Display(Name = "Assign costcode")]
        public string Assign { get; set; }

        [Display(Name = "Assign costcode abbr")]
        public string AssignName { get; set; }

        [Display(Name = "Assign SAP code")]
        public string SapAssign { get; set; }

        [Display(Name = "Engg / Non engg")]
        public string EnggNonengg { get; set; }

        [Display(Name = "Designation Code")]
        public string Desgcode { get; set; }

        [Display(Name = "Designation")]
        public string Desg { get; set; }

        [Display(Name = "Designation new")]
        public string DesgNew { get; set; }

        public string Grade { get; set; }

        [Display(Name = "Gender")]
        public string Gender { get; set; }
                
        public string Category { get; set; }
                
        public string Married { get; set; }
                
        public DateTime? Dob { get; set; }
                
        public DateTime? Doj { get; set; }

        public DateTime? Doc { get; set; }
              
        public DateTime? Dol { get; set; }
       
        public DateTime? Dor { get; set; }

        [Display(Name = "Qualification")]
        public string Qualificationdesc { get; set; }

        [Display(Name = "Graduation")]
        public string Graduationdesc { get; set; }

        [Display(Name = "Diploma Year")]
        public string DiplomaYear { get; set; }

        [Display(Name = "Graduation Year")]
        public string Gradyear { get; set; }

        [Display(Name = "Year of postgraduation")]
        public string PostgraduationYear { get; set; }

        [Display(Name = "Exp. before")]
        public decimal? Expbefore { get; set; }
               
        public string Location { get; set; }

        [Display(Name = "Subcontractor Name")]
        public string Subcontractname { get; set; }

        [Display(Name = "Office location")]
        public string Officelocation { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Meta id")]
        public string Metaid { get; set; }

        [Display(Name = "Company")]
        public string Company { get; set; }

        [Display(Name = "Manager Code")]
        public string Mngr { get; set; }

        [Display(Name = "Manager Name")]
        public string MngrName { get; set; }

        [Display(Name = "HoD Code")]
        public string EmpHod { get; set; }

        [Display(Name = "HoD Name")]
        public string EmpHodName { get; set; }

        [Display(Name = "Address 1")]
        public string Add1 { get; set; }

        [Display(Name = "Address 2")]
        public string Add2 { get; set; }

        [Display(Name = "Address 3")]
        public string Add3 { get; set; }

        [Display(Name = "Address 4")]
        public string Add4 { get; set; }

        [Display(Name = "Pin code")]
        public Int32? Pincode { get; set; }

        [Display(Name = "PAN")]
        public string Itno { get; set; }

        [Display(Name = "PF Sr No")]
        public string Pfslno { get; set; }

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

        [Display(Name = "First name")]
        public string Firstname { get; set; }

        [Display(Name = "Middle name")]
        public string Middlename { get; set; }

        [Display(Name = "Last name")]
        public string Lastname { get; set; }

        [Display(Name = "Job group")]
        public string Jobgroup { get; set; }

        [Display(Name = "Job group desc")]
        public string Jobgroupdesc { get; set; }

        [Display(Name = "Job discipline")]
        public string Jobdiscipline { get; set; }

        [Display(Name = "Job discipline desc")]
        public string Jobdisciplinedesc { get; set; }

        [Display(Name = "Job title code")]
        public string JobtitleCode { get; set; }

        [Display(Name = "Job title desc")]
        public string Jobtitledesc { get; set; }

        [Display(Name = "Job group desc Milan")]
        public string JobgroupdescMilan { get; set; }

    }
}
