using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.OffBoarding
{
    public class OFBExit : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PEmpPersonId { get; set; }
        public string PEmployeeName { get; set; }
        public string PGrade { get; set; }
        public string PParent { get; set; }
        public string PDeptName { get; set; }
        public DateTime? PEndByDate { get; set; }

        // [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        public DateTime? PRelievingDate { get; set; }

        //[Display(Name = "Retirement  / Resignation date")]
        public DateTime? PResignationDate { get; set; }

        //[DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        //[Display(Name = "Date of joining")]
        public DateTime? PDoj { get; set; }

        public string PInitiatorRemarks { get; set; }
        public string PAddress { get; set; }
        public string PMobilePrimary { get; set; }
        public string PAlternateNumber { get; set; }
        public string PEmailId { get; set; }
        public string PCreatedBy { get; set; }
        public DateTime? PCreatedOn { get; set; }
        public string PModifiedBy { get; set; }
        public DateTime? PModifiedOn { get; set; }

        //public string PApprovalStatus { get; set; }
        //public string PFirstApprovalStatus { get; set; }
        //public string POverallApprovalStatus { get; set; }
        //public string PHRManagerCanApprove { get; set; }
    }
}