using System.ComponentModel.DataAnnotations;

namespace TCMPLAPP.WinService.Models
{
    //Http Client Model
    public class HCModel
    {
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Htmlcontent")]
        public string Htmlcontent { get; set; }

        [Display(Name = "Year month")]
        public string Yymm { get; set; }

        [Display(Name = "Year mode")]
        public string YearMode { get; set; }

        public string Keyid { get; set; }
        public string User { get; set; }

        [Display(Name = "Year")]
        public string Yyyy { get; set; }

        [Display(Name = "Report id")]
        public string Reportid { get; set; }

        public string Category { get; set; }

        [Display(Name = "Report type")]
        public string ReportType { get; set; }

        [Display(Name = "Simulation")]
        public string Simul { get; set; }

        public string Runmode { get; set; }
        public string Costcode { get; set; }
        public string Status { get; set; }

        public string KeyId { get; set; }
        public string LogMessage { get; set; }

        public string MailTo { get; set; }
        public string MailCc { get; set; }
        public string MailBcc { get; set; }
        public string MailSubject { get; set; }
        public string MailBody1 { get; set; }
        public string MailBody2 { get; set; }
        public string MailType { get; set; }
        public string MailFrom { get; set; }
        public string MailAttachmentsOsNm { get; set; }
        public string MailAttachmentsBusinessNm { get; set; }

        public string Yyyymm { get; set; }
        public string CostcodeGroupId { get; set; }
        public string CostcodeGroupName { get; set; }
        public string ReportMode { get; set; }

        public string Projno { get; set; }
    }
}