using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.EmpGenInfo
{
    public class ICardConsentStatusDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Employee Id")]
        public string Empno { get; set; }

        [Display(Name = "Employee Name")]
        public string Name { get; set; }

        [Display(Name = "Consent Date")]
        public string ConsentDate { get; set; }

        [Display(Name = "Photo Change Date")]
        public string PhotoChangedDate { get; set; }

        [Display(Name = "HR Reset Date")]
        public string HrResetDate { get; set; }

        [Display(Name = "HR Name")]
        public string HrName { get; set; }

        [Display(Name = "Is Consent")]
        public string IsConsent { get; set; }
    }

    public class ICardConsentStatusXlDataTableList
    {
        public string Empno { get; set; }
        public string Employee { get; set; }
        public string Email { get; set; }
        public string ParentCode { get; set; }
        public string ParentName { get; set; }
        public string IsConsent { get; set; }
        public DateTime? ConsentDate { get; set; }
        public string NewImgUploaded { get; set; }
        public DateTime? NewImgUploadDate { get; set; }
        public DateTime? HrResetDate { get; set; }
        public string HrResetBy { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public string ModifiedBy { get; set; }
    }
}