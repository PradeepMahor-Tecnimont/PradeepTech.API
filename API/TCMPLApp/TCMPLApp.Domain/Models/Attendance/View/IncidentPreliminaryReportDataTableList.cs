using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Attendance
{
    [Serializable]
    public class IncidentPreliminaryReportDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Head Office Location ")]
        public string Office { get; set; }

        [Display(Name = "Location where incident occurred")]
        public string LocationWhereIncidentOccurred { get; set; }

        [Display(Name = "Department of Injured person")]
        public string CostName { get; set; }

        [Display(Name = "Date")]
        public string Date { get; set; }

        [Display(Name = "Time")]
        public string Time { get; set; }

        [Display(Name = "Type of accident/incident")]
        public string TypeOfAccidentIncident { get; set; }

        [Display(Name = "Nature of injury")]
        public string NatureOfInjury { get; set; }

        [Display(Name = "Body part injured")]
        public string BodyPartInjured { get; set; }

        [Display(Name = "EmpNo")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string Name { get; set; }

        [Display(Name = "Designation")]
        public string DesgName { get; set; }

        [Display(Name = "Age")]
        public string Age { get; set; }

        [Display(Name = "Sex")]
        public string Sex { get; set; }

        [Display(Name = "Sub-contractor Employee")]
        public string IsSubContractorEmployee { get; set; }

        [Display(Name = "If Yes, Name of Sub-contractor")]
        public string NameOfSubContractor { get; set; }

        [Display(Name = "Referred Medical Aid")]
        public string ReferredMedicalAid { get; set; }

        [Display(Name = "Brief Description of the accident / incident")]
        public string Description { get; set; }

        [Display(Name = "Probable Causes")]
        public string ProbableCauses { get; set; }

        [Display(Name = "Immediate Action")]
        public string ImmediateAction { get; set; }
    }
}