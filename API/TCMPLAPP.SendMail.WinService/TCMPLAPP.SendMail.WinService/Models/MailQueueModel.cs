using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLAPP.SendMail.WinService.Models
{
    public class MailQueueModel
    {
        public string? KeyId { get; set; }
        public DateTime EntryDate { get; set; }
        public DateTime ModifiedOn { get; set; }
        public decimal StatusCode { get; set; }
        public string? StatusMessage { get; set; }
        public string? MailTo { get; set; }
        public string? MailCc { get; set; }
        public string? MailBcc { get; set; }
        public string? MailSubject { get; set; }
        public string? MailBody1 { get; set; }
        public string? MailBody2 { get; set; }
        public string? MailType { get; set; }
        public string? MailFrom { get; set; }
        public string? MailAttachmentsOsName { get; set; }
        public string? MailAttachmentsBusinessName { get; set; }

    }


}
