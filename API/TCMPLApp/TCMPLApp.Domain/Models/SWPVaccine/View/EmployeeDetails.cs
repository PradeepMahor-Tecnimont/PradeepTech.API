using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class EmployeeDetails
    {
        [Display(Name = "EmpNo")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string Name { get; set; }

        [Display(Name = "Employee Type")]
        public string EmpType { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation Code")]
        public string DesgCode { get; set; }

        [Display(Name = "Designation Name")]
        public string DesgName { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MMM-yyyy}")]
        [Display(Name = "Date of Joining")]
        public DateTime Doj { get; set; }

        [Display(Name = "Cost Code")]
        public string Parent { get; set; }

        [Display(Name = "Dept Name")]
        public string CostName { get; set; }

        [Display(Name = "SAP Code")]
        public string Sapcc { get; set; }

        [Display(Name = "Assign Code")]
        public string Assign { get; set; }

        [Display(Name = "Assign Name")]
        public string AssignName { get; set; }

        [Display(Name = "Assign SAP Code")]
        public string Sapccassign { get; set; }

        [Display(Name = "HoD")]
        public string HoD { get; set; }

        [Display(Name = "HoD Name")]
        public string HoDName { get; set; }

        [Display(Name = "Department Secretary")]
        public string Secretary { get; set; }

        [Display(Name = "Department Secretary")]
        public string SecName { get; set; }

        [Display(Name = "Card RFID")]
        public string CardRFID { get; set; }

        [Display(Name = "Hexa RFID")]
        public string HexaCardRFID { get; set; }

        [Display(Name = "Person Id")]
        public string PersonId { get; set; }

        [Display(Name = "MetaId")]
        public string MetaId { get; set; }
    }
}