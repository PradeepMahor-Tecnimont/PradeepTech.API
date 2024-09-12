using System.ComponentModel.DataAnnotations;
namespace TCMPLApp.WebApp.Models
{
    public class DeskBookingPreferencesUpdateViewModel
    {

        public string KeyId { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Employee name")]
        public string EmployeeName { get; set; }

        [Display(Name = "Grade")]
        public string EmpGrade { get; set; }

        [Display(Name = "Current Office Location")]
        public string CurrentOfficeLocation { get; set; }

        [Display(Name = "Employee type")]
        public string Emptype { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        [Display(Name = "Assign")]
        public string Assign { get; set; }

        public string ParentDesc { get; set; }
        public string AssignDesc { get; set; }


        [Display(Name = "Booking Date")]
        public string BookingDate { get; set; }


        [Required]
        [Display(Name = "Office")]
        public string Office { get; set; }


        [Required]
        [Display(Name = "Shift")]
        public string Shift { get; set; }

        [Required]
        [Display(Name = "Desk Aeas")]
        public string DeskArea { get; set; }
    }
}
