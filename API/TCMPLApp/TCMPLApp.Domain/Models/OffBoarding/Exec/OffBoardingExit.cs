using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OffBoardingExit
    {
        public string Empno { get; set; }
        public string Personid { get; set; }
        public string EmployeeName { get; set; }
        public string Grade { get; set; }
        public string Parent { get; set; }
        public string DeptName { get; set; }
        public DateTime EndByDate { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        public DateTime RelievingDate { get; set; }
        [Display (Name = "Retirement  / Resignation date")]
        public DateTime ResignationDate { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        [Display (Name = "Date of joining")]
        public DateTime? Doj { get; set; }
        public string InitiatorRemarks { get; set; }
        public string Address { get; set; }
        public string MobilePrimary { get; set; }
        public string AlternateNumber { get; set; }
        public string EmailId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime ModifiedOn { get; set; }

        public string ApprovalStatus { get; set; }

        public string FirstApprovalStatus { get; set; }
        public string OverallApprovalStatus { get; set; }
        public string HRManagerCanApprove { get; set; }
    
    
    }

}
