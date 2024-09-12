using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.Timesheet
{
    public class TSStatusReminderEmail
    {
        [Display(Name = "Recepient mail")]
        public string RecepientMail { get; set; }
        
    }
}