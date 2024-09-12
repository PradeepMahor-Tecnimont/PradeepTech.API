using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class MediclaimDetailsDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal? RowNumber { get; set; }

        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Employee Id")]
        public string Empno { get; set; }

        [Display(Name = "Member Name")]
        public string Member { get; set; }

        [Display(Name = "Date of Birth")]
        public string Dob { get; set; }

        [Display(Name = "Relation Value")]
        public decimal? RelationVal { get; set; }

        [Display(Name = "Occupation Value")]
        public decimal? OccupationVal { get; set; }

        [Display(Name = "Relation Text")]
        public string RelationText { get; set; }

        [Display(Name = "Occupation Text")]
        public string OccupationText { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        [Display(Name = "Modified On")]
        public string ModifiedOn { get; set; }
    }
}