using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookingPreferencesDetailViewModel
    {
        public string KeyId { get; set; }

        [Required]
        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        [Display(Name = "Parent")]
        public string ParentDesc { get; set; }

        [Display(Name = "Assign")]
        public string AssignDesc { get; set; }

        [Required]
        [Display(Name = "Office")]
        public string DeskOffice { get; set; }

        [Required]
        [Display(Name = "Shift")]
        public string Shift { get; set; }

        public string ShiftDesc { get; set; }

        [Required]
        [Display(Name = "Desk Aeas")]
        public string DeskArea { get; set; }

        public string DeskAreaDesc { get; set; }

        [Required]
        [Display(Name = "Booking Date")]
        public string BookingDate { get; set; }

        [Required]
        [Display(Name = "Desk")]
        public string Desk { get; set; }

        [Display(Name = "Current Office Location")]
        public string CurrentOfficeLocation { get; set; }
    }
}