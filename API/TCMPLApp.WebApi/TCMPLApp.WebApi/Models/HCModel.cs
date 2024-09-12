namespace TCMPLApp.WebApi.Models
{
    public class HCModel
    {
        public string Empno { get; set; }

        public string Yymm { get; set; }

        public string YearMode { get; set; }
        public string User { get; set; }

        public string Yyyy { get; set; }

        public string Reportid { get; set; }
        public string Category { get; set; }

        public string ReportType { get; set; }

        public string Simul { get; set; }
        public string Runmode { get; set; }
        public string Costcode { get; set; }
        public string Status { get; set; }

        public string KeyId { get; set; }
        public string LogMessage { get; set; }

        public string Htmlcontent { get; set; }  

        public string MailTo { get; set; }
        public string MailCc { get; set; }
        public string MailBcc { get; set; }
        public string MailSubject { get; set; }
        public string MailBody1 { get; set; }
        public string MailBody2 { get; set; }
        public string MailType { get; set; }
        public string MailFrom { get; set; }
        public string MailFormatType { get; set; }
        public List<IFormFile> Files { get; set; }

    }
}
