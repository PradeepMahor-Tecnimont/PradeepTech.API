using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Common
{
    public class EmployeeDetails : DBProcMessageOutput
    {
        [Display(Name = "EmpNo")]
        public string PForEmpno { get; set; }

        [Display(Name = "Employee Name")]
        public string PName { get; set; }

        [Display(Name = "Employee Type")]
        public string PEmpType { get; set; }

        [Display(Name = "Grade")]
        public string PGrade { get; set; }

        [Display(Name = "Designation Code")]
        public string PDesgCode { get; set; }

        [Display(Name = "Designation Name")]
        public string PDesgName { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of Joining")]
        public DateTime PDoj { get; set; }

        [Display(Name = "Cost Code")]
        public string PParent { get; set; }

        [Display(Name = "Dept Name")]
        public string PCostName { get; set; }

        [Display(Name = "SAP Code")]
        public string PSapcc { get; set; }

        [Display(Name = "Assign Code")]
        public string PAssign { get; set; }

        [Display(Name = "Assign Name")]
        public string PAssignName { get; set; }

        [Display(Name = "Assign SAP Code")]
        public string PSapccassign { get; set; }

        [Display(Name = "HoD")]
        public string PHoD { get; set; }

        [Display(Name = "HoD Name")]
        public string PHoDName { get; set; }

        [Display(Name = "Mngr Name")]
        public string PMngrName { get; set; }

        [Display(Name = "Department Secretary")]
        public string PSecretary { get; set; }

        [Display(Name = "Department Secretary")]
        public string PSecName { get; set; }

        [Display(Name = "Card RFID")]
        public string PCardRFID { get; set; }

        [Display(Name = "Hexa RFID")]
        public string PHexaCardRFID { get; set; }

        [Display(Name = "Person Id")]
        public string PEmpPersonId { get; set; }

        [Display(Name = "MetaId")]
        public string PEmpMetaId { get; set; }

        [Display(Name = "Todays first punch office")]
        public string PTodaysFirstPunchOffice { get; set; }

        [Display(Name = "Base office")]
        public string PBaseOffice { get; set; }

        [Display(Name = "Current office location")]
        public string PCurrentOfficeLocation { get; set; }

        [Display(Name = "Primary workspace")]
        public string PPrimaryWorkspace { get; set; }

        [Display(Name = "DeskId")]
        public string PDeskId { get; set; }

        [Display(Name = "Email")]
        public string PEmail { get; set; }

        [Display(Name = "Job title")]
        public string PJobTitle { get; set; }

        [Display(Name = "Show all details")]
        public string PShowAllDetails { get; set; }


    }
}