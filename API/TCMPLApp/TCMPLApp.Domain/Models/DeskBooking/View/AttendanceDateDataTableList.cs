using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class AttendanceDateDataTableList
    {
        [Display(Name = "Id")]
        public string Id { get; set; }

        //[Display(Name = "Emp no")]
        //public string Empno { get; set; }

        [Display(Name = "Title")] // Empno no : Emp name
        public string Title { get; set; }

        //[Display(Name = "Employee")]
        //public string Employee { get; set; }

        [Display(Name = "Start")]
        public DateTime Start { get; set; }

        [Display(Name = "End")]
        public DateTime End { get; set; }

        [Display(Name = "Background color")]
        public string BackgroundColor {  get; set; }
        //[Display(Name = "Can Exclude")]
        //public string CanExclude { get; set; }
    }
}