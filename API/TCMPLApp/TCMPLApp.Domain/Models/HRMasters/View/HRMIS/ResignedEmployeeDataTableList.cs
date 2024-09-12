using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class ResignedEmployeeDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Employee No/Name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Emp Resignation Date")]
        public DateTime? EmpResignDate { get; set; }

        [Display(Name = "Hr Receipt Date")]
        public DateTime? HrReceiptDate { get; set; }

        [Display(Name = "Date Of Relieving")]
        public DateTime? DateOfRelieving { get; set; }

        [Display(Name = "Employee Resign Reason")]
        public string EmpResignReason { get; set; }

        [Display(Name = "Resign Reason Type")]
        public string ResignReasonType { get; set; }

        [Display(Name = "Additional Feedback")]
        public string AdditionalFeedback { get; set; }

        [Display(Name = "Exit Interview Conplete")]
        public string ExitInterviewComplete { get; set; }

        [Display(Name = "Increase Percentage")]
        public decimal? PercentIncreas { get; set; }

        [Display(Name = "Resignation Status")]
        public string ResignSt { get; set; }

        [Display(Name = "Commitment On RollBack")]
        public string CommitmentOnRollback { get; set; }

        [Display(Name = "Last Date In Office")]
        public DateTime? ActualLastDateInOffice { get; set; }

        [Display(Name = "Date of joining")]
        public DateTime? Doj { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Display(Name = "Department")]
        public string Department { get; set; }
    }

    public class ResignedEmployeeXLDataTableList
    {
        public string Empno { get; set; }
        public string Name { get; set; }
        public string Emptype { get; set; }
        public string Dept { get; set; }
        public string DeptName { get; set; }
        public string Grade { get; set; }
        public string Designation { get; set; }
        public DateTime Doj { get; set; }

        public DateTime EmpResignDate { get; set; }
        public DateTime HrReceiptDate { get; set; }
        public string ResignMonth { get; set; }
        public DateTime? Dol { get; set; }
        public DateTime? DateOfRelieving { get; set; }
        public string EmpResignReason { get; set; }

        //public string PrimaryReason { get; set; }
        public string PrimaryResignDesc { get; set; }

        //public string SecondaryReason { get; set; }
        public string SecondaryResignDesc { get; set; }

        public string AdditionalFeedback { get; set; }
        public decimal? PercentIncrease { get; set; }
        public string MovingToLocation { get; set; }

        //public string CurrentLocation { get; set; }
        public string CurrenLocationDesc { get; set; }

        public string ExitInterviewStatus { get; set; }

        //public string ResignStatusCode { get; set; }
        public string ResignStatusDesc { get; set; }

        public string CommitmentOnRollback { get; set; }
        public DateTime? ActualLastDateInOffice { get; set; }
        public string Discipline { get; set; }
        public string Group1 { get; set; }
        public string Group2 { get; set; }
    }
}