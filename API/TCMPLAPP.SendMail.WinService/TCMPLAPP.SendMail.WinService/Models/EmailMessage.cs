using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLAPP.SendMail.WinService.Models
{
    public enum EmailContentType
    {
        Plain,
        Html
    }

    public class EmailMessage
    {
        //public EmailMessage()
        //{
        //    ToAddresses = new List<EmailAddress>();
        //    CcAddresses = new List<EmailAddress>();
        //    BccAddresses = new List<EmailAddress>();
        //    FromAddresses = new List<EmailAddress>();
        //    EmailAttachments = new List<EmailAttachment>();
        //    EmailLinkedResources = new List<EmailLinkedResource>();
        //}

        //public List<EmailAddress> ToAddresses { get; set; }
        //public List<EmailAddress> CcAddresses { get; set; }
        //public List<EmailAddress> BccAddresses { get; set; }
        //public List<EmailAddress> FromAddresses { get; set; }
        //public List<EmailAttachment> EmailAttachments { get; set; }
        //public List<EmailLinkedResource> EmailLinkedResources { get; set; }
        public string Subject { get; set; } = "";
        public string Content { get; set; } = "";
        public EmailContentType ContentType { get; set; } = EmailContentType.Html;
    }
}
