using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class EmailDetailsViewModel
    {
        [Display(Name = "KeyId")]
        public string KeyId { get; set; }

        [Display(Name = "Entry date")]
        public string EntryDate { get; set; }

        [Display(Name = "Modified On")]
        public string ModifiedOn { get; set; }

        [Display(Name = "Status code")]
        public string StatusCode { get; set; }

        [Display(Name = "Status description ")]
        public string StatusDesc { get; set; }

        [Display(Name = "Status message")]
        public string StatusMessage { get; set; }

        [Display(Name = "MailTo")]
        public string MailTo { get; set; }

        [Display(Name = "MailCc")]
        public string MailCc { get; set; }

        [Display(Name = "MailBcc")]
        public string MailBcc { get; set; }

        [Display(Name = "Mail subject")]
        public string MailSubject { get; set; }

        [Display(Name = "MailBody1")]
        public string MailBody1 { get; set; }

        [Display(Name = "MailBody2")]
        public string MailBody2 { get; set; }

        [Display(Name = "MailType")]
        public string MailType { get; set; }

        [Display(Name = "MailFrom")]
        public string MailFrom { get; set; }

        [Display(Name = "MailAttachOs")]
        public string MailAttachOs { get; set; }

        [Display(Name = "MailAttachBusiness")]
        public string MailAttachBusiness { get; set; }
    }
}