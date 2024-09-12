using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.MailQueue
{ 
    public class MailQueueMails
    {
        public string KeyId { get; set; }
        public DateTime EntryDate { get; set; }
        public DateTime ModifiedOn { get; set; }    

        public decimal StatusCode { get; set; }

        public string StatusMessage { get; set; }
        public string MailTo { get; set; }
        public string MailFrom { get; set; }
        public string MailCc{ get; set; }
        public string MailBcc { get; set; }
        public string MailSubject{ get; set; }
        public string MailBody1 { get; set; }
        public string MailBody2 { get; set; }
        public string MailType{ get; set; }
        public string MailAttachements { get; set; }
        
    }
}
